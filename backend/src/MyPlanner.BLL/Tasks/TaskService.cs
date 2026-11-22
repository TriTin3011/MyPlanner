using MyPlanner.BLL.Common;
using MyPlanner.BLL.Localization;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;
using MyPlanner.DAL.Tasks;

namespace MyPlanner.BLL.Tasks;

// Service: quy tắc nghiệp vụ của Task. Không biết HTTP, không biết SQL.
public class TaskService(ITaskRepository tasks, IRecurringRepository recurring, TimeProvider clock) : ITaskService
{
    public Task<List<TaskDto>> ListAsync(DateOnly from, DateOnly to, CancellationToken ct) => tasks.ListAsync(from, to, ct);

    public Task<List<TaskDto>> BacklogAsync(DateOnly today, CancellationToken ct) => tasks.BacklogAsync(today, ct);

    public async Task<TaskDto> CreateAsync(SaveTaskRequest req, CancellationToken ct)
    {
        var now = clock.GetUtcNow();
        var task = new TaskItem
        {
            Id = Guid.NewGuid(),
            Title = req.Title.Trim(),
            Date = req.Date,
            Tags = req.Tags?.Distinct().ToList() ?? [],
            Order = await tasks.NextOrderAsync(req.Date, ct),
            CreatedAt = now,
            UpdatedAt = now,
        };
        task.Subtasks = (req.Subtasks ?? []).Select((s, i) => new Subtask
        {
            Id = Guid.NewGuid(), TaskId = task.Id, Title = s.Title.Trim(), Done = s.Done, Order = i,
        }).ToList();

        tasks.Add(task);
        await tasks.SaveChangesAsync(ct);
        return await GetOrThrow(task.Id, ct);
    }

    public async Task<TaskDto> UpdateAsync(Guid id, SaveTaskRequest req, CancellationToken ct)
    {
        var task = await tasks.FindAsync(id, ct) ?? throw AppException.NotFound(Messages.Task);

        if (task.Date != req.Date)
        {
            task.Order = await tasks.NextOrderAsync(req.Date, ct); // sang ngày khác thì xếp cuối ngày đó
            task.Date = req.Date;
        }
        task.Title = req.Title.Trim();
        task.Tags = req.Tags?.Distinct().ToList() ?? [];

        // Đồng bộ danh sách bước con: xoá cái không còn, sửa cái có id, thêm cái mới. Thứ tự = vị trí gửi lên.
        var input = req.Subtasks ?? [];
        var keepIds = input.Where(s => s.Id.HasValue).Select(s => s.Id!.Value).ToHashSet();
        task.Subtasks.RemoveAll(s => !keepIds.Contains(s.Id));
        for (var i = 0; i < input.Count; i++)
        {
            var s = input[i];
            var existing = s.Id is { } sid ? task.Subtasks.FirstOrDefault(x => x.Id == sid) : null;
            if (existing is null)
            {
                task.Subtasks.Add(new Subtask { Id = Guid.NewGuid(), TaskId = task.Id, Title = s.Title.Trim(), Done = s.Done, Order = i });
            }
            else
            {
                existing.Title = s.Title.Trim();
                existing.Done = s.Done;
                existing.Order = i;
            }
        }

        task.UpdatedAt = clock.GetUtcNow();
        await tasks.SaveChangesAsync(ct);
        return await GetOrThrow(id, ct);
    }

    public async Task<TaskDto> SetDoneAsync(Guid id, bool done, CancellationToken ct)
    {
        var task = await tasks.FindAsync(id, ct) ?? throw AppException.NotFound(Messages.Task);
        if (task.Done != done)
        {
            task.Done = done;
            task.DoneAt = done ? clock.GetUtcNow() : null; // doneAt dùng cho thống kê
            task.UpdatedAt = clock.GetUtcNow();
            await tasks.SaveChangesAsync(ct);
        }
        return await GetOrThrow(id, ct);
    }

    public async Task DeleteAsync(Guid id, CancellationToken ct)
    {
        var task = await tasks.FindAsync(id, ct) ?? throw AppException.NotFound(Messages.Task);

        // Xoá việc sinh từ việc lặp lại: ghi nhớ ngày đó để materialize không sinh lại (SPEC §12.2).
        if (task.RecurringId is { } rid && await recurring.FindAsync(rid, ct) is { } rule)
        {
            var date = task.OriginalDate ?? task.Date;
            if (!rule.SkippedDates.Contains(date)) rule.SkippedDates.Add(date);
        }

        tasks.Remove(task);
        await tasks.SaveChangesAsync(ct); // một SaveChanges lưu cả hai thay đổi (cùng DbContext) trong một transaction
    }

    public async Task<int> MoveBacklogToTodayAsync(DateOnly today, CancellationToken ct)
    {
        var backlog = await tasks.FindUndoneBeforeAsync(today, ct);
        var order = await tasks.NextOrderAsync(today, ct);
        var now = clock.GetUtcNow();
        foreach (var t in backlog)
        {
            t.OriginalDate ??= t.Date; // giữ ngày gốc lần đầu bị dời
            t.Date = today;
            t.Order = order++;
            t.UpdatedAt = now;
        }
        await tasks.SaveChangesAsync(ct);
        return backlog.Count;
    }

    public async Task ReorderAsync(ReorderTasksRequest req, CancellationToken ct)
    {
        var found = await tasks.FindManyAsync(req.Ids, ct);
        if (found.Count != req.Ids.Distinct().Count()) throw AppException.NotFound(Messages.SomeTasks);

        var byId = found.ToDictionary(t => t.Id);
        var now = clock.GetUtcNow();
        for (var i = 0; i < req.Ids.Count; i++)
        {
            var t = byId[req.Ids[i]];
            t.Date = req.Date; // kéo sang cột ngày khác ở màn Tuần
            t.Order = i;
            t.UpdatedAt = now;
        }
        await tasks.SaveChangesAsync(ct);
    }

    private async Task<TaskDto> GetOrThrow(Guid id, CancellationToken ct) =>
        await tasks.GetAsync(id, ct) ?? throw AppException.NotFound(Messages.Task);
}
