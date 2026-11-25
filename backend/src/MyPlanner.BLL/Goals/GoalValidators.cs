using FluentValidation;
using MyPlanner.BLL.Localization;
using MyPlanner.Core.Dtos;
using MyPlanner.DAL.Goals;

namespace MyPlanner.BLL.Goals;

public class SaveGoalRequestValidator : AbstractValidator<SaveGoalRequest>
{
    public SaveGoalRequestValidator()
    {
        RuleFor(x => x.Title).NotEmpty().WithMessage(_ => Messages.GoalTitleRequired).MaximumLength(300);
        RuleFor(x => x.AreaId).NotEmpty().WithMessage(_ => Messages.GoalAreaNotFound);
        RuleFor(x => x.Status).IsInEnum();
        RuleFor(x => x.Reward).MaximumLength(500);
        RuleFor(x => x.Why).MaximumLength(2_000);
        RuleFor(x => x.Deadline).GreaterThanOrEqualTo(x => x.StartDate)
            .WithMessage(_ => Messages.GoalDeadlineOrder);
    }
}

public class CreateGoalAreaRequestValidator : AbstractValidator<CreateGoalAreaRequest>
{
    public CreateGoalAreaRequestValidator()
    {
        RuleFor(x => x.Name).Must(n => !string.IsNullOrWhiteSpace(n)).WithMessage(_ => Messages.GoalAreaNameRequired)
            .Must(n => n is null || n.Trim().Length <= GoalAreaLimits.NameMaxLength)
            .WithMessage(_ => Messages.GoalAreaNameTooLong(GoalAreaLimits.NameMaxLength));
    }
}

public class SaveGoalStepRequestValidator : AbstractValidator<SaveGoalStepRequest>
{
    public SaveGoalStepRequestValidator()
    {
        RuleFor(x => x.Title).NotEmpty().WithMessage(_ => Messages.GoalStepTitleRequired).MaximumLength(300);
    }
}
