using FluentValidation;
using MyPlanner.BLL.Localization;
using MyPlanner.Core.Dtos;

namespace MyPlanner.BLL.Tasks;

// Validator chỉ kiểm tra HÌNH DẠNG dữ liệu (rỗng, độ dài, khoảng). Quy tắc cần DB (tồn tại hay chưa) nằm trong service.
public class SaveTaskRequestValidator : AbstractValidator<SaveTaskRequest>
{
    public SaveTaskRequestValidator()
    {
        RuleFor(x => x.Title).NotEmpty().WithMessage(_ => Messages.TaskTitleRequired).MaximumLength(500);
        RuleForEach(x => x.Subtasks).ChildRules(s =>
            s.RuleFor(x => x.Title).NotEmpty().WithMessage(_ => Messages.SubtaskTitleRequired).MaximumLength(500));
        RuleFor(x => x.Subtasks).Must(s => s is null || s.Count <= 50).WithMessage(_ => Messages.MaximumSubtasks);
    }
}

public class ReorderTasksRequestValidator : AbstractValidator<ReorderTasksRequest>
{
    public ReorderTasksRequestValidator()
    {
        RuleFor(x => x.Ids).NotEmpty().Must(ids => ids.Distinct().Count() == ids.Count).WithMessage(_ => Messages.DuplicateIds);
    }
}

public class SaveRecurringRequestValidator : AbstractValidator<SaveRecurringRequest>
{
    public SaveRecurringRequestValidator()
    {
        RuleFor(x => x.Title).NotEmpty().WithMessage(_ => Messages.TaskTitleRequired).MaximumLength(500);
        RuleFor(x => x.Weekdays).NotEmpty().WithMessage(_ => Messages.RecurringWeekdayRequired);
        RuleForEach(x => x.Weekdays).InclusiveBetween(1, 7).WithMessage(_ => Messages.RecurringWeekdayRange);
    }
}

public record MaterializeRequest(DateOnly From, DateOnly To, DateOnly Today);

public class MaterializeRequestValidator : AbstractValidator<MaterializeRequest>
{
    public MaterializeRequestValidator()
    {
        RuleFor(x => x.To).GreaterThanOrEqualTo(x => x.From).WithMessage(_ => Messages.MaterializeDateOrder);
        RuleFor(x => x).Must(x => x.To.DayNumber - x.From.DayNumber <= 62).WithMessage(_ => Messages.MaterializeMaximumRange);
    }
}
