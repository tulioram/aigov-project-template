param(
    [string]$ProjectPath = (Get-Location).Path,
    [switch]$Strict,
    [switch]$Quiet
)

$ErrorActionPreference = "Stop"

$scopePath = Join-Path $ProjectPath ".ai/01_PROJECT_SCOPE.md"

if (!(Test-Path $scopePath)) {
    Write-Host "[AIGOV] Arquivo nao encontrado: .ai/01_PROJECT_SCOPE.md" -ForegroundColor Red
    exit 2
}

$content = [System.IO.File]::ReadAllText($scopePath, [System.Text.Encoding]::UTF8)

# Detecta formato
$prdSections = @(
    "1. Problema",
    "2. Usuário primário",
    "3. Solução em uma frase",
    "4. MVP",
    "5. Fora do escopo",
    "6. Métricas de sucesso",
    "7. Premissas",
    "8. Restrições",
    "9. Riscos iniciais",
    "10. Stack"
)
$legacySections = @(
    "Visão geral",
    "Problema que resolve",
    "Usuários / público-alvo",
    "Objetivos",
    "Módulos previstos",
    "Fora do escopo",
    "Regras de negócio"
)

$isPrd = ($content -match "PRD curto") -or ($content -match "(?m)^## 1\. Problema")
$format = if ($isPrd) { "PRD curto" } else { "Legacy" }
$sections = if ($isPrd) { $prdSections } else { $legacySections }

# Em modo nao-Strict, valida apenas as primeiras 4 secoes
$toCheck = if ($Strict) { $sections } else { $sections | Select-Object -First 4 }

$failures = @()
$okCount = 0

# Helper: extrai conteudo entre o heading da secao e o proximo "## "
function Get-SectionBody {
    param([string]$Text, [string]$SectionLabel)
    $pattern = "(?ms)^##\s+" + [regex]::Escape($SectionLabel) + "[^\r\n]*\r?\n(.*?)(?=^##\s|\z)"
    $m = [regex]::Match($Text, $pattern)
    if ($m.Success) { return $m.Groups[1].Value.Trim() }
    return $null
}

foreach ($section in $toCheck) {
    $body = Get-SectionBody -Text $content -SectionLabel $section
    if ($null -eq $body) {
        $failures += "secao ausente: $section"
        continue
    }
    if ([string]::IsNullOrWhiteSpace($body)) {
        $failures += "secao vazia: $section"
        continue
    }
    if ($body -imatch "\bA definir\b") {
        $failures += "secao com placeholder 'A definir': $section"
        continue
    }
    $okCount++
    if (-not $Quiet) {
        Write-Host "  [OK] $section" -ForegroundColor DarkGray
    }
}

$mode = if ($Strict) { "Strict" } else { "Permissivo" }

if ($failures.Count -eq 0) {
    Write-Host "[AIGOV] Escopo valido (formato: $format, modo: $mode, $okCount/$($toCheck.Count) secoes)." -ForegroundColor Green
    exit 0
}

Write-Host "[AIGOV] Escopo invalido (formato: $format, modo: $mode, $($failures.Count) falha(s)):" -ForegroundColor Yellow
$failures | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
exit 1