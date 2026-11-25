namespace MyPlanner.Core.Entities;

// Mục tiêu (SPEC §12.4). Goal là aggregate root, GoalStep chỉ được sửa thông qua Goal.
public class Goal : IUserOwned
{
    public Guid UserId { get; set; }
    public Guid Id { get; set; }
    public string Title { get; set; } = "";
    public Guid AreaId { get; set; }          // FK tới GoalArea của cùng tài khoản
    public GoalStatus Status { get; set; }
    public DateOnly StartDate { get; set; }   // mốc tính % thời gian
    public DateOnly Deadline { get; set; }
    public string? Reward { get; set; }
    public string? Why { get; set; }
    public List<GoalStep> Steps { get; set; } = [];
    public DateTimeOffset CreatedAt { get; set; }
    public DateTimeOffset? CompletedAt { get; set; }
}

public class GoalStep : IUserOwned
{
    public Guid UserId { get; set; }
    public Guid Id { get; set; }
    public Guid GoalId { get; set; }
    public string Title { get; set; } = "";
    public DateOnly? Deadline { get; set; }
    public bool Done { get; set; }
    public DateTimeOffset? DoneAt { get; set; }
    public int Order { get; set; }
}
