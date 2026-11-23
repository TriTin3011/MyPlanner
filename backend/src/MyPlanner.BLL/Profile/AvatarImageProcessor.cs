using SkiaSharp;

namespace MyPlanner.BLL.Profile;

// Hàm thuần: nhận byte người dùng gửi, trả ảnh WebP vuông do server tạo lại, hoặc null nếu không phải ảnh hợp lệ.
// Giải mã rồi mã hoá lại nên metadata (EXIF, GPS) và dữ liệu lạ giấu trong file đều bị bỏ.
public static class AvatarImageProcessor
{
    public const int OutputSize = 256;
    private const int WebpQuality = 82;
    private const long MaxSourcePixels = 64_000_000; // chặn "bom giải nén": file nhỏ nhưng kích thước khổng lồ
    private const long MaxDecodedPixels = 24_000_000;

    public static byte[]? Process(byte[] source)
    {
        using var data = SKData.CreateCopy(source);
        using var codec = SKCodec.Create(data);
        // Xét định dạng thật từ nội dung file, không tin đuôi file hay Content-Type do client gửi.
        if (codec is null || codec.EncodedFormat is not (SKEncodedImageFormat.Jpeg or SKEncodedImageFormat.Png or SKEncodedImageFormat.Webp))
            return null;

        var (width, height) = (codec.Info.Width, codec.Info.Height);
        if (width <= 0 || height <= 0 || (long)width * height > MaxSourcePixels) return null;

        // JPEG và WebP giải mã thẳng ở kích thước nhỏ hơn, đỡ tốn RAM với ảnh điện thoại.
        var scale = Math.Min(1f, OutputSize * 2f / Math.Min(width, height));
        var size = codec.GetScaledDimensions(scale);
        if ((long)size.Width * size.Height > MaxDecodedPixels) return null;

        var info = new SKImageInfo(size.Width, size.Height, SKColorType.Rgba8888, SKAlphaType.Premul);
        using var bitmap = new SKBitmap(info);
        if (codec.GetPixels(info, bitmap.GetPixels()) != SKCodecResult.Success) return null;

        using var surface = SKSurface.Create(new SKImageInfo(OutputSize, OutputSize, SKColorType.Rgba8888, SKAlphaType.Premul));
        var canvas = surface.Canvas;
        canvas.Clear(SKColors.Transparent);
        // Xoay quanh tâm trước khi cắt, vì bỏ EXIF mà không xoay thì ảnh chụp dọc sẽ nằm ngang.
        canvas.Translate(OutputSize / 2f, OutputSize / 2f);
        ApplyOrientation(canvas, codec.EncodedOrigin);

        var side = Math.Min(bitmap.Width, bitmap.Height);
        var crop = SKRectI.Create((bitmap.Width - side) / 2, (bitmap.Height - side) / 2, side, side);
        var half = OutputSize / 2f;
        using var image = SKImage.FromBitmap(bitmap);
        canvas.DrawImage(image, crop, new SKRect(-half, -half, half, half), new SKSamplingOptions(SKCubicResampler.Mitchell));
        canvas.Flush();

        using var snapshot = surface.Snapshot();
        using var encoded = snapshot.Encode(SKEncodedImageFormat.Webp, WebpQuality);
        return encoded?.ToArray();
    }

    private static void ApplyOrientation(SKCanvas canvas, SKEncodedOrigin origin)
    {
        switch (origin)
        {
            case SKEncodedOrigin.TopRight: canvas.Scale(-1, 1); break;
            case SKEncodedOrigin.BottomRight: canvas.RotateDegrees(180); break;
            case SKEncodedOrigin.BottomLeft: canvas.Scale(1, -1); break;
            case SKEncodedOrigin.LeftTop: canvas.RotateDegrees(90); canvas.Scale(1, -1); break;
            case SKEncodedOrigin.RightTop: canvas.RotateDegrees(90); break;
            case SKEncodedOrigin.RightBottom: canvas.RotateDegrees(90); canvas.Scale(-1, 1); break;
            case SKEncodedOrigin.LeftBottom: canvas.RotateDegrees(270); break;
        }
    }
}
