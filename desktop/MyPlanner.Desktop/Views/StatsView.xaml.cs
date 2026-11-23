using System.Windows.Controls;
using System.Windows.Input;

namespace MyPlanner.Desktop.Views;

// Code-behind chỉ giữ hành vi thuần giao diện (cuộn), không chứa dữ liệu hay nghiệp vụ.
public partial class StatsView : UserControl
{
    public StatsView() => InitializeComponent();

    // Biểu đồ và ScrollViewer ngang của heatmap sẽ "nuốt" con lăn chuột; chuyển nó cho trang để vẫn cuộn dọc được.
    private void ForwardWheelToPage(object sender, MouseWheelEventArgs e)
    {
        e.Handled = true;
        PageScroll.ScrollToVerticalOffset(PageScroll.VerticalOffset - e.Delta);
    }

    // Khoảng dài (1 năm) rộng hơn thẻ: tự cuộn về cuối để thấy tuần gần nhất.
    private void HeatmapScroll_ScrollChanged(object sender, ScrollChangedEventArgs e)
    {
        if (e.ExtentWidthChange != 0 && sender is ScrollViewer scroll)
            scroll.ScrollToRightEnd();
    }
}
