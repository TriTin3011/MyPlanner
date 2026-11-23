using System.Text.RegularExpressions;
using FluentValidation;
using MyPlanner.BLL.Localization;
using MyPlanner.Core.Dtos;

namespace MyPlanner.BLL.Auth;

// Luật cho tài khoản mới. Chặt hơn LoginRequestValidator: login chỉ cần "có nhập", còn đăng ký quyết định
// dữ liệu sẽ nằm mãi trong DB nên phải đúng định dạng ngay từ đầu.
public partial class RegisterRequestValidator : AbstractValidator<RegisterRequest>
{
    public RegisterRequestValidator()
    {
        // Kiểm trên dạng đã chuẩn hoá (trim + chữ thường), đúng dạng service sẽ lưu.
        RuleFor(x => x.UserName)
            .Must(n => n is not null && UserNamePattern().IsMatch(AuthService.Normalize(n)))
            .WithMessage(_ => Messages.UserNameFormat);
        RuleFor(x => x.Password)
            .NotEmpty().WithMessage(_ => Messages.PasswordRequired)
            .MinimumLength(AuthService.MinPasswordLength).WithMessage(_ => Messages.PasswordTooShort)
            .MaximumLength(256);
    }

    // Chỉ ASCII: tránh hai tên trông giống nhau nhưng khác mã Unicode ("tin" và "tіn" với chữ і Cyrillic).
    [GeneratedRegex("^[a-z0-9._-]{3,64}$")]
    private static partial Regex UserNamePattern();
}