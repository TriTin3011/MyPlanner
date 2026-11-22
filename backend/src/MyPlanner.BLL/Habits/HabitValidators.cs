using FluentValidation;
using MyPlanner.BLL.Localization;
using MyPlanner.Core.Dtos;

namespace MyPlanner.BLL.Habits;

public class SaveHabitRequestValidator : AbstractValidator<SaveHabitRequest>
{
    public SaveHabitRequestValidator()
    {
        RuleFor(x => x.Title).NotEmpty().WithMessage(_ => Messages.HabitTitleRequired).MaximumLength(200);
    }
}

public class ReorderRequestValidator : AbstractValidator<ReorderRequest>
{
    public ReorderRequestValidator()
    {
        RuleFor(x => x.Ids).NotEmpty().Must(ids => ids.Distinct().Count() == ids.Count).WithMessage(_ => Messages.DuplicateIds);
    }
}
