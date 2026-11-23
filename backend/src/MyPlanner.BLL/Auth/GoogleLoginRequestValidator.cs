using FluentValidation;
using MyPlanner.BLL.Localization;
using MyPlanner.Core.Dtos;

namespace MyPlanner.BLL.Auth;

public class GoogleLoginRequestValidator : AbstractValidator<GoogleLoginRequest>
{
    public GoogleLoginRequestValidator()
    {
        // ID token của Google dài khoảng 1–2 KB. Chặn chuỗi quá dài trước khi đem đi giải mã.
        RuleFor(x => x.IdToken).NotEmpty().WithMessage(_ => Messages.InvalidGoogleToken).MaximumLength(4096);
    }
}
