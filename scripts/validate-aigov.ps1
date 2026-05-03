param(
    [string]$ProjectPath = (Get-Location).Path,
    [switch]$IncludeLocal
)

$required = @(
    ".ai/00_MASTER_CONTEXT.md",
    ".ai/01_PROJECT_SCOPE.md",
    ".ai/02_ROADMAP.md",
    ".ai/03_ACTIVITY_LOG.md",
    ".ai/04_DECISIONS.md",
    ".ai/05_DEPLOYMENT_LOG.md",
    ".ai/06_BACKLOG.md",
    ".ai/07_PROMPTS.md",
    ".ai/08_CHAT_INDEX.md",
    ".ai/09_ACCEPTANCE_CRITERIA.md",
    ".ai/10_RISK_REGISTER.md",
    ".ai/11_GSD_INTEGRATION.md",
    ".ai/12_AGENT_HANDOFF.md",
    "AGENTS.md",
    "CLAUDE.md",
    "GEMINI.md",
    ".github/copilot-instructions.md",
    ".cursor/rules/ai-governance.mdc"
)

$missing = @()
foreach ($rel in $required) {
    $path = Join-Path $ProjectPath $rel
    if (!(Test-Path $path)) { $missing += $rel }
}

# Validação opcional da pasta de governança interna (template-local)
$localPath = Join-Path $ProjectPath ".ai-local"
if ($IncludeLocal -or (Test-Path $localPath)) {
    if (Test-Path $localPath) {
        Write-Host "[AIGOV] Pasta .ai-local detectada (governança interna)." -ForegroundColor DarkCyan
        $localRequired = @(
            ".ai-local/03_ACTIVITY_LOG.md",
            ".ai-local/06_BACKLOG.md",
            ".ai-local/08_CHAT_INDEX.md",
            ".ai-local/10_RISK_REGISTER.md"
        )
        foreach ($rel in $localRequired) {
            $path = Join-Path $ProjectPath $rel
            if (!(Test-Path $path)) { $missing += $rel }
        }
    } elseif ($IncludeLocal) {
        $missing += ".ai-local/ (esperada com -IncludeLocal)"
    }
}

if ($missing.Count -eq 0) {
    Write-Host "[AIGOV] Estrutura válida." -ForegroundColor Green
    exit 0
}

Write-Host "[AIGOV] Arquivos ausentes:" -ForegroundColor Yellow
$missing | ForEach-Object { Write-Host "- $_" }
exit 1
