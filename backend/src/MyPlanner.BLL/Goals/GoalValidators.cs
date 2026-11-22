using FluentValidation;
using MyPlanner.BLL.Localization;
using MyPlanner.Core.Dtos;

namespace MyPlanner.BLL.Goals;

public class SaveGoalRequestValidator : AbstractValidator<SaveGoalRequest>
{
    public SaveGoalRequestValidator()
    {
        RuleFor(x => x.Title).NotEmpty().WithMessage(_ => Messages.GoalTitleRequired).MaximumLength(300);
        RuleFor(x => x.Area).IsInEnum();
        RuleFor(x => x.Status).IsInEnum();
        RuleFor(x => x.Reward).MaximumLength(500);
        RuleFor(x => x.Why).MaximumLength(2_000);
        RuleFor(x => x.Deadline).GreaterThanOrEqualTo(x => x.StartDate)
            .WithMessage(_ => Messages.GoalDeadlineOrder);
    }
}

public class SaveGoalStepRequestValidator : AbstractValidator<SaveGoalStepRequest>
{
    public SaveGoalStepRequestValidator()
    {
        RuleFor(x => x.Title).NotEmpty().WithMessage(_ => Messages.GoalStepTitleRequired).MaximumLength(300);
    }
}
