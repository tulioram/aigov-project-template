# GEMINI.md

Este projeto utiliza governança universal para LLMs e agentes de IA.

Antes de qualquer alteração de código ou documentação, leia obrigatoriamente:

- `.ai/00_MASTER_CONTEXT.md`
- `.ai/01_PROJECT_SCOPE.md`
- `.ai/02_ROADMAP.md`
- `.ai/03_ACTIVITY_LOG.md`
- `.ai/04_DECISIONS.md`
- `.ai/06_BACKLOG.md`
- `.ai/08_CHAT_INDEX.md`
- `.ai/09_ACCEPTANCE_CRITERIA.md`
- `.ai/10_RISK_REGISTER.md`
- `.ai/12_AGENT_HANDOFF.md`

## Postura esperada

- Atue com mentalidade de auditor técnico.
- Classifique a atividade antes de implementar (ver `00_MASTER_CONTEXT.md`).
- Diagnostique antes de propor — verifique duplicidade, escopo e riscos de quebra.
- Apresente plano antes de alterar arquivos.
- Implemente de forma incremental.
- Não crie funcionalidades fora do escopo solicitado.

## Padrão de chats

```text
{{PROJECT_CODE}}-[MÓDULO]-[NÚMERO] — [OBJETIVO]
```

## Atualizações obrigatórias ao final

- `.ai/03_ACTIVITY_LOG.md`
- `.ai/08_CHAT_INDEX.md`
- `.ai/06_BACKLOG.md`, se surgirem pendências
- `.ai/04_DECISIONS.md`, se houver decisão técnica
- `.ai/10_RISK_REGISTER.md`, se houver risco relevante