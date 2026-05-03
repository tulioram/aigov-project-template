param(
    [string]$TemplateRepo = "SEU_USUARIO/aigov-project-template",
    [string]$Branch = "main"
)

$ErrorActionPreference = "Stop"
$profilePath = $PROFILE.CurrentUserAllHosts

if (!(Test-Path (Split-Path $profilePath))) {
    New-Item -ItemType Directory -Path (Split-Path $profilePath) -Force | Out-Null
}
if (!(Test-Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force | Out-Null
}

$functionBlock = @"

# AIGOV — AI Governance command
function aigov {
    param(
        [Parameter(Mandatory=`$true, Position=0)]
        [string]`$ProjectCode,
        [Parameter(Mandatory=`$true, Position=1)]
        [string]`$ProjectName,
        [string]`$TemplateRepo = "$TemplateRepo",
        [string]`$Branch = "$Branch"
    )

    `$tempScript = Join-Path `$env:TEMP "install-aigov.ps1"
    `$scriptUrl = "https://raw.githubusercontent.com/`$TemplateRepo/`$Branch/scripts/install-aigov.ps1"

    Invoke-WebRequest -Uri `$scriptUrl -OutFile `$tempScript

    powershell -ExecutionPolicy Bypass -File `$tempScript `
        -ProjectCode `$ProjectCode `
        -ProjectName `$ProjectName `
        -ProjectPath (Get-Location).Path `
        -TemplateRepo `$TemplateRepo `
        -Branch `$Branch
}

Set-Alias iniciar-governanca-ia aigov

"@

$current = ""
if (Test-Path $profilePath) { $current = Get-Content $profilePath -Raw }

if ($current -notmatch "function aigov") {
    Add-Content -Path $profilePath -Value $functionBlock -Encoding UTF8
    Write-Host "Comando aigov registrado no PowerShell profile:" -ForegroundColor Green
    Write-Host $profilePath
} else {
    Write-Host "O comando aigov já existe no PowerShell profile." -ForegroundColor Yellow
}

Write-Host "Reabra o terminal ou execute: . `$PROFILE"
Write-Host "Uso: aigov CFIN `"Controle Financeiro`""
