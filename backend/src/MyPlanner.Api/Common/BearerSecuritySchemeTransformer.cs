using Microsoft.AspNetCore.OpenApi;
using Microsoft.OpenApi;

namespace MyPlanner.Api.Common;

// Thêm vào OpenAPI document: security scheme "Bearer" (HTTP bearer, định dạng JWT) và yêu cầu nó cho toàn bộ API.
// Nhờ vậy Scalar có ô nhập token, còn client sinh từ OpenAPI (TS, Dart) biết API cần header Authorization.
internal sealed class BearerSecuritySchemeTransformer : IOpenApiDocumentTransformer
{
    private const string SchemeId = "Bearer";

    public Task TransformAsync(OpenApiDocument document, OpenApiDocumentTransformerContext context, CancellationToken ct)
    {
        document.Components ??= new OpenApiComponents();
        document.Components.SecuritySchemes ??= new Dictionary<string, IOpenApiSecurityScheme>();
        document.Components.SecuritySchemes[SchemeId] = new OpenApiSecurityScheme
        {
            Type = SecuritySchemeType.Http,
            Scheme = "bearer",
            BearerFormat = "JWT",
            Description = "Token lấy từ POST /api/auth/login.",
        };

        document.Security ??= [];
        document.Security.Add(new OpenApiSecurityRequirement { [new OpenApiSecuritySchemeReference(SchemeId, document)] = [] });
        return Task.CompletedTask;
    }
}
