using FluentValidation;
using Microsoft.EntityFrameworkCore;
using MyPlanner.BLL.Common;
using MyPlanner.BLL.Localization;
using MyPlanner.Core.Domain;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;
using MyPlanner.DAL.Focus;

namespace MyPlanner.BLL.Focus;

public interface IFocusService
{
    // Created = false khi Id đã có: client gửi lại (mất mạng, hàng đợi offline) thì nhận bản đã lưu, không thêm dòng.
    Task<(FocusSessionDto Session, bool Created)> SaveAsync(FocusSessionDto req, CancellationToken ct);
    Task<List<FocusSessionDto>> ListAsync(DateOnly from, DateOnly to, CancellationToken ct);
    Task<FocusBoardDto> GetBoardAsync(DateOnly today, CancellationToken ct);
}

public class FocusService(IFocusRepository focus) : IFocusService
{
    public async Task<(FocusSessionDto Session, bool Created)> SaveAsync(FocusSessionDto req, CancellationToken ct)
    {
        if (await focus.GetAsync(req.Id, ct) is { } existing) return (existing, false);

        // Liên kết phải thuộc tài khoản này. Filter giấu dòng của người khác nên câu trả lời là 404 như không tồn tại.
        if (req.TaskId is { } taskId && !await focus.TaskExistsAsync(taskId, ct)) throw AppException.NotFound(Messages.Task);
        if (req.HabitId is { } habitId && !await focus.HabitExistsAsync(habitId, ct)) throw AppException.NotFound(Messages.Habit);
        if (req.GoalId is { } goalId && !await focus.GoalExistsAsync(goalId, ct)) throw AppException.NotFound(Messages.Goal);

        // Mở khoá tính trên các phiên ĐÃ có (không tính phiên đang gửi): phải đủ giờ trước khi được chọn.
        var hours = FocusBoard.CompletedHours(await focus.AllAsync(ct));
        if (!FocusBoard.IsUnlocked(req.PlantKind, hours))
        {
            var need = FocusBoard.PlantThresholds.First(t => t.Plant == req.PlantKind).Hours - hours;
            throw AppException.BadRequest(Messages.FocusLocked(FocusBoard.PlantKey(req.PlantKind), need));
        }
        if (!FocusBoard.IsUnlocked(req.PotColor, hours))
        {
            var need = FocusBoard.PotThresholds.First(t => t.Pot == req.PotColor).Hours - hours;
            throw AppException.BadRequest(Messages.FocusLocked(FocusBoard.PotKey(req.PotColor), need));
        }

        // Client gửi giờ địa phương kèm offset (vd. +07:00); cột timestamptz của Npgsql chỉ nhận UTC.
        var session = new FocusSession
        {
            Id = req.Id, StartedAt = req.StartedAt.ToUniversalTime(), EndedAt = req.EndedAt.ToUniversalTime(), Date = req.Date,
            PlannedMinutes = req.PlannedMinutes, ActualMinutes = req.ActualMinutes, Outcome = req.Outcome,
            PlantKind = req.PlantKind, PotColor = req.PotColor,
            TaskId = req.TaskId, HabitId = req.HabitId, GoalId = req.GoalId,
        };
        if (!await focus.TryAddAsync(session, ct))
        {
            // Hai request cùng Id chạy song song: request thua đọc lại bản của request thắng.
            // Không đọc được nghĩa là Id trùng với dòng của tài khoản khác (bị filter giấu).
            var saved = await focus.GetAsync(req.Id, ct) ?? throw AppException.Conflict(Messages.DuplicateIds);
            return (saved, false);
        }
        return ((await focus.GetAsync(req.Id, ct))!, true);
    }

    public Task<List<FocusSessionDto>> ListAsync(DateOnly from, DateOnly to, CancellationToken ct) =>
        focus.ListAsync(from, to, ct);

    public async Task<FocusBoardDto> GetBoardAsync(DateOnly today, CancellationToken ct)
    {
        var sessions = await focus.AllAsync(ct);
        var linkIds = sessions
            .Where(s => s.Outcome == FocusOutcome.Completed)
            .Select(s => s.TaskId ?? s.HabitId ?? s.GoalId)
            .OfType<Guid>()
            .ToHashSet();
        var titles = await focus.LinkTitlesAsync(linkIds, ct);
        return FocusBoard.Build(sessions, today, titles);
    }
}

// Body của POST /focus/sessions. Kiểm hình dạng ở đây; quyền sở hữu liên kết và mở khoá cần DB nên nằm trong service.
public class FocusSessionValidator : AbstractValidator<FocusSessionDto>
{
    public FocusSessionValidator()
    {
        RuleFor(x => x.Id).NotEmpty().WithMessage(_ => Messages.FocusIdRequired);
        RuleFor(x => x.PlannedMinutes).InclusiveBetween(5, 180).WithMessage(_ => Messages.FocusPlannedRange);
        RuleFor(x => x.ActualMinutes)
            .Must((x, actual) => actual >= 0 && actual <= x.PlannedMinutes)
            .WithMessage(_ => Messages.FocusActualRange);
        RuleFor(x => x.EndedAt).GreaterThanOrEqualTo(x => x.StartedAt).WithMessage(_ => Messages.FocusTimeOrder);
        RuleFor(x => x)
            .Must(x => new[] { x.TaskId, x.HabitId, x.GoalId }.Count(id => id is not null) <= 1)
            .WithName("taskId")
            .WithMessage(_ => Messages.FocusOneLink);
        RuleFor(x => x.Outcome).IsInEnum();
        RuleFor(x => x.PlantKind).IsInEnum();
        RuleFor(x => x.PotColor).IsInEnum();
    }
}
