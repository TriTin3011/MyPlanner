namespace MyPlanner.Core.Dtos;

public record LoginRequest(string UserName, string Password);

// accessToken là JWT; client gửi lại trong header "Authorization: Bearer <accessToken>" ở mọi request sau.
// expiresAt để client biết lúc nào phải đăng nhập lại mà không cần tự giải mã token.
public record LoginResponse(string AccessToken, DateTimeOffset ExpiresAt, string UserName);

public record CurrentUserDto(string UserName);
