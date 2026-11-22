using FluentValidation;
using MyPlanner.Core.Dtos;

namespace MyPlanner.BLL.Goals;

public class SaveGoalRequestValidator : AbstractValidator<SaveGoalRequest>
{
    public SaveGoalRequestValidator()
    {
        RuleFor(x => x.Title).NotEmpty().WithMessage("Tên mục tiêu không được trống.").MaximumLength(300);
        RuleFor(x => x.Area).IsInEnum();
        RuleFor(x => x.Status).IsInEnum();
        RuleFor(x => x.Reward).MaximumLength(500);
        RuleFor(x => x.Why).MaximumLength(2_000);
        RuleFor(x => x.Deadline).GreaterThanOrEqualTo(x => x.StartDate)
            .WithMessage("Hạn chót phải sau ngày bắt đầu.");
    }
}

public class SaveGoalStepRequestValidator : AbstractValidator<SaveGoalStepRequest>
{
    public SaveGoalStepRequestValidator()
    {
        RuleFor(x => x.Title).NotEmpty().WithMessage("Tên bước không được trống.").MaximumLength(300);
    }
}
