Set-ExecutionPolicy -Scope Process Bypass -Force
$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

Write-Host "==> Freqtrade local setup (Windows)" -ForegroundColor Cyan

if (-not (Test-Path ".venv\Scripts\python.exe")) {
    $Python = $null
    foreach ($candidate in @("py -3.13", "py -3.12", "python")) {
        try {
            $version = Invoke-Expression "$candidate --version"
            if ($version -match "Python 3\.(1[1-9]|[2-9][0-9])") {
                $Python = $candidate
                break
            }
        } catch {}
    }
    if (-not $Python) {
        throw "Python 3.11+ is required."
    }
    Invoke-Expression "$Python -m venv .venv --upgrade-deps"
}

$Py = Join-Path $Root ".venv\Scripts\python.exe"
& $Py -m pip install --upgrade pip setuptools wheel
& $Py -m pip install --no-cache-dir --no-build-isolation -r requirements.txt
& $Py -m pip uninstall -y aiodns pycares 2>$null
& $Py -m pip install --no-cache-dir --no-build-isolation --no-deps -e .

New-Item -ItemType Directory -Force -Path "user_data\strategies", "user_data\logs" | Out-Null
if (-not (Test-Path "user_data\config.json")) {
    Copy-Item "config_examples\local-dryrun.example.json" "user_data\config.json"
}
if (-not (Test-Path "user_data\strategies\sample_strategy.py")) {
    Copy-Item "freqtrade\templates\sample_strategy.py" "user_data\strategies\sample_strategy.py"
}

Write-Host ""
Write-Host "Setup complete." -ForegroundColor Green
Write-Host "Run: .\.venv\Scripts\freqtrade.exe trade --config user_data/config.json --strategy SampleStrategy"
