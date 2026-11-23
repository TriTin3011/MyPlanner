using Amazon.Runtime;
using Amazon.S3;
using Amazon.S3.Model;
using Amazon.S3.Util;
using Microsoft.Extensions.Options;
using MyPlanner.Core.Storage;

namespace MyPlanner.DAL.Storage;

// Adapter giao thức S3, dùng chung cho MinIO và Cloudflare R2. Singleton vì AmazonS3Client giữ connection pool.
public sealed class S3FileStorage : IFileStorage, IDisposable
{
    private readonly StorageOptions _options;
    private readonly AmazonS3Client? _client;
    private readonly Protocol _protocol;
    private readonly SemaphoreSlim _bucketLock = new(1, 1);
    private bool _bucketReady;

    public S3FileStorage(IOptions<StorageOptions> options)
    {
        _options = options.Value;
        if (!_options.IsConfigured) return;

        _protocol = _options.Endpoint.StartsWith("https:", StringComparison.OrdinalIgnoreCase) ? Protocol.HTTPS : Protocol.HTTP;
        _client = new AmazonS3Client(
            new BasicAWSCredentials(_options.AccessKey, _options.SecretKey),
            new AmazonS3Config
            {
                ServiceURL = _options.Endpoint,
                AuthenticationRegion = _options.Region,
                ForcePathStyle = true, // MinIO local không có DNS dạng bucket.host
                // R2 chưa hỗ trợ checksum mặc định của SDK mới, nên chỉ tính khi API bắt buộc.
                RequestChecksumCalculation = RequestChecksumCalculation.WHEN_REQUIRED,
                ResponseChecksumValidation = ResponseChecksumValidation.WHEN_REQUIRED,
                Timeout = TimeSpan.FromSeconds(15),
                MaxErrorRetry = 1,
            });
    }

    public bool IsConfigured => _client is not null;

    public async Task PutAsync(string key, Stream content, string contentType, CancellationToken ct)
    {
        var client = RequireClient();
        await RunAsync(async () =>
        {
            await EnsureBucketAsync(client, ct);
            await client.PutObjectAsync(new PutObjectRequest
            {
                BucketName = _options.Bucket,
                Key = key,
                InputStream = content,
                ContentType = contentType,
                UseChunkEncoding = false, // R2 không nhận kiểu chunk có chữ ký
                AutoCloseStream = false,
            }, ct);
        });
    }

    public string? GetReadUrl(string key, TimeSpan lifetime) =>
        _client?.GetPreSignedURL(new GetPreSignedUrlRequest
        {
            BucketName = _options.Bucket,
            Key = key,
            Verb = HttpVerb.GET,
            Protocol = _protocol,
            Expires = DateTime.UtcNow.Add(lifetime),
        });

    public async Task DeleteAsync(string key, CancellationToken ct)
    {
        var client = RequireClient();
        await RunAsync(() => client.DeleteObjectAsync(_options.Bucket, key, ct));
    }

    private AmazonS3Client RequireClient() =>
        _client ?? throw new FileStorageException("Storage is not configured.");

    private async Task EnsureBucketAsync(AmazonS3Client client, CancellationToken ct)
    {
        if (_bucketReady || !_options.AutoCreateBucket) return;
        await _bucketLock.WaitAsync(ct);
        try
        {
            if (_bucketReady) return;
            if (!await AmazonS3Util.DoesS3BucketExistV2Async(client, _options.Bucket))
                await client.PutBucketAsync(_options.Bucket, ct);
            _bucketReady = true;
        }
        finally
        {
            _bucketLock.Release();
        }
    }

    private static async Task RunAsync(Func<Task> action)
    {
        try
        {
            await action();
        }
        catch (Exception ex) when (ex is AmazonServiceException or AmazonClientException or HttpRequestException or TimeoutException)
        {
            throw new FileStorageException("Storage request failed.", ex);
        }
    }

    public void Dispose()
    {
        _client?.Dispose();
        _bucketLock.Dispose();
    }
}
