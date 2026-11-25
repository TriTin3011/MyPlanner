using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MyPlanner.DAL.Migrations
{
    /// <inheritdoc />
    public partial class AddFocusSessions : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "FocusSessions",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    UserId = table.Column<Guid>(type: "uuid", nullable: false),
                    StartedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    EndedAt = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: false),
                    Date = table.Column<DateOnly>(type: "date", nullable: false),
                    PlannedMinutes = table.Column<int>(type: "integer", nullable: false),
                    ActualMinutes = table.Column<int>(type: "integer", nullable: false),
                    Outcome = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    PlantKind = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    PotColor = table.Column<string>(type: "character varying(20)", maxLength: 20, nullable: false),
                    TaskId = table.Column<Guid>(type: "uuid", nullable: true),
                    HabitId = table.Column<Guid>(type: "uuid", nullable: true),
                    GoalId = table.Column<Guid>(type: "uuid", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_FocusSessions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_FocusSessions_Goals_GoalId",
                        column: x => x.GoalId,
                        principalTable: "Goals",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "FK_FocusSessions_Habits_HabitId",
                        column: x => x.HabitId,
                        principalTable: "Habits",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "FK_FocusSessions_Tasks_TaskId",
                        column: x => x.TaskId,
                        principalTable: "Tasks",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "FK_FocusSessions_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_FocusSessions_GoalId",
                table: "FocusSessions",
                column: "GoalId");

            migrationBuilder.CreateIndex(
                name: "IX_FocusSessions_HabitId",
                table: "FocusSessions",
                column: "HabitId");

            migrationBuilder.CreateIndex(
                name: "IX_FocusSessions_TaskId",
                table: "FocusSessions",
                column: "TaskId");

            migrationBuilder.CreateIndex(
                name: "IX_FocusSessions_UserId_Date",
                table: "FocusSessions",
                columns: new[] { "UserId", "Date" });

            migrationBuilder.CreateIndex(
                name: "IX_FocusSessions_UserId_EndedAt",
                table: "FocusSessions",
                columns: new[] { "UserId", "EndedAt" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "FocusSessions");
        }
    }
}
