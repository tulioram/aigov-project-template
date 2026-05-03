# 00_MASTER_CONTEXT.md — Governança Universal do Projeto

Projeto: {{PROJECT_NAME}}  
Código: {{PROJECT_CODE}}  
Criado em: {{CREATED_AT}}

## Princípio central

Este projeto deve ser conduzido com governança, rastreabilidade, preservação de escopo e mentalidade de auditoria técnica.

## Classificação obrigatória da atividade

Antes de qualquer ação, classificar a solicitação como:

1. Novo projeto
2. Nova implementação
3. Correção de bug
4. Refatoração
5. Implantação/deploy
6. Atualização de escopo
7. Documentação
8. Auditoria técnica
9. Investigação/diagnóstico
10. Melhoria de UX/UI
11. Integração externa
12. Banco de dados/migração
13. Segurança/permissões
14. Performance
15. Testes/qualidade

## Diagnóstico antes da execução

Antes de implementar, o agente deve:

- ler o escopo atual;
- verificar funcionalidades existentes;
- identificar componentes, rotas, serviços, tabelas e funções já criadas;
- verificar se a solicitação já foi parcialmente implementada;
- identificar riscos de retrabalho;
- identificar risco de quebrar algo existente;
- propor plano antes de alterar arquivos.

## Plano obrigatório antes da implementação

Antes de alterar arquivos, apresentar:

- objetivo;
- escopo incluído;
- escopo não incluído;
- arquivos prováveis a alterar;
- dependências;
- riscos;
- critérios de aceite;
- plano de teste;
- plano de rollback, quando aplicável.

## Atualização obrigatória

Ao concluir qualquer atividade, atualizar:

- `.ai/03_ACTIVITY_LOG.md`;
- `.ai/08_CHAT_INDEX.md`;
- `.ai/06_BACKLOG.md`, se surgirem pendências;
- `.ai/04_DECISIONS.md`, se houver decisão técnica;
- `.ai/05_DEPLOYMENT_LOG.md`, se houver implantação;
- `.ai/10_RISK_REGISTER.md`, se houver risco relevante.

## Padrão dos chats

```text
{{PROJECT_CODE}}-[MÓDULO]-[NÚMERO] — [OBJETIVO]
```
