param(
    [string]$ProjectPath = (Get-Location).Path,
    [string]$TemplateRepo = "tulioram/aigov-project-template",
    [string]$Branch = "main",
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

if ($TemplateRepo -match "SEU_USUARIO") {
    throw '[AIGOV] O parâmetro -TemplateRepo ainda contém o placeholder ''SEU_USUARIO''. Informe o repositório real (ex.: tulioram/aigov-project-template).'
}

if (!(Test-Path (Join-Path $ProjectPath ".ai"))) {
    throw "Este projeto ainda não possui pasta .ai. Rode o instalador primeiro."
}

function Write-Step($msg) { Write-Host "[AIGOV] $msg" -ForegroundColor Cyan }

# Arquivos sempre sobrescritos pelo template (estruturais)
$overwriteFiles = @(
    ".ai/00_MASTER_CONTEXT.md",
    ".ai/02_ROADMAP.md",
    ".ai/05_DEPLOYMENT_LOG.md",
    ".ai/07_PROMPTS.md",
    ".ai/09_ACCEPTANCE_CRITERIA.md",
    ".ai/11_GSD_INTEGRATION.md",
    "AGENTS.md",
    "CLAUDE.md",
    "GEMINI.md",
    ".github/copilot-instructions.md",
    ".cursor/rules/ai-governance.mdc",
    ".vscode/tasks.json",
    "scripts/install-aigov.ps1",
    "scripts/new-aigov-project.ps1",
    "scripts/register-aigov.ps1",
    "scripts/update-aigov.ps1",
    "scripts/validate-aigov.ps1"
)

# Arquivos preservados (registros vivos) — NUNCA sobrescritos
$preserveFiles = @(
    ".ai/01_PROJECT_SCOPE.md",
    ".ai/03_ACTIVITY_LOG.md",
    ".ai/04_DECISIONS.md",
    ".ai/06_BACKLOG.md",
    ".ai/08_CHAT_INDEX.md",
    ".ai/10_RISK_REGISTER.md",
    ".ai/12_AGENT_HANDOFF.md"
)

if ($DryRun) {
    Write-Step "DryRun ativo. Nenhum arquivo será alterado."
    Write-Host ""
    Write-Host "Backup que seria criado:" -ForegroundColor DarkCyan
    Write-Host "  $ProjectPath\.ai.backup-update-AAAAMMDD-HHMMSS"
    Write-Host ""
    Write-Host "Arquivos que SERIAM sobrescritos pelo template:" -ForegroundColor Yellow
    $overwriteFiles | ForEach-Object { Write-Host "  - $_" }
    Write-Host ""
    Write-Host "Arquivos que SERIAM preservados (registros vivos):" -ForegroundColor Green
    $preserveFiles | ForEach-Object { Write-Host "  - $_" }
    return
}

# Backup antes de qualquer alteração
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$backupPath = Join-Path $ProjectPath ".ai.backup-update-$timestamp"
Copy-Item -Path (Join-Path $ProjectPath ".ai") -Destination $backupPath -Recurse -Force
Write-Step "Backup criado: $backupPath"

# Download do template
$tempRoot = Join-Path $env:TEMP ("aigov-update-" + [Guid]::NewGuid().ToString())
$tempZip = "$tempRoot.zip"
$tempExtract = "$tempRoot-extract"
$zipUrl = "https://github.com/$TemplateRepo/archive/refs/heads/$Branch.zip"

Write-Step "Baixando template: $zipUrl"
Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip
Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

$templateFolder = Get-ChildItem $tempExtract -Directory | Select-Object -First 1
if ($null -eq $templateFolder) { throw "Não foi possível localizar a pasta extraída do template." }

# Sobrescrever apenas os arquivos estruturais
$updated = @()
foreach ($rel in $overwriteFiles) {
    $source = Join-Path $templateFolder.FullName $rel
    $dest = Join-Path $ProjectPath $rel
    if (Test-Path $source) {
        $destDir = Split-Path $dest -Parent
        if (!(Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
        Copy-Item -Path $source -Destination $dest -Force
        $updated += $rel
    }
}

# Limpeza
Remove-Item $tempZip -Force -ErrorAction SilentlyContinue
Remove-Item $tempExtract -Recurse -Force -ErrorAction SilentlyContinue

Write-Step "Atualização concluída. $($updated.Count) arquivo(s) sobrescrito(s):"
$updated | ForEach-Object { Write-Host "  - $_" -ForegroundColor DarkGray }
Write-Host ""
Write-Step "Registros vivos preservados (não modificados): $($preserveFiles.Count) arquivo(s)."