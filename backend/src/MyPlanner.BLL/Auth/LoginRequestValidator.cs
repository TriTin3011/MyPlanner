using FluentValidation;
using MyPlanner.BLL.Localization;
using MyPlanner.Core.Dtos;

namespace MyPlanner.BLL.Auth;

public class LoginRequestValidator : AbstractValidator<LoginRequest>
{
    public LoginRequestValidator()
    {
        RuleFor(x => x.UserName).NotEmpty().WithMessage(_ => Messages.UserNameRequired).MaximumLength(64);
        // Giới hạn độ dài để không ai gửi chuỗi vài MB bắt server băm PBKDF2 (tốn CPU).
        RuleFor(x => x.Password).NotEmpty().WithMessage(_ => Messages.PasswordRequired).MaximumLength(256);
    }
}
