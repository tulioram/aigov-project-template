param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectCode,
    [Parameter(Mandatory=$true)]
    [string]$ProjectName,
    [string]$ProjectPath = (Get-Location).Path,
    [string]$TemplateRepo = "tulioram/aigov-project-template",
    [string]$Branch = "main",
    [switch]$Force
)

$ErrorActionPreference = "Stop"

if ($TemplateRepo -match "SEU_USUARIO") {
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

$tempRoot = Join-Path $env:TEMP ("aigov-template-" + [Guid]::NewGuid().ToString())
$tempZip = "$tempRoot.zip"
$tempExtract = "$tempRoot-extract"
$zipUrl = "https://github.com/$TemplateRepo/archive/refs/heads/$Branch.zip"

Write-Step "Baixando template: $zipUrl"
Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip
Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

$templateFolder = Get-ChildItem $tempExtract -Directory | Select-Object -First 1
if ($null -eq $templateFolder) { throw "Não foi possível localizar a pasta extraída do template." }

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
Write-Host "Próximo passo sugerido: $ProjectCode-DIAG-001 — Diagnóstico inicial" -ForegroundColor Yellow
