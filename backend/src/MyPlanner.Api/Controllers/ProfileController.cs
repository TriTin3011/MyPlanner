using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using MyPlanner.BLL.Profile;
using MyPlanner.Core.Dtos;

namespace MyPlanner.Api.Controllers;

[ApiController]
[Route("api/profile")]
public class ProfileController(IProfileService profile) : ControllerBase
{
    public const string AvatarRateLimitPolicy = "avatar";

    [HttpPatch]
    [ProducesResponseType<CurrentUserDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ValidationProblemDetails>(StatusCodes.Status400BadRequest)]
    public Task<CurrentUserDto> Update(UpdateProfileRequest request, CancellationToken ct) =>
        profile.UpdateAsync(request, ct);

    // Chặn ở tầng HTTP trước khi đọc body; chừa thêm 1 MB cho phần bao multipart.
    [HttpPut("avatar")]
    [Consumes("multipart/form-data")]
    [RequestSizeLimit(ProfileService.MaxUploadBytes + 1024 * 1024)]
    [RequestFormLimits(MultipartBodyLengthLimit = ProfileService.MaxUploadBytes + 1024 * 1024)]
    [EnableRateLimiting(AvatarRateLimitPolicy)]
    [ProducesResponseType<AvatarDto>(StatusCodes.Status200OK)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status400BadRequest)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status429TooManyRequests)]
    [ProducesResponseType<ProblemDetails>(StatusCodes.Status503ServiceUnavailable)]
    public async Task<AvatarDto> UploadAvatar(IFormFile file, CancellationToken ct)
    {
        await using var stream = file.OpenReadStream();
        return await profile.UploadAvatarAsync(stream, file.Length, ct);
    }

    [HttpDelete("avatar")]
    [ProducesResponseType<AvatarDto>(StatusCodes.Status200OK)]
    public Task<AvatarDto> DeleteAvatar(CancellationToken ct) => profile.DeleteAvatarAsync(ct);
}
