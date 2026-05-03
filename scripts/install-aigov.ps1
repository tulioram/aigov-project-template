param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectCode,
    [Parameter(Mandatory=$true)]
    [string]$ProjectName,
    [string]$ProjectPath = (Get-Location).Path,
    [string]$TemplateRepo = "tulioram/aigov-project-template",
    [string]$Branch = "main",
    [string]$LocalTemplate,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

if (-not $LocalTemplate -and $TemplateRepo -match "SEU_USUARIO") {
    throw '[AIGOV] O parâmetro -TemplateRepo ainda contém o placeholder ''SEU_USUARIO''. Informe o repositório real (ex.: tulioram/aigov-project-template).'
}

function Write-Step($msg) { Write-Host "[AIGOV] $msg" -ForegroundColor Cyan }

function Backup-IfExists($path) {
    if (Test-Path $path) {
        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $backup = "$path.backup-$timestamp"
        Move-Item -Path $path -Destination $backup -Force
        Write-Step "Backup criado: $backup"
    }
}

function Replace-Placeholders($filePath) {
    if (Test-Path $filePath) {
        $createdAt = Get-Date -Format "yyyy-MM-dd"
        $content = Get-Content $filePath -Raw
        $content = $content.Replace("{{PROJECT_CODE}}", $ProjectCode)
        $content = $content.Replace("{{PROJECT_NAME}}", $ProjectName)
        $content = $content.Replace("{{CREATED_AT}}", $createdAt)
        Set-Content -Path $filePath -Value $content -Encoding UTF8
    }
}

if (!(Test-Path $ProjectPath)) { throw "Pasta do projeto não encontrada: $ProjectPath" }

if ($LocalTemplate) {
    if (!(Test-Path $LocalTemplate)) { throw "-LocalTemplate informado mas pasta nao existe: $LocalTemplate" }
    if (!(Test-Path (Join-Path $LocalTemplate ".ai"))) { throw "-LocalTemplate nao contem pasta .ai: $LocalTemplate" }
    Write-Step "Usando template local: $LocalTemplate"
    $templateFolder = Get-Item $LocalTemplate
} else {
    $tempRoot = Join-Path $env:TEMP ("aigov-template-" + [Guid]::NewGuid().ToString())
    $tempZip = "$tempRoot.zip"
    $tempExtract = "$tempRoot-extract"
    $zipUrl = "https://github.com/$TemplateRepo/archive/refs/heads/$Branch.zip"

    Write-Step "Baixando template: $zipUrl"
    Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip
    Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

    $templateFolder = Get-ChildItem $tempExtract -Directory | Select-Object -First 1
    if ($null -eq $templateFolder) { throw "Não foi possível localizar a pasta extraída do template." }
}

$itemsToCopy = @(".ai", "AGENTS.md", "CLAUDE.md", "GEMINI.md", ".github", ".cursor", ".vscode", "scripts")

foreach ($item in $itemsToCopy) {
    $source = Join-Path $templateFolder.FullName $item
    $dest = Join-Path $ProjectPath $item
    if (Test-Path $source) {
        if ((Test-Path $dest) -and !$Force) { Backup-IfExists $dest }
        Copy-Item -Path $source -Destination $ProjectPath -Recurse -Force
        Write-Step "Copiado: $item"
    }
}

$files = Get-ChildItem -Path $ProjectPath -Recurse -File -Include *.md,*.json,*.mdc,*.ps1
foreach ($file in $files) { Replace-Placeholders $file.FullName }

Write-Step "Governança AIGOV instalada com sucesso."

# Detecta se a pasta tinha codigo pre-existente (alem das pastas instaladas pelo template)
$ignoreNames = @(".ai", ".ai-local", ".github", ".cursor", ".vscode", "scripts", ".git",
                 "AGENTS.md", "CLAUDE.md", "GEMINI.md", "README.md")
$existingItems = Get-ChildItem -Path $ProjectPath -Force | Where-Object { $ignoreNames -notcontains $_.Name }
$hasExistingCode = $existingItems.Count -gt 0

Write-Host ""
Write-Host "=== Proximo passo ===" -ForegroundColor Green
if ($hasExistingCode) {
    Write-Host "Projeto EXISTENTE detectado ($($existingItems.Count) item(ns) fora da governanca)." -ForegroundColor Yellow
    Write-Host "Abra um chat com o agente e use o prompt:" -ForegroundColor White
    Write-Host "  -> 'Diagnostico inicial' (em .ai/07_PROMPTS.md)" -ForegroundColor Cyan
    Write-Host "Ele vai ler o codigo existente e preencher .ai/01, 02, 06, 10..." -ForegroundColor DarkGray
} else {
    Write-Host "Projeto NOVO (pasta vazia)." -ForegroundColor Yellow
    Write-Host "Abra um chat com o agente e use o prompt:" -ForegroundColor White
    Write-Host "  -> 'Kickoff de projeto (PRD curto)' (em .ai/07_PROMPTS.md)" -ForegroundColor Cyan
    Write-Host "Ele fara 3 rodadas de Q&A e preenchera .ai/01_PROJECT_SCOPE.md." -ForegroundColor DarkGray
}
Write-Host ""
Write-Host "Apos preencher, valide com:" -ForegroundColor White
Write-Host "  powershell -ExecutionPolicy Bypass -File .\scripts\validate-aigov.ps1 -WithScope" -ForegroundColor DarkGray
Write-Host ""
Write-Host "Atividade sugerida: $ProjectCode-DIAG-001 - Diagnostico inicial" -ForegroundColor DarkYellow
