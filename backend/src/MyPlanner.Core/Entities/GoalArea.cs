namespace MyPlanner.Core.Entities;

// Lĩnh vực của mục tiêu, riêng cho từng tài khoản.
// - Lĩnh vực có sẵn: Key = một giá trị LifeArea, Name = null. Tên hiển thị do client dịch theo Key (vi/en).
// - Lĩnh vực người dùng tự thêm: Key = null, Name = tên họ gõ.
// Mỗi tài khoản luôn có đủ 8 lĩnh vực có sẵn (GoalAreaRepository tạo khi đọc lần đầu) và không xoá được chúng.
public class GoalArea : IUserOwned
{
    public Guid UserId { get; set; }
    public Guid Id { get; set; }
    public LifeArea? Key { get; set; }
    public string? Name { get; set; }
    public int Order { get; set; }
    public DateTimeOffset CreatedAt { get; set; }
}
