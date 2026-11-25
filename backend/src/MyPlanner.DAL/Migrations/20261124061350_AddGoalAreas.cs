using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MyPlanner.DAL.Migrations
{
    /// <summary>
    /// Lĩnh vực mục tiêu chuyển từ enum (cột Goals.Area) sang bảng GoalAreas riêng của mỗi tài khoản.
    /// Phần EF sinh ra (xoá cột Area rồi thêm AreaId mặc định Guid rỗng) sẽ làm mất lĩnh vực của mục tiêu cũ,
    /// nên được viết lại theo thứ tự: tạo bảng → tạo 8 lĩnh vực có sẵn cho mọi user → thêm AreaId cho phép null
    /// → điền AreaId theo Area cũ → mới đặt NOT NULL, xoá Area và gắn FK.
    /// </summary>
    public partial class AddGoalAreas : Migration
    {
        // Tên enum LifeArea theo thứ tự, đúng giá trị chuỗi đang lưu trong Goals.Area (HasConversion<string>).
        private const string BuiltIns =
            "('Health',0),('Finance',1),('Career',2),('Growth',3),('Relationship',4),('Learning',5),('Family',6),('Hobby',7)";

        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "GoalAreas",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    UserId = table.Column<Guid>(type: "uuid", nullable: false),
                    Key = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: true),
                    Name = table.Column<string>(type: "character varying(40)", maxLength: 40, nullable: true),
                    Order = table.Column<int>(type: "integer", nullable: false),
                    CreatedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_GoalAreas", x => x.Id);
                    table.ForeignKey(
                        name: "FK_GoalAreas_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_GoalAreas_UserId_Key",
                table: "GoalAreas",
                columns: new[] { "UserId", "Key" },
                unique: true,
                filter: "\"Key\" IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "IX_GoalAreas_UserId_Order",
                table: "GoalAreas",
                columns: new[] { "UserId", "Order" });

            // Mỗi tài khoản đang có được tạo sẵn 8 lĩnh vực. Tài khoản tạo sau sẽ được tạo lúc đọc lần đầu (GoalAreaRepository).
            migrationBuilder.Sql($"""
                INSERT INTO "GoalAreas" ("Id", "UserId", "Key", "Name", "Order", "CreatedAt")
                SELECT gen_random_uuid(), u."Id", k.key, NULL, k.ord, now()
                FROM "Users" u CROSS JOIN (VALUES {BuiltIns}) AS k(key, ord);
                """);

            migrationBuilder.AddColumn<Guid>(
                name: "AreaId",
                table: "Goals",
                type: "uuid",
                nullable: true);

            migrationBuilder.Sql("""
                UPDATE "Goals" g SET "AreaId" = a."Id"
                FROM "GoalAreas" a
                WHERE a."UserId" = g."UserId" AND a."Key" = g."Area";
                """);
            // Giá trị Area lạ (không thuộc enum) nếu có thì đưa về "Growth" thay vì để migration hỏng.
            migrationBuilder.Sql("""
                UPDATE "Goals" g SET "AreaId" = a."Id"
                FROM "GoalAreas" a
                WHERE g."AreaId" IS NULL AND a."UserId" = g."UserId" AND a."Key" = 'Growth';
                """);

            migrationBuilder.AlterColumn<Guid>(
                name: "AreaId",
                table: "Goals",
                type: "uuid",
                nullable: false,
                oldClrType: typeof(Guid),
                oldType: "uuid",
                oldNullable: true);

            migrationBuilder.DropColumn(
                name: "Area",
                table: "Goals");

            migrationBuilder.CreateIndex(
                name: "IX_Goals_AreaId",
                table: "Goals",
                column: "AreaId");

            migrationBuilder.AddForeignKey(
                name: "FK_Goals_GoalAreas_AreaId",
                table: "Goals",
                column: "AreaId",
                principalTable: "GoalAreas",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Goals_GoalAreas_AreaId",
                table: "Goals");

            migrationBuilder.DropIndex(
                name: "IX_Goals_AreaId",
                table: "Goals");

            migrationBuilder.AddColumn<string>(
                name: "Area",
                table: "Goals",
                type: "character varying(20)",
                maxLength: 20,
                nullable: false,
                defaultValue: "Growth");

            // Quay về enum: lĩnh vực có sẵn giữ nguyên, lĩnh vực tự tạo không có chỗ trong enum nên thành "Growth".
            migrationBuilder.Sql("""
                UPDATE "Goals" g SET "Area" = COALESCE(a."Key", 'Growth')
                FROM "GoalAreas" a
                WHERE a."Id" = g."AreaId";
                """);

            migrationBuilder.DropColumn(
                name: "AreaId",
                table: "Goals");

            migrationBuilder.DropTable(
                name: "GoalAreas");
        }
    }
}
