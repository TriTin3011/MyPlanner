namespace MyPlanner.Core.Entities;

// Dòng dữ liệu thuộc về một tài khoản (SPEC §12.0). Mọi bảng dữ liệu người dùng đều có cột UserId, kể cả bảng con
// (Subtask, GoalStep, HabitLog), vì repository có truy vấn thẳng vào bảng con: thiếu cột thì lọc theo người dùng phải JOIN.
// Service không tự gán UserId: AppDbContext đóng dấu khi thêm dòng và lọc khi đọc (global query filter).
public interface IUserOwned
{
    Guid UserId { get; set; }
}
