using System.Net.Http;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using MyPlanner.Desktop.Api;
using MyPlanner.Desktop.Auth;

namespace MyPlanner.Desktop.ViewModels;

// Màn đăng nhập. Mật khẩu KHÔNG là property bind được: PasswordBox cố ý không cho binding
// (tránh mật khẩu nằm dạng string trong ViewModel lâu hơn cần). View truyền nó qua CommandParameter.
public partial class LoginViewModel(PlannerApiClient api, TokenStore tokens) : ObservableObject
{
    [ObservableProperty]
    [NotifyCanExecuteChangedFor(nameof(LoginCommand))]
    private string _userName = "";

    [ObservableProperty] private string? _error;

    // ShellViewModel gán để chuyển sang màn Hôm nay khi đăng nhập xong.
    public Action? LoggedIn { get; set; }

    private bool CanLogin() => !string.IsNullOrWhiteSpace(UserName);

    [RelayCommand(CanExecute = nameof(CanLogin))]
    private async Task LoginAsync(object? passwordSource)
    {
        Error = null;
        var password = (passwordSource as System.Windows.Controls.PasswordBox)?.Password ?? "";
        try
        {
            var session = await api.LoginAsync(UserName.Trim(), password);
            if (session is null)
            {
                Error = "Sai tên đăng nhập hoặc mật khẩu.";
                return;
            }
            tokens.Save(session);
            LoggedIn?.Invoke();
        }
        catch (HttpRequestException ex) when (ex.StatusCode == System.Net.HttpStatusCode.TooManyRequests)
        {
            Error = "Thử quá nhiều lần. Đợi một lúc rồi thử lại.";
        }
        catch (HttpRequestException ex)
        {
            Error = $"Không gọi được API: {ex.Message}";
        }
    }
}
