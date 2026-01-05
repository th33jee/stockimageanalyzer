# Create desktop shortcut for Stock Analyzer

$WshShell = New-Object -ComObject WScript.Shell
$Desktop = [System.IO.Path]::Combine($env:USERPROFILE, "Desktop")

# Get the app path from Program Files or current directory
$AppPath = "C:\Program Files\Stock Analyzer\Stock Analyzer.exe"
if (-not (Test-Path $AppPath)) {
    # Fall back to current directory for development
    $AppPath = Join-Path (Get-Location) "node_modules\.bin\electron.cmd"
}

$ShortcutPath = Join-Path $Desktop "Stock Analyzer.lnk"

try {
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = $AppPath
    $Shortcut.WorkingDirectory = Get-Location
    $Shortcut.Description = "Stock Chart Analysis Tool"
    $Shortcut.Save()
    
    Write-Host "✅ Desktop shortcut created successfully!" -ForegroundColor Green
    Write-Host "Location: $ShortcutPath" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Error creating shortcut: $_" -ForegroundColor Red
}
