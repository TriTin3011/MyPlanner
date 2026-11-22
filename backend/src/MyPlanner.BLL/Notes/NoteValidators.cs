using FluentValidation;
using MyPlanner.Core.Dtos;

namespace MyPlanner.BLL.Notes;

public class SaveNoteRequestValidator : AbstractValidator<SaveNoteRequest>
{
    public SaveNoteRequestValidator()
    {
        RuleFor(x => x.Content).NotNull().MaximumLength(20_000);
    }
}

public class SaveYearMetaRequestValidator : AbstractValidator<SaveYearMetaRequest>
{
    public SaveYearMetaRequestValidator()
    {
        RuleFor(x => x.Keyword).NotNull().MaximumLength(100);
        RuleFor(x => x.Vision).NotNull().MaximumLength(5_000);
    }
}

public class CreateYearItemRequestValidator : AbstractValidator<CreateYearItemRequest>
{
    public CreateYearItemRequestValidator()
    {
        RuleFor(x => x.Month).InclusiveBetween(1, 12);
        RuleFor(x => x.Title).NotEmpty().MaximumLength(300);
    }
}

public class UpdateYearItemRequestValidator : AbstractValidator<UpdateYearItemRequest>
{
    public UpdateYearItemRequestValidator()
    {
        RuleFor(x => x.Month).InclusiveBetween(1, 12);
        RuleFor(x => x.Title).NotEmpty().MaximumLength(300);
    }
}
