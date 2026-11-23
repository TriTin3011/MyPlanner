namespace MyPlanner.Core.Auth;

// "Ai đang gọi API". Api cài đặt bằng claim "sub" của JWT; DAL dùng để lọc và đóng dấu dữ liệu.
// Đặt ở Core vì DAL không được tham chiếu Api, còn Api không nên lộ HttpContext xuống dưới.
// Null khi không có người đăng nhập (health, login, lúc khởi động app, lệnh dotnet ef).
public interface ICurrentUser
{
    Guid? UserId { get; }
}
