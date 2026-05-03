# 07_PROMPTS.md — Prompts Padrão

Projeto: {{PROJECT_NAME}}  
Código: {{PROJECT_CODE}}

## Diagnóstico inicial

```text
Este é o {{PROJECT_CODE}}-DIAG-001 — Diagnóstico inicial.

Antes de implementar qualquer coisa, leia:
- .ai/00_MASTER_CONTEXT.md
- .ai/01_PROJECT_SCOPE.md
- .ai/02_ROADMAP.md
- .ai/03_ACTIVITY_LOG.md
- .ai/06_BACKLOG.md
- .ai/08_CHAT_INDEX.md
- .ai/10_RISK_REGISTER.md

Objetivo:
Diagnosticar o estado atual do projeto, mapear módulos existentes, riscos, pendências e propor plano inicial.

Não implemente ainda.
Atualize o índice de chats e registre o diagnóstico no activity log.
```

## Nova implementação

```text
Este é o {{PROJECT_CODE}}-[MODULO]-[NUMERO] — [OBJETIVO].

Leia a pasta .ai antes de qualquer alteração.

Classifique a atividade, verifique duplicidades, identifique riscos, proponha plano e só implemente após deixar claro:
- escopo incluído;
- escopo não incluído;
- arquivos prováveis;
- critérios de aceite;
- plano de teste;
- impactos.

Ao final, atualize:
- .ai/03_ACTIVITY_LOG.md
- .ai/06_BACKLOG.md
- .ai/08_CHAT_INDEX.md
- .ai/10_RISK_REGISTER.md, se necessário
```
