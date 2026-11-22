using FluentValidation;
using MyPlanner.BLL.Localization;
using MyPlanner.Core.Domain;
using MyPlanner.Core.Dtos;

namespace MyPlanner.BLL.Stats;

public class StatsQueryValidator : AbstractValidator<StatsQuery>
{
    public StatsQueryValidator()
    {
        RuleFor(query => query.Range)
            .NotEmpty()
            .Must(StatsCalculator.IsSupportedRange)
            .WithMessage(_ => Messages.StatsRangeInvalid);
        RuleFor(query => query.Today)
            .Cascade(CascadeMode.Stop)
            .NotEqual(default(DateOnly))
            .WithMessage(_ => Messages.StatsTodayRequired)
            .Must((query, today) =>
                !StatsCalculator.IsSupportedRange(query.Range)
                || StatsCalculator.TryGetPeriod(query.Range, today, out _))
            .WithMessage(_ => Messages.StatsTodayTooEarly);
    }
}
