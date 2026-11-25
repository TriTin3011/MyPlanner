using MyPlanner.BLL.Common;
using MyPlanner.BLL.Localization;
using MyPlanner.Core.Dtos;
using MyPlanner.Core.Entities;
using MyPlanner.DAL.Goals;

namespace MyPlanner.BLL.Goals;

public interface IGoalAreaService
{
    Task<List<GoalAreaDto>> ListAsync(CancellationToken ct);
    Task<GoalAreaDto> CreateAsync(CreateGoalAreaRequest req, CancellationToken ct);
    Task DeleteAsync(Guid id, CancellationToken ct);
}

// Lĩnh vực có sẵn (Key != null) chỉ đọc; người dùng thêm/xoá lĩnh vực riêng (Key = null, có Name).
public class GoalAreaService(IGoalAreaRepository areas, TimeProvider clock) : IGoalAreaService
{
    public Task<List<GoalAreaDto>> ListAsync(CancellationToken ct) => areas.ListAsync(ct);

    public async Task<GoalAreaDto> CreateAsync(CreateGoalAreaRequest req, CancellationToken ct)
    {
        var name = req.Name.Trim();
        await areas.ListAsync(ct); // bảo đảm bộ có sẵn đã được tạo, để lĩnh vực riêng xếp sau chúng
        var existing = await areas.CustomNamesAsync(ct);
        if (existing.Count >= GoalAreaLimits.MaxCustom)
            throw AppException.BadRequest(Messages.GoalAreaLimit(GoalAreaLimits.MaxCustom));
        // So trùng không phân biệt hoa thường, với cả tên riêng lẫn nhãn của lĩnh vực có sẵn ("Sức khoẻ" ≈ "sức khoẻ").
        if (existing.Concat(BuiltInLabels).Any(n => string.Equals(n, name, StringComparison.CurrentCultureIgnoreCase)))
            throw AppException.Conflict(Messages.GoalAreaDuplicate);

        var area = new GoalArea
        {
            Id = Guid.NewGuid(), Name = name, Order = await areas.NextOrderAsync(ct), CreatedAt = clock.GetUtcNow(),
        };
        areas.Add(area);
        await areas.SaveChangesAsync(ct);
        return new GoalAreaDto(area.Id, null, area.Name);
    }

    public async Task DeleteAsync(Guid id, CancellationToken ct)
    {
        var area = await areas.FindAsync(id, ct) ?? throw AppException.NotFound(Messages.GoalArea);
        if (area.Key is not null) throw AppException.BadRequest(Messages.GoalAreaBuiltIn);
        // Chặn thay vì xoá kèm: xoá nhầm một lĩnh vực không được kéo theo mất mục tiêu.
        if (await areas.InUseAsync(id, ct)) throw AppException.Conflict(Messages.GoalAreaInUse);
        areas.Remove(area);
        await areas.SaveChangesAsync(ct);
    }

    // Nhãn hiển thị của 8 lĩnh vực có sẵn ở cả hai ngôn ngữ (khớp i18n của web/WPF).
    private static readonly string[] BuiltInLabels =
    [
        "Sức khỏe", "Sức khoẻ", "Tài chính", "Sự nghiệp", "Phát triển", "Quan hệ", "Học tập", "Gia đình", "Sở thích",
        "Health", "Finance", "Career", "Growth", "Relationships", "Relationship", "Learning", "Family", "Hobbies", "Hobby",
    ];
}
