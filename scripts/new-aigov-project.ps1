param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectCode,
    [Parameter(Mandatory=$true)]
    [string]$ProjectName,
    [Parameter(Mandatory=$true)]
    [string]$ProjectPath,
    [string]$TemplateRepo = "tulioram/aigov-project-template",
    [string]$Branch = "main",
    [string]$CachePath = (Join-Path $env:USERPROFILE ".aigov\template"),
    [switch]$NoUpdate,
    [switch]$OpenVSCode,
    [switch]$InitGit
)

$ErrorActionPreference = "Stop"

if ($TemplateRepo -match "SEU_USUARIO") {
    throw '[AIGOV] -TemplateRepo contem placeholder. Informe ex.: tulioram/aigov-project-template'
}

function Write-Step($msg) { Write-Host "[AIGOV] $msg" -ForegroundColor Cyan }

# 1) Garante o cache local do template via git (sem download/extract -> evita falsos positivos de AV)
$repoUrl = "https://github.com/$TemplateRepo.git"
if (!(Test-Path $CachePath)) {
    Write-Step "Clonando template para cache: $CachePath"
    $parent = Split-Path $CachePath -Parent
    if (!(Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
    git clone --depth 1 --branch $Branch $repoUrl $CachePath
    if ($LASTEXITCODE -ne 0) { throw "Falha ao clonar template ($repoUrl)" }
} elseif (-not $NoUpdate) {
    Write-Step "Atualizando cache do template (git pull): $CachePath"
    Push-Location $CachePath
    try {
        git fetch --depth 1 origin $Branch 2>&1 | Out-Null
        git reset --hard "origin/$Branch" 2>&1 | Out-Null
    } finally { Pop-Location }
}

# 2) Cria pasta destino
if (!(Test-Path $ProjectPath)) { New-Item -ItemType Directory -Path $ProjectPath -Force | Out-Null }

if ($InitGit) {
    Push-Location $ProjectPath
    try { if (!(Test-Path ".git")) { git init | Out-Null } } finally { Pop-Location }
}

# 3) Executa install via dot-source (sem spawn de powershell.exe -> evita bloqueio de AV)
$installScript = Join-Path $CachePath "scripts\install-aigov.ps1"
if (!(Test-Path $installScript)) { throw "install-aigov.ps1 nao encontrado no cache: $installScript" }

& $installScript `
    -ProjectCode $ProjectCode `
    -ProjectName $ProjectName `
    -ProjectPath $ProjectPath `
    -LocalTemplate $CachePath

# 4) README minimo
$readme = Join-Path $ProjectPath "README.md"
if (!(Test-Path $readme)) {
    $content = "# $ProjectName`n`nCodigo do projeto: $ProjectCode`n"
    [System.IO.File]::WriteAllText($readme, $content, [System.Text.UTF8Encoding]::new($true))
}

if ($OpenVSCode) { code $ProjectPath }
