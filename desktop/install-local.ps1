# Build the desktop app and API, install to %LOCALAPPDATA%\Programs\Mam, and add a Desktop shortcut.
# Run again after changing code. Secrets are read from the gitignored dev config and never printed.
$ErrorActionPreference = 'Stop'

$root = Split-Path $PSScriptRoot -Parent
$install = Join-Path $env:LOCALAPPDATA 'Programs\Mam'
$apiOut = Join-Path $install 'api'
$devConfig = Join-Path $root 'backend\src\MyPlanner.Api\appsettings.Development.json'

# Stop only the copy running from the install folder, so files are not locked.
Get-Process Mam, MyPlanner.Api -ErrorAction SilentlyContinue |
    Where-Object { $_.Path -and $_.Path.StartsWith($install, [StringComparison]::OrdinalIgnoreCase) } |
    Stop-Process -Force

Write-Host 'Publishing desktop app...'
dotnet publish (Join-Path $root 'desktop\MyPlanner.Desktop') -c Release -r win-x64 --self-contained true -o $install --nologo -v q
if ($LASTEXITCODE -ne 0) { throw 'Desktop publish failed' }

Write-Host 'Publishing API...'
dotnet publish (Join-Path $root 'backend\src\MyPlanner.Api') -c Release -r win-x64 --self-contained true -o $apiOut --nologo -v q
if ($LASTEXITCODE -ne 0) { throw 'API publish failed' }

# The web UI runs inside WebView2 and calls the installed API.
# Google sign-in uses VITE_GOOGLE_CLIENT_ID from frontend/.env.local and opens the system browser.
Write-Host 'Building web UI...'
$env:VITE_API_URL = 'http://127.0.0.1:5275'
Push-Location (Join-Path $root 'frontend')
try {
    npm run build -- --outDir (Join-Path $install 'web') --emptyOutDir
    if ($LASTEXITCODE -ne 0) { throw 'Web build failed' }
}
finally {
    Pop-Location
    Remove-Item Env:VITE_API_URL -ErrorAction SilentlyContinue
}

# The installed API runs as Production and gets only the values it needs.
$dev = Get-Content $devConfig -Raw -Encoding UTF8 | ConvertFrom-Json
$settings = @{
    ConnectionStrings = @{ Default = $dev.ConnectionStrings.Default }
    Jwt = @{ Key = $dev.Jwt.Key }
    Google = @{ ClientId = $dev.Google.ClientId }
    Storage = $dev.Storage
} | ConvertTo-Json -Depth 3
[IO.File]::WriteAllText((Join-Path $apiOut 'appsettings.Production.json'), $settings, (New-Object Text.UTF8Encoding $false))
Remove-Item (Join-Path $apiOut 'appsettings.Development.json') -ErrorAction SilentlyContinue

# Avatar storage is optional: the app still works if this container cannot be created.
Write-Host 'Preparing image storage...'
$ErrorActionPreference = 'Continue'
docker compose -f (Join-Path $root 'backend\docker-compose.yml') up -d minio *> $null
if ($LASTEXITCODE -ne 0) { Write-Warning 'MinIO is not running. Profile photos stay unavailable until it starts.' }
$ErrorActionPreference = 'Stop'

$name = 'M' + [char]0x1EA7 + 'm'
$shell = New-Object -ComObject WScript.Shell
# WScript.Shell cannot save a path with Vietnamese letters: save with an ASCII name, then rename.
$desktop = [Environment]::GetFolderPath('Desktop')
$tempLink = Join-Path $desktop 'Mam-shortcut.lnk'
$link = $shell.CreateShortcut($tempLink)
$link.TargetPath = Join-Path $install 'Mam.exe'
$link.WorkingDirectory = $install
# The app rewrites this file when the theme changes, so the shortcut follows the theme.
$shortcutIcon = Join-Path $env:LOCALAPPDATA 'Mam\app-icon.ico'
if (-not (Test-Path $shortcutIcon)) {
    New-Item -ItemType Directory -Force (Split-Path $shortcutIcon) | Out-Null
    Copy-Item (Join-Path $install 'Assets\ThemeIcons\forest.ico') $shortcutIcon
}
$link.IconLocation = "$shortcutIcon,0"
$link.Save()
Move-Item -LiteralPath $tempLink -Destination (Join-Path $desktop "$name.lnk") -Force

Write-Host "Installed to $install"
