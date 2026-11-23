using System.Globalization;
using System.Windows;
using System.Windows.Data;

namespace MyPlanner.Desktop.Hosting;

// Có giá trị thì hiện, null thì ẩn: dùng cho nút "Thử lại" chỉ xuất hiện khi khởi động lỗi.
public sealed class NullToCollapsedConverter : IValueConverter
{
    public object Convert(object? value, Type targetType, object? parameter, CultureInfo culture) =>
        value is null ? Visibility.Collapsed : Visibility.Visible;

    public object ConvertBack(object? value, Type targetType, object? parameter, CultureInfo culture) =>
        throw new NotSupportedException();
}
