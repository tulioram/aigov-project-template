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

## Auditoria técnica

```text
Este é o {{PROJECT_CODE}}-AUDIT-[NUMERO] — Auditoria técnica.

Classifique como tipo 8 (Auditoria técnica) e atue com mentalidade de auditor.

Leia obrigatoriamente toda a pasta .ai antes de analisar qualquer código.

Objetivo:
Identificar riscos, lacunas estruturais, dívidas técnicas e oportunidades de melhoria — sem implementar correções neste chat.

Entregáveis:
- inventário do estado atual (arquivos, scripts, módulos);
- lista de achados classificados por severidade (crítico/importante/moderado/menor);
- pontos positivos identificados;
- recomendações priorizadas.

Ao final, atualize:
- .ai/03_ACTIVITY_LOG.md (registro da auditoria)
- .ai/08_CHAT_INDEX.md (entrada do chat)
- .ai/10_RISK_REGISTER.md (riscos identificados)
- .ai/06_BACKLOG.md (itens recomendados)

Não implemente correções. Apenas diagnostique e registre.
```

## Brainstorming / Design Thinking (3 eixos)

Use sempre que houver ambiguidade, múltiplas opções viáveis ou definição de escopo nova — antes de propor qualquer plano.

```text
Este é o {{PROJECT_CODE}}-[MODULO]-[NUMERO] — [OBJETIVO].

Antes de planejar, valide direção comigo via Q&A estruturado.

Pergunte UMA RODADA com exatamente 3 perguntas (padrão 3 eixos minimalista),
usando opções clicáveis (radio ou checkbox) e permitindo resposta livre:

1. **Foco** — quais áreas/dimensões priorizar? (multiselect, listar 4–8 opções concretas com descrição curta de uma linha; incluir "Outra coisa")
2. **Horizonte** — qual o alcance da entrega? (radio, ex: Quick wins / v1.0 estável / Visão completa)
3. **Público / Contexto** — quem usa, em que contexto? (radio, ex: Uso pessoal / Time interno / Comunidade pública / Cliente específico)

Regras:
- cada opção tem label curto + descrição curta;
- marcar UMA como recomendada com base no contexto da pasta .ai;
- permitir freeform em pelo menos a #2 e #3;
- não fazer mais perguntas após essa rodada — siga direto para o plano.

Depois das respostas, apresente o plano (objetivo, escopo incluído/não incluído,
arquivos prováveis, riscos, critérios de aceite, plano de teste) e SÓ implemente
após a aprovação explícita.

Ao final, atualize:
- .ai/03_ACTIVITY_LOG.md
- .ai/08_CHAT_INDEX.md
- .ai/04_DECISIONS.md, se a Q&A definiu uma direção que vale registrar como ADR
```
