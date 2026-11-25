# Sinh icon launcher và logo splash cho Android từ icon PWA của frontend,
# để app Mầm dùng chung một bộ nhận diện với web. Chạy lại khi logo đổi:
#   powershell -File tool/gen_android_icons.ps1   (trong thư mục mobile/)
Add-Type -AssemblyName System.Drawing

$root = Split-Path -Parent $PSScriptRoot
$public = Join-Path $root '..\frontend\public'
$res = Join-Path $root 'android\app\src\main\res'

# $scale < 1 thì vẽ logo nhỏ lại ở giữa, phần còn lại trong suốt.
function Save-Resized([string]$src, [string]$dest, [int]$size, [double]$scale = 1.0) {
    $img = [System.Drawing.Image]::FromFile($src)
    $bmp = New-Object System.Drawing.Bitmap $size, $size
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $inner = [int]($size * $scale)
    $offset = [int](($size - $inner) / 2)
    $g.DrawImage($img, $offset, $offset, $inner, $inner)
    New-Item -ItemType Directory -Force (Split-Path $dest) | Out-Null
    $bmp.Save($dest, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose(); $bmp.Dispose(); $img.Dispose()
}

$maskable = Join-Path $public 'maskable-icon-512x512.png'
$plain = Join-Path $public 'pwa-512x512.png'

# Mật độ màn hình Android: mdpi = 1x, hdpi = 1.5x, ... xxxhdpi = 4x.
$densities = @{ mdpi = 1.0; hdpi = 1.5; xhdpi = 2.0; xxhdpi = 3.0; xxxhdpi = 4.0 }
foreach ($d in $densities.Keys) {
    $k = $densities[$d]
    # Icon cũ (Android < 8): 48dp, dùng bản maskable có nền.
    Save-Resized $maskable (Join-Path $res "mipmap-$d\ic_launcher.png") ([int](48 * $k))
    # Lớp trước của adaptive icon: 108dp nhưng launcher chỉ chừa vùng giữa ~66dp, nên logo
    # (nền trong suốt) vẽ ở 55% cho khỏi bị cắt đầu lá; màu nền do lớp background lo.
    Save-Resized $plain (Join-Path $res "mipmap-$d\ic_launcher_foreground.png") ([int](108 * $k)) 0.55
    # Logo trên splash: 96dp, nền trong suốt.
    Save-Resized $plain (Join-Path $res "drawable-$d\launch_logo.png") ([int](96 * $k))
}
Write-Output 'Done'
