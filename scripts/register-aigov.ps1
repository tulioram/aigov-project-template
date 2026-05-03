param(
    [string]$TemplateRepo = "tulioram/aigov-project-template",
    [string]$Branch = "main",
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

if ($TemplateRepo -match "SEU_USUARIO") {
    throw '[AIGOV] -TemplateRepo contem placeholder. Informe ex.: tulioram/aigov-project-template'
}
$profilePath = $PROFILE.CurrentUserAllHosts

if (!(Test-Path (Split-Path $profilePath))) {
    New-Item -ItemType Directory -Path (Split-Path $profilePath) -Force | Out-Null
}
if (!(Test-Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force | Out-Null
}

# Bloco do profile: usa git clone + dot-source (sem Invoke-WebRequest, sem spawn powershell -Bypass).
# Reduz drasticamente falsos positivos de antivirus (Defender, etc.).
$functionBlock = @"

# AIGOV - AI Governance command
function aigov {
    param(
        [Parameter(Mandatory=`$true, Position=0)]
        [string]`$ProjectCode,
        [Parameter(Mandatory=`$true, Position=1)]
        [string]`$ProjectName,
        [string]`$ProjectPath = (Get-Location).Path,
        [string]`$TemplateRepo = "$TemplateRepo",
        [string]`$Branch = "$Branch",
        [string]`$CachePath = (Join-Path `$env:USERPROFILE ".aigov\template"),
        [switch]`$NoUpdate
    )

    `$repoUrl = "https://github.com/`$TemplateRepo.git"
    if (!(Test-Path `$CachePath)) {
        Write-Host "[AIGOV] Clonando template para cache: `$CachePath" -ForegroundColor Cyan
        `$parent = Split-Path `$CachePath -Parent
        if (!(Test-Path `$parent)) { New-Item -ItemType Directory -Path `$parent -Force | Out-Null }
        git clone --depth 1 --branch `$Branch `$repoUrl `$CachePath
        if (`$LASTEXITCODE -ne 0) { throw "Falha ao clonar template" }
    } elseif (-not `$NoUpdate) {
        Push-Location `$CachePath
        try {
            git fetch --depth 1 origin `$Branch 2>&1 | Out-Null
            git reset --hard "origin/`$Branch" 2>&1 | Out-Null
        } finally { Pop-Location }
    }

    if (!(Test-Path `$ProjectPath)) {
        New-Item -ItemType Directory -Path `$ProjectPath -Force | Out-Null
    }

    `$installScript = Join-Path `$CachePath "scripts\install-aigov.ps1"
    & `$installScript ``
        -ProjectCode `$ProjectCode ``
        -ProjectName `$ProjectName ``
        -ProjectPath `$ProjectPath ``
        -LocalTemplate `$CachePath
}

Set-Alias iniciar-governanca-ia aigov

"@

$current = ""
if (Test-Path $profilePath) { $current = Get-Content $profilePath -Raw }

if ($DryRun) {
    Write-Host "[AIGOV] DryRun ativo. Nenhum arquivo sera alterado." -ForegroundColor Cyan
    Write-Host "Profile alvo: $profilePath"
    if ($current -match "function aigov") {
        Write-Host "O comando aigov JA existe no profile. Sera SUBSTITUIDO." -ForegroundColor Yellow
    } else {
        Write-Host "O bloco abaixo seria APENDADO ao profile:" -ForegroundColor Green
    }
    Write-Host "----- inicio do bloco -----" -ForegroundColor DarkGray
    Write-Host $functionBlock
    Write-Host "----- fim do bloco -----" -ForegroundColor DarkGray
    return
}

if ($current -match "(?s)# AIGOV - AI Governance command.*?Set-Alias iniciar-governanca-ia aigov\s*") {
    $newContent = [System.Text.RegularExpressions.Regex]::Replace(
        $current,
        "(?s)\r?\n?# AIGOV - AI Governance command.*?Set-Alias iniciar-governanca-ia aigov\s*",
        ""
    )
    [System.IO.File]::WriteAllText($profilePath, $newContent.TrimEnd() + "`r`n" + $functionBlock, [System.Text.UTF8Encoding]::new($true))
    Write-Host "[AIGOV] Comando aigov ATUALIZADO no PowerShell profile." -ForegroundColor Green
} elseif ($current -match "function aigov") {
    Add-Content -Path $profilePath -Value $functionBlock -Encoding UTF8
    Write-Host "[AIGOV] Detectada definicao antiga de 'aigov' no profile. Nova definicao foi APENDADA." -ForegroundColor Yellow
    Write-Host "        Remova manualmente o bloco antigo (com Invoke-WebRequest) em: $profilePath" -ForegroundColor Yellow
} else {
    Add-Content -Path $profilePath -Value $functionBlock -Encoding UTF8
    Write-Host "[AIGOV] Comando aigov registrado no PowerShell profile:" -ForegroundColor Green
    Write-Host $profilePath
}

Write-Host ""
Write-Host "Reabra o terminal ou execute: . `$PROFILE"
Write-Host "Uso: aigov CFIN ""Controle Financeiro"""
