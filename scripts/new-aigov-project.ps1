param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectCode,
    [Parameter(Mandatory=$true)]
    [string]$ProjectName,
    [Parameter(Mandatory=$true)]
    [string]$ProjectPath,
    [string]$TemplateRepo = "tulioram/aigov-project-template",
    [string]$Branch = "main",
    [switch]$OpenVSCode,
    [switch]$InitGit
)

$ErrorActionPreference = "Stop"

if ($TemplateRepo -match "SEU_USUARIO") {
    throw '[AIGOV] O parâmetro -TemplateRepo ainda contém o placeholder ''SEU_USUARIO''. Informe o repositório real (ex.: tulioram/aigov-project-template).'
}

if (!(Test-Path $ProjectPath)) { New-Item -ItemType Directory -Path $ProjectPath -Force | Out-Null }

if ($InitGit) {
    Push-Location $ProjectPath
    if (!(Test-Path ".git")) { git init }
    Pop-Location
}

$tempScript = Join-Path $env:TEMP "install-aigov.ps1"
$scriptUrl = "https://raw.githubusercontent.com/$TemplateRepo/$Branch/scripts/install-aigov.ps1"
Invoke-WebRequest -Uri $scriptUrl -OutFile $tempScript

powershell -ExecutionPolicy Bypass -File $tempScript `
    -ProjectCode $ProjectCode `
    -ProjectName $ProjectName `
    -ProjectPath $ProjectPath `
    -TemplateRepo $TemplateRepo `
    -Branch $Branch

if (!(Test-Path (Join-Path $ProjectPath "README.md"))) {
    Set-Content -Path (Join-Path $ProjectPath "README.md") -Value "# $ProjectName`n`nCódigo do projeto: $ProjectCode`n" -Encoding UTF8
}

if ($OpenVSCode) { code $ProjectPath }
