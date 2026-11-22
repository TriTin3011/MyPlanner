using System.Globalization;
using MyPlanner.BLL.Common;
using MyPlanner.BLL.Tasks;
using MyPlanner.Core.Dtos;

namespace MyPlanner.BLL.Tests;

public class LocalizationTests
{
    [Theory]
    [InlineData("vi", "Tên việc không được trống.")]
    [InlineData("en", "Task title is required.")]
    public void Validator_uses_current_ui_culture(string cultureName, string expected)
    {
        using var _ = new UiCultureScope(cultureName);
        var request = new SaveTaskRequest("", new DateOnly(2026, 11, 22), null, null);

        var result = new SaveTaskRequestValidator().Validate(request);

        Assert.Contains(result.Errors, error => error.ErrorMessage == expected);
    }

    [Theory]
    [InlineData("vi", "Yêu cầu không hợp lệ")]
    [InlineData("en", "Invalid request")]
    public void AppException_title_uses_current_ui_culture(string cultureName, string expected)
    {
        using var _ = new UiCultureScope(cultureName);

        var exception = AppException.BadRequest("detail");

        Assert.Equal(expected, exception.Title);
    }

    private sealed class UiCultureScope : IDisposable
    {
        private readonly CultureInfo previous = CultureInfo.CurrentUICulture;

        public UiCultureScope(string cultureName) =>
            CultureInfo.CurrentUICulture = CultureInfo.GetCultureInfo(cultureName);

        public void Dispose() => CultureInfo.CurrentUICulture = previous;
    }
}
