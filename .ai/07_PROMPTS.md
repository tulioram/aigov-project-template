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

## Kickoff de projeto (definição de escopo — PRD curto)

Use UMA VEZ no início do projeto, antes de qualquer linha de código.
Obrigatório quando `01_PROJECT_SCOPE.md` ainda contém "A definir" em qualquer campo.
Pode ser pulado apenas se o usuário declarar explicitamente "pular kickoff".

```text
Este é o {{PROJECT_CODE}}-SCOPE-001 — Kickoff de projeto.

Objetivo:
Preencher .ai/01_PROJECT_SCOPE.md com um PRD curto antes de qualquer implementação.

Conduza Q&A em até 3 RODADAS curtas (máx 4 perguntas por rodada), usando
opções clicáveis (radio/checkbox) e permitindo resposta livre. Comece SEMPRE
pela Rodada 1.

Rodada 1 — Problema e usuário
1. Qual problema concreto este projeto resolve? (freeform, 1-2 frases)
2. Quem é o usuário primário? (radio: eu mesmo / time interno / cliente externo / público geral / outro)
3. Como esse usuário resolve hoje? (freeform — entender alternativas)
4. Qual a dor principal da solução atual? (freeform)

Rodada 2 — Solução e MVP
1. Em UMA frase, o que o produto faz? (freeform — proposta de valor)
2. Quais funcionalidades são MUST-HAVE no MVP? (multiselect com base no problema; mín 3, máx 7)
3. O que explicitamente NÃO faz parte do MVP? (multiselect; força definição de não-escopo)
4. Stack/plataforma preferida? (radio: Web / Mobile / Desktop / API-only / CLI / outro)

Rodada 3 — Sucesso e restrições
1. Como saberemos que o MVP foi bem-sucedido? (multiselect: métricas concretas — usuários, tempo economizado, receita, satisfação, outro)
2. Prazo desejado para o MVP? (radio: < 1 semana / 1-4 semanas / 1-3 meses / sem prazo)
3. Restrições conhecidas? (multiselect: orçamento / dependências externas / compliance / equipe / outro)
4. Premissas em que estamos apostando? (freeform — o que precisa ser verdade para o projeto fazer sentido)

Após as 3 rodadas, REESCREVA .ai/01_PROJECT_SCOPE.md inteiro neste formato:

```markdown
# 01_PROJECT_SCOPE.md — Escopo do Projeto (PRD curto)

Projeto: {{PROJECT_NAME}}  Código: {{PROJECT_CODE}}
Atualizado em: AAAA-MM-DD  Versão: 0.1

## 1. Problema
[1-2 frases — o que dói hoje]

## 2. Usuário primário
[Quem é, contexto de uso]

## 3. Solução em uma frase
[Proposta de valor — "X faz Y para Z conseguir W"]

## 4. MVP — Must-have
- [ ] Funcionalidade 1
- [ ] Funcionalidade 2
- [ ] ...

## 5. Fora do escopo (explicitamente)
- ...
- ...

## 6. Métricas de sucesso
- [Métrica 1 + meta]
- [Métrica 2 + meta]

## 7. Premissas
- ...

## 8. Restrições
- Prazo: ...
- Orçamento: ...
- Compliance/dependências: ...

## 9. Riscos iniciais
- ...

## 10. Stack / plataforma
- ...
```

REGRAS:
- Não inicie a Rodada 2 sem ter as respostas da Rodada 1.
- Sintetize cada resposta livre em 1 frase antes de avançar.
- Se o usuário responder "não sei" em algo crítico (problema, usuário, MVP),
  PARE e proponha 2-3 hipóteses para escolha — não invente.
- Ao final, NÃO implemente nada. Apenas:
  1. Reescreva 01_PROJECT_SCOPE.md.
  2. Atualize 02_ROADMAP.md derivando fases do MVP.
  3. Crie itens em 06_BACKLOG.md a partir das funcionalidades MUST-HAVE.
  4. Registre AIGOV-ACT em 03_ACTIVITY_LOG.md e chat em 08_CHAT_INDEX.md.
  5. Apresente resumo de 5 linhas e peça aprovação para iniciar a Fase 1.
```
