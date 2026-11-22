using FluentValidation;
using MyPlanner.Core.Dtos;

namespace MyPlanner.BLL.Tasks;

// Validator chỉ kiểm tra HÌNH DẠNG dữ liệu (rỗng, độ dài, khoảng). Quy tắc cần DB (tồn tại hay chưa) nằm trong service.
public class SaveTaskRequestValidator : AbstractValidator<SaveTaskRequest>
{
    public SaveTaskRequestValidator()
    {
        RuleFor(x => x.Title).NotEmpty().WithMessage("Tên việc không được trống.").MaximumLength(500);
        RuleForEach(x => x.Subtasks).ChildRules(s =>
            s.RuleFor(x => x.Title).NotEmpty().WithMessage("Tên bước con không được trống.").MaximumLength(500));
        RuleFor(x => x.Subtasks).Must(s => s is null || s.Count <= 50).WithMessage("Tối đa 50 bước con.");
    }
}

public class ReorderTasksRequestValidator : AbstractValidator<ReorderTasksRequest>
{
    public ReorderTasksRequestValidator()
    {
        RuleFor(x => x.Ids).NotEmpty().Must(ids => ids.Distinct().Count() == ids.Count).WithMessage("Danh sách id bị trùng.");
    }
}

public class SaveRecurringRequestValidator : AbstractValidator<SaveRecurringRequest>
{
    public SaveRecurringRequestValidator()
    {
        RuleFor(x => x.Title).NotEmpty().WithMessage("Tên việc không được trống.").MaximumLength(500);
        RuleFor(x => x.Weekdays).NotEmpty().WithMessage("Chọn ít nhất một thứ trong tuần.");
        RuleForEach(x => x.Weekdays).InclusiveBetween(1, 7).WithMessage("Thứ phải từ 1 (Thứ 2) đến 7 (Chủ nhật).");
    }
}

public record MaterializeRequest(DateOnly From, DateOnly To, DateOnly Today);

public class MaterializeRequestValidator : AbstractValidator<MaterializeRequest>
{
    public MaterializeRequestValidator()
    {
        RuleFor(x => x.To).GreaterThanOrEqualTo(x => x.From).WithMessage("'to' phải sau hoặc bằng 'from'.");
        RuleFor(x => x).Must(x => x.To.DayNumber - x.From.DayNumber <= 62).WithMessage("Khoảng tối đa 62 ngày.");
    }
}
