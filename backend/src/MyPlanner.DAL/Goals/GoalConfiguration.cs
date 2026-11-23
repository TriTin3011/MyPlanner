using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using MyPlanner.Core.Entities;

namespace MyPlanner.DAL.Goals;

public class GoalConfiguration : IEntityTypeConfiguration<Goal>
{
    public void Configure(EntityTypeBuilder<Goal> b)
    {
        b.ToTable("Goals");
        b.Property(g => g.Title).HasMaxLength(300);
        b.Property(g => g.Area).HasConversion<string>().HasMaxLength(20);
        b.Property(g => g.Status).HasConversion<string>().HasMaxLength(20);
        b.HasMany(g => g.Steps).WithOne().HasForeignKey(s => s.GoalId).OnDelete(DeleteBehavior.Cascade);
        b.HasIndex(g => new { g.UserId, g.Deadline });
    }
}

public class GoalStepConfiguration : IEntityTypeConfiguration<GoalStep>
{
    public void Configure(EntityTypeBuilder<GoalStep> b)
    {
        b.ToTable("GoalSteps");
        b.Property(s => s.Title).HasMaxLength(300);
        b.HasIndex(s => new { s.UserId, s.Deadline });
    }
}
