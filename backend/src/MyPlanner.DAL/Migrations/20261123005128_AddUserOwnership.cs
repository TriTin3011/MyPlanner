using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MyPlanner.DAL.Migrations
{
    /// <inheritdoc />
    public partial class AddUserOwnership : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_YearPlanItems_Year_Month",
                table: "YearPlanItems");

            migrationBuilder.DropPrimaryKey(
                name: "PK_YearMeta",
                table: "YearMeta");

            migrationBuilder.DropPrimaryKey(
                name: "PK_WeekNotes",
                table: "WeekNotes");

            migrationBuilder.DropIndex(
                name: "IX_Tasks_Date",
                table: "Tasks");

            migrationBuilder.DropIndex(
                name: "IX_Tasks_Date_Done",
                table: "Tasks");

            migrationBuilder.DropIndex(
                name: "IX_HabitLogs_Date",
                table: "HabitLogs");

            migrationBuilder.DropIndex(
                name: "IX_GoalSteps_Deadline",
                table: "GoalSteps");

            migrationBuilder.DropIndex(
                name: "IX_Goals_Deadline",
                table: "Goals");

            migrationBuilder.DropPrimaryKey(
                name: "PK_DayNotes",
                table: "DayNotes");

            migrationBuilder.AddColumn<Guid>(
                name: "UserId",
                table: "YearPlanItems",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "UserId",
                table: "YearMeta",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "UserId",
                table: "WeekNotes",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "UserId",
                table: "Tasks",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "UserId",
                table: "Subtasks",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "UserId",
                table: "RecurringTasks",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "UserId",
                table: "Habits",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "UserId",
                table: "HabitLogs",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "UserId",
                table: "GoalSteps",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "UserId",
                table: "Goals",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<Guid>(
                name: "UserId",
                table: "DayNotes",
                type: "uuid",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            // Viết tay (EF không tự sinh): dữ liệu có từ thời một người dùng thuộc về tài khoản tạo sớm nhất.
            // Phải chạy SAU AddColumn (cột đã có, đang toàn Guid.Empty) và TRƯỚC AddForeignKey (Guid.Empty không
            // trỏ tới tài khoản nào nên FK sẽ từ chối). DB chưa có tài khoản nào thì không còn chủ để gán → xoá.
            string[] ownedTables =
            [
                "Tasks", "Subtasks", "RecurringTasks", "Habits", "HabitLogs", "Goals", "GoalSteps",
                "DayNotes", "WeekNotes", "YearMeta", "YearPlanItems",
            ];
            foreach (var table in ownedTables)
            {
                migrationBuilder.Sql($"""
                    UPDATE "{table}" SET "UserId" = (SELECT "Id" FROM "Users" ORDER BY "CreatedAt" LIMIT 1)
                    WHERE EXISTS (SELECT 1 FROM "Users");
                    DELETE FROM "{table}" WHERE NOT EXISTS (SELECT 1 FROM "Users");
                    """);
            }

            migrationBuilder.AddPrimaryKey(
                name: "PK_YearMeta",
                table: "YearMeta",
                columns: new[] { "UserId", "Year" });

            migrationBuilder.AddPrimaryKey(
                name: "PK_WeekNotes",
                table: "WeekNotes",
                columns: new[] { "UserId", "WeekKey" });

            migrationBuilder.AddPrimaryKey(
                name: "PK_DayNotes",
                table: "DayNotes",
                columns: new[] { "UserId", "Date" });

            migrationBuilder.CreateIndex(
                name: "IX_YearPlanItems_UserId_Year_Month",
                table: "YearPlanItems",
                columns: new[] { "UserId", "Year", "Month" });

            migrationBuilder.CreateIndex(
                name: "IX_Tasks_UserId_Date",
                table: "Tasks",
                columns: new[] { "UserId", "Date" });

            migrationBuilder.CreateIndex(
                name: "IX_Tasks_UserId_Date_Done",
                table: "Tasks",
                columns: new[] { "UserId", "Date", "Done" });

            migrationBuilder.CreateIndex(
                name: "IX_Subtasks_UserId",
                table: "Subtasks",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_RecurringTasks_UserId",
                table: "RecurringTasks",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Habits_UserId",
                table: "Habits",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_HabitLogs_UserId_Date",
                table: "HabitLogs",
                columns: new[] { "UserId", "Date" });

            migrationBuilder.CreateIndex(
                name: "IX_GoalSteps_UserId_Deadline",
                table: "GoalSteps",
                columns: new[] { "UserId", "Deadline" });

            migrationBuilder.CreateIndex(
                name: "IX_Goals_UserId_Deadline",
                table: "Goals",
                columns: new[] { "UserId", "Deadline" });

            migrationBuilder.AddForeignKey(
                name: "FK_DayNotes_Users_UserId",
                table: "DayNotes",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Goals_Users_UserId",
                table: "Goals",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_GoalSteps_Users_UserId",
                table: "GoalSteps",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_HabitLogs_Users_UserId",
                table: "HabitLogs",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Habits_Users_UserId",
                table: "Habits",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_RecurringTasks_Users_UserId",
                table: "RecurringTasks",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Subtasks_Users_UserId",
                table: "Subtasks",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Tasks_Users_UserId",
                table: "Tasks",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_WeekNotes_Users_UserId",
                table: "WeekNotes",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_YearMeta_Users_UserId",
                table: "YearMeta",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_YearPlanItems_Users_UserId",
                table: "YearPlanItems",
                column: "UserId",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_DayNotes_Users_UserId",
                table: "DayNotes");

            migrationBuilder.DropForeignKey(
                name: "FK_Goals_Users_UserId",
                table: "Goals");

            migrationBuilder.DropForeignKey(
                name: "FK_GoalSteps_Users_UserId",
                table: "GoalSteps");

            migrationBuilder.DropForeignKey(
                name: "FK_HabitLogs_Users_UserId",
                table: "HabitLogs");

            migrationBuilder.DropForeignKey(
                name: "FK_Habits_Users_UserId",
                table: "Habits");

            migrationBuilder.DropForeignKey(
                name: "FK_RecurringTasks_Users_UserId",
                table: "RecurringTasks");

            migrationBuilder.DropForeignKey(
                name: "FK_Subtasks_Users_UserId",
                table: "Subtasks");

            migrationBuilder.DropForeignKey(
                name: "FK_Tasks_Users_UserId",
                table: "Tasks");

            migrationBuilder.DropForeignKey(
                name: "FK_WeekNotes_Users_UserId",
                table: "WeekNotes");

            migrationBuilder.DropForeignKey(
                name: "FK_YearMeta_Users_UserId",
                table: "YearMeta");

            migrationBuilder.DropForeignKey(
                name: "FK_YearPlanItems_Users_UserId",
                table: "YearPlanItems");

            migrationBuilder.DropIndex(
                name: "IX_YearPlanItems_UserId_Year_Month",
                table: "YearPlanItems");

            migrationBuilder.DropPrimaryKey(
                name: "PK_YearMeta",
                table: "YearMeta");

            migrationBuilder.DropPrimaryKey(
                name: "PK_WeekNotes",
                table: "WeekNotes");

            migrationBuilder.DropIndex(
                name: "IX_Tasks_UserId_Date",
                table: "Tasks");

            migrationBuilder.DropIndex(
                name: "IX_Tasks_UserId_Date_Done",
                table: "Tasks");

            migrationBuilder.DropIndex(
                name: "IX_Subtasks_UserId",
                table: "Subtasks");

            migrationBuilder.DropIndex(
                name: "IX_RecurringTasks_UserId",
                table: "RecurringTasks");

            migrationBuilder.DropIndex(
                name: "IX_Habits_UserId",
                table: "Habits");

            migrationBuilder.DropIndex(
                name: "IX_HabitLogs_UserId_Date",
                table: "HabitLogs");

            migrationBuilder.DropIndex(
                name: "IX_GoalSteps_UserId_Deadline",
                table: "GoalSteps");

            migrationBuilder.DropIndex(
                name: "IX_Goals_UserId_Deadline",
                table: "Goals");

            migrationBuilder.DropPrimaryKey(
                name: "PK_DayNotes",
                table: "DayNotes");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "YearPlanItems");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "YearMeta");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "WeekNotes");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "Tasks");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "Subtasks");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "RecurringTasks");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "Habits");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "HabitLogs");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "GoalSteps");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "Goals");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "DayNotes");

            migrationBuilder.AddPrimaryKey(
                name: "PK_YearMeta",
                table: "YearMeta",
                column: "Year");

            migrationBuilder.AddPrimaryKey(
                name: "PK_WeekNotes",
                table: "WeekNotes",
                column: "WeekKey");

            migrationBuilder.AddPrimaryKey(
                name: "PK_DayNotes",
                table: "DayNotes",
                column: "Date");

            migrationBuilder.CreateIndex(
                name: "IX_YearPlanItems_Year_Month",
                table: "YearPlanItems",
                columns: new[] { "Year", "Month" });

            migrationBuilder.CreateIndex(
                name: "IX_Tasks_Date",
                table: "Tasks",
                column: "Date");

            migrationBuilder.CreateIndex(
                name: "IX_Tasks_Date_Done",
                table: "Tasks",
                columns: new[] { "Date", "Done" });

            migrationBuilder.CreateIndex(
                name: "IX_HabitLogs_Date",
                table: "HabitLogs",
                column: "Date");

            migrationBuilder.CreateIndex(
                name: "IX_GoalSteps_Deadline",
                table: "GoalSteps",
                column: "Deadline");

            migrationBuilder.CreateIndex(
                name: "IX_Goals_Deadline",
                table: "Goals",
                column: "Deadline");
        }
    }
}
