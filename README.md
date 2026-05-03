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
  -TemplateRepo "SEU_USUARIO/aigov-project-template" `
  -InitGit `
  -OpenVSCode
```
