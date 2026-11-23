using System.Windows.Controls;

namespace MyPlanner.Desktop.Views;

public partial class LoginView : UserControl
{
    public LoginView()
    {
        InitializeComponent();
        // Mở màn là gõ được tên ngay.
        Loaded += (_, _) => UserNameBox.Focus();
    }
}
