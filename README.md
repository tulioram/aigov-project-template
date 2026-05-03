# AIGOV — AI Governance Project Template

Template universal para padronizar projetos desenvolvidos com apoio de LLMs/agentes de IA no VS Code.

AIGOV é a camada de governança do projeto: escopo, backlog, decisões, riscos, logs de atividades, índice de chats, handoff entre agentes e checklist de implantação.

## Uso rápido

Depois de subir este repositório para o GitHub, instale em qualquer projeto com:

```powershell
aigov CFIN "Controle Financeiro"
```

## Estrutura

- `.ai/` — governança viva do projeto
- `AGENTS.md` — instruções para agentes compatíveis
- `CLAUDE.md` — instruções para Claude
- `GEMINI.md` — instruções para Gemini
- `.github/copilot-instructions.md` — instruções para GitHub Copilot
- `.cursor/rules/ai-governance.mdc` — regra para Cursor
- `scripts/` — instaladores e validadores

## Registrar comando global

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\register-aigov.ps1 -TemplateRepo "SEU_USUARIO/aigov-project-template"
```

Depois:

```powershell
. $PROFILE
```

## Criar projeto novo

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\new-aigov-project.ps1 `
  -ProjectCode "HEL" `
  -ProjectName "Helena" `
  -ProjectPath "C:\_projetos\helena" `
  -TemplateRepo "tulioram/aigov-project-template" `
  -InitGit `
  -OpenVSCode
```

## Atualizar a governança de um projeto existente

Após mudanças no template (novos modelos, scripts, prompts), execute na raiz do projeto-destino:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\update-aigov.ps1 -DryRun
powershell -ExecutionPolicy Bypass -File .\scripts\update-aigov.ps1
```

Comportamento:

- Faz backup automático da pasta `.ai/` (formato `.ai.backup-update-AAAAMMDD-HHMMSS`).
- Sobrescreve apenas arquivos estruturais do template (modelos, prompts, scripts, instruções para agentes).
- Preserva sempre os registros vivos: escopo, activity log, backlog, decisões, índice de chats, riscos, handoffs, deployment log.
- `-DryRun` lista o que seria alterado sem aplicar.

## Validar a estrutura

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-aigov.ps1
```

## Governança interna (`.ai-local/`)

Este repositório usa duas pastas de governança:

- `.ai/` é o **template puro** distribuído (placeholders e modelos).
- `.ai-local/` (gitignored) contém a governança **viva** do próprio template — atividades reais, riscos, backlog, decisões.

Em projetos-destino, apenas `.ai/` é usada e seus arquivos são preenchidos com dados reais.
