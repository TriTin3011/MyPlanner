namespace MyPlanner.Core.Dtos;

// Kết quả GET /api/health. Status: "ok" | "degraded"; Database: kết nối được Postgres hay không.
public record HealthDto(string Status, bool Database);
