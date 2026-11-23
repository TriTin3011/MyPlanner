namespace MyPlanner.Desktop.ViewModels;

// Hợp đồng của một "trang" mà ShellViewModel điều hướng tới: có tên để hiện trên thanh điều hướng
// và một hàm nạp dữ liệu gọi mỗi lần trang được mở (giống loader của route ở web).
public interface IPageViewModel
{
    string PageTitle { get; }
    Task ActivateAsync();
}
