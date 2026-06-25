Set-ExecutionPolicy -Scope Process Bypass -Force
$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

function Stop-FreqtradeInstances {
    Write-Host "==> Stopping existing freqtrade instances..." -ForegroundColor Yellow

    Get-NetTCPConnection -LocalPort 8080 -State Listen -ErrorAction SilentlyContinue | ForEach-Object {
        $proc = Get-CimInstance Win32_Process -Filter "ProcessId=$($_.OwningProcess)" -ErrorAction SilentlyContinue
        if ($proc -and $proc.CommandLine -like '*freqtrade*') {
            Write-Host "  Port 8080 -> PID $($_.OwningProcess)"
            Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue
        }
    }

    Get-CimInstance Win32_Process -Filter "Name='python.exe'" -ErrorAction SilentlyContinue |
        Where-Object { $_.CommandLine -like '*freqtrade*' } |
        ForEach-Object {
            Write-Host "  freqtrade -> PID $($_.ProcessId)"
            Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue
        }

    Start-Sleep -Seconds 2

    $stillRunning = Get-CimInstance Win32_Process -Filter "Name='python.exe'" -ErrorAction SilentlyContinue |
        Where-Object { $_.CommandLine -like '*freqtrade*' }
    if ($stillRunning) {
        throw "Could not stop all freqtrade processes. Close other terminals and retry."
    }
}

$FreqtradeExe = Join-Path $Root ".venv\Scripts\freqtrade.exe"
if (-not (Test-Path $FreqtradeExe)) {
    throw "freqtrade not installed. Run .\scripts\setup-local.ps1 first."
}
if (-not (Test-Path "user_data\config.json")) {
    throw "user_data\config.json not found."
}

New-Item -ItemType Directory -Force -Path "user_data\logs" | Out-Null
Stop-FreqtradeInstances

Write-Host "==> Starting single freqtrade instance (dry-run)..." -ForegroundColor Green
Write-Host "    WebUI: http://127.0.0.1:8080  (freqtrader / freqtrader)"
Write-Host "    Press Ctrl+C to stop."
Write-Host ""

& $FreqtradeExe trade `
    --config user_data/config.json `
    --strategy SampleStrategy `
    --logfile user_data/logs/freqtrade.log
