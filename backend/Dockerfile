FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy solution and project files first for layer caching
COPY MyPlanner.slnx ./
COPY src/MyPlanner.Api/MyPlanner.Api.csproj src/MyPlanner.Api/
COPY src/MyPlanner.BLL/MyPlanner.BLL.csproj src/MyPlanner.BLL/
COPY src/MyPlanner.Core/MyPlanner.Core.csproj src/MyPlanner.Core/
COPY src/MyPlanner.DAL/MyPlanner.DAL.csproj src/MyPlanner.DAL/
COPY tests/MyPlanner.BLL.Tests/MyPlanner.BLL.Tests.csproj tests/MyPlanner.BLL.Tests/
COPY tests/MyPlanner.Core.Tests/MyPlanner.Core.Tests.csproj tests/MyPlanner.Core.Tests/

RUN dotnet restore

# Copy full source and publish
COPY . .
RUN dotnet publish src/MyPlanner.Api/MyPlanner.Api.csproj -c Release -o /app --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app

COPY --from=build /app ./

# Config comes only from env vars:
# ConnectionStrings__Default, Jwt__Key, Cors__Origins__0
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

USER app
ENTRYPOINT ["dotnet", "MyPlanner.Api.dll"]
