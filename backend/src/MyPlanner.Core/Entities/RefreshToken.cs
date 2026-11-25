namespace MyPlanner.Core.Entities;

// Một mắt xích trong chuỗi refresh token của một phiên đăng nhập. Không phải IUserOwned: endpoint refresh chạy khi
// chưa có người dùng hiện tại, nên query filter theo tài khoản sẽ che mất dòng cần tìm.
public class RefreshToken
{
    public Guid Id { get; set; }
    public Guid UserId { get; set; }
    // Mọi token sinh ra từ cùng một lần đăng nhập có chung FamilyId. Phát hiện dùng lại thì thu hồi cả họ.
    public Guid FamilyId { get; set; }
    // SHA-256 của token. Không lưu token gốc: lộ bảng này cũng không dùng được để gia hạn phiên.
    public string TokenHash { get; set; } = "";
    public DateTimeOffset CreatedAt { get; set; }
    public DateTimeOffset ExpiresAt { get; set; }
    // Thời điểm token đã được đổi lấy token mới. Giữ lại dòng này để nhận ra khi có ai dùng lại nó.
    public DateTimeOffset? ConsumedAt { get; set; }
    // Thời điểm bị thu hồi do đăng xuất hoặc phát hiện dùng lại.
    public DateTimeOffset? RevokedAt { get; set; }
}
