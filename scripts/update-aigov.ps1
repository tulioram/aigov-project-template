param(
    [string]$ProjectPath = (Get-Location).Path
)

$ErrorActionPreference = "Stop"

if (!(Test-Path (Join-Path $ProjectPath ".ai"))) {
    throw "Este projeto ainda não possui pasta .ai. Rode o instalador primeiro."
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupPath = Join-Path $ProjectPath ".ai.backup-update-$timestamp"
Copy-Item -Path (Join-Path $ProjectPath ".ai") -Destination $backupPath -Recurse -Force

Write-Host "[AIGOV] Backup criado: $backupPath" -ForegroundColor Green
Write-Host "[AIGOV] Atualização conservadora: preserve registros vivos manualmente." -ForegroundColor Yellow
