using FluentValidation;
using MyPlanner.BLL.Localization;
using MyPlanner.Core.Dtos;

namespace MyPlanner.BLL.Profile;

// Tên hiển thị không dùng để định danh nên được có dấu và được trùng người khác, khác với luật của UserName.
public class UpdateProfileRequestValidator : AbstractValidator<UpdateProfileRequest>
{
    public UpdateProfileRequestValidator()
    {
        RuleFor(x => x.DisplayName)
            .Must(name => name is null
                || (name.Trim().Length <= ProfileService.MaxDisplayNameLength && !name.Any(char.IsControl)))
            .WithMessage(_ => Messages.DisplayNameInvalid);
    }
}
