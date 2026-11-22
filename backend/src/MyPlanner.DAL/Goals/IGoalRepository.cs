using Microsoft.EntityFrameworkCore;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Goals;

// Aggregate Goal: Goal là gốc, GoalStep chỉ được sửa qua Goal (POST /goals/{id}/steps...).
public interface IGoalRepository
{
    Task<List<GoalDto>> ListAsync(CancellationToken ct);
    Task<GoalDto?> GetAsync(Guid id, CancellationToken ct);
    Task<Goal?> FindAsync(Guid id, CancellationToken ct);
    Task<List<(Guid GoalId, string GoalTitle, LifeArea Area, string Title, DateOnly Deadline, bool Done)>> StepDeadlinesAsync(
        DateOnly from, DateOnly to, CancellationToken ct);
    Task<List<(Guid GoalId, string Title, DateOnly Deadline, bool Done)>> GoalDeadlinesAsync(
        DateOnly from, DateOnly to, CancellationToken ct);
    Task<HashSet<DateOnly>> DeadlineDatesAsync(DateOnly from, DateOnly to, CancellationToken ct);
    void Add(Goal goal);
    void Remove(Goal goal);
    Task SaveChangesAsync(CancellationToken ct);
}
