using FluentValidation;
using MyPlanner.Core.Dtos;

namespace MyPlanner.BLL.Habits;

public class SaveHabitRequestValidator : AbstractValidator<SaveHabitRequest>
{
    public SaveHabitRequestValidator()
    {
        RuleFor(x => x.Title).NotEmpty().WithMessage("Tên thói quen không được trống.").MaximumLength(200);
    }
}

public class ReorderRequestValidator : AbstractValidator<ReorderRequest>
{
    public ReorderRequestValidator()
    {
        RuleFor(x => x.Ids).NotEmpty().Must(ids => ids.Distinct().Count() == ids.Count).WithMessage("Danh sách id bị trùng.");
    }
}
