using FluentValidation;
using MyPlanner.BLL.Localization;
using MyPlanner.Core.Dtos;

namespace MyPlanner.BLL.Auth;

public class RefreshRequestValidator : AbstractValidator<RefreshRequest>
{
    public RefreshRequestValidator()
    {
        // Token thật dài 43 ký tự. Chặn chuỗi quá dài trước khi băm.
        RuleFor(x => x.RefreshToken).NotEmpty().WithMessage(_ => Messages.InvalidRefreshToken).MaximumLength(128);
    }
}
