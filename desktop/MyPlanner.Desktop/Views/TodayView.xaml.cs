using System.Windows.Controls;

namespace MyPlanner.Desktop.Views;

// View thuần: DataContext do DataTemplate của MainWindow gán (TodayViewModel), không có logic.
public partial class TodayView : UserControl
{
    public TodayView() => InitializeComponent();
}
