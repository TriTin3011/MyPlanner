# Sinh lại packages/planner_api từ OpenAPI của backend.
# Cách dùng (trong thư mục mobile/):  ./tools/gen_api.ps1
# Backend phải đang chạy ở cổng 5274, hoặc truyền -Spec <đường dẫn file json>.
param([string]$Spec = 'http://localhost:5274/openapi/v1.json')
$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot -Parent)

if ($Spec -like 'http*') { Invoke-WebRequest $Spec -OutFile openapi/v1.json } elseif ((Resolve-Path $Spec).Path -ne (Resolve-Path openapi/v1.json -ErrorAction SilentlyContinue).Path) { Copy-Item $Spec openapi/v1.json }

$out = 'packages/planner_api'
New-Item -ItemType Directory -Force $out | Out-Null
# Không sinh test rỗng và tài liệu markdown, chỉ giữ mã nguồn.
Set-Content -Encoding utf8 "$out/.openapi-generator-ignore" "test/**`ndoc/**`n"

npx --yes @openapitools/openapi-generator-cli generate -c openapi/config.yaml | Out-Null

# json_serializable mới sinh cú pháp null-aware elements ('k': ?v), cần Dart >= 3.8.
$pub = "$out/pubspec.yaml"
(Get-Content $pub -Raw -Encoding utf8) -replace "sdk: '>=3\.5\.0 <4\.0\.0'", "sdk: '>=3.8.0 <4.0.0'" |
  Set-Content $pub -Encoding utf8 -NoNewline

Push-Location $out
flutter pub get | Out-Null
dart run build_runner build --delete-conflicting-outputs
Pop-Location
