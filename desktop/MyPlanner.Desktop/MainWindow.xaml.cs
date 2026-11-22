using System.Windows;
using MyPlanner.Desktop.ViewModels;

namespace MyPlanner.Desktop;

// Code-behind chỉ gắn DataContext và kích hoạt lần tải đầu; logic nằm ở ViewModel.
public partial class MainWindow : Window
{
    public MainWindow(TodayViewModel viewModel)
    {
        InitializeComponent();
        DataContext = viewModel;
        Loaded += async (_, _) => await viewModel.LoadCommand.ExecuteAsync(null);
    }
}
