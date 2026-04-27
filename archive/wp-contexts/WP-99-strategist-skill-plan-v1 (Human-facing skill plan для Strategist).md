---
id: WP-99-S3
parent_wp: WP-99
title: "Strategist skill plan v1"
status: done
priority: high
owner: "Strategist"
created: 2026-04-21
updated: 2026-04-21
---

# Контекст

`Strategist Board v1` и `Safety Beacon v1` уже materialized, но сам `Strategist` всё ещё ощущается скорее как file-centric планировщик, чем как живой human-facing стратег.

Проблема сейчас двойная:

1. у `Strategist` нет явного skill-contract на человеческое объяснение:
   - почему это главное;
   - что не брать сейчас;
   - как спорить со strategist verdict;
   - как переводить мысль из `Extractor Bank` и `Доски выбора` в bounded work;
2. новый human-layer пока не встроен в единый health-check контур экзокортекса:
   - `health-check.sh` не видит `Доску выбора`;
   - `health-check.sh` не видит `Доску стратега`;
   - общий runtime/status verdict ещё не отражает новый Obsidian brain-layer.

# Цель

Сделать `Strategist skill plan v1`:

1. прописать `Strategist` как human-facing агента с русскоязычным explain-layer;
2. определить skill-contract для weekly/daily verdict;
3. описать, какие входы strategist обязан читать;
4. определить, как новый human-layer входит в единый `health-check` и report-layer.

## Архитектурное правило

Новый human-layer **не допускается** как отдельный side-monitoring контур.

Он обязан войти в общую систему экзокортекса:

- в единый `health-check.sh`;
- в общий status/report слой;
- в `AGENTS-STATUS.md`;
- в `SESSION-OPEN`;
- в общий operational verdict экзокортекса.

То есть система должна уметь отвечать одним взглядом:

- работает ли machine-layer;
- работает ли human-layer;
- есть ли drift между ними;
- можно ли доверять общему мозгу экзокортекса.

# Scope

1. Human-facing contract для `Strategist`
2. Русский explain-layer:
   - главное;
   - не брать сейчас;
   - почему;
   - следующий bounded шаг;
   - как оспаривать verdict
3. Skill-input matrix:
   - `WeekPlan`
   - `DayPlan`
   - `Extractor Bank`
   - `Доска выбора`
   - `Доска стратега`
   - активные `WP`
4. Integration contract:
   - как human-layer должен проверяться в `health-check.sh`
   - как human-layer должен отражаться в `AGENTS-STATUS` / `SESSION-OPEN`
   - как общий verdict экзокортекса должен учитывать новый контур

# Не входит в scope v1

- Полный рефактор всех strategist scripts
- Автогенерация verdict без ручной проверки на каждый запуск
- Двусторонняя синхронизация Obsidian и `DS-strategy`

# Агентная схема

## Primary агент

- `Strategist`

**Отвечает за:**
- human-facing explainability;
- weekly/daily priority framing;
- bounded next step selection;
- правила перевода мысли в работу.

**Методы и знания:**
- weekly planning
- backlog triage
- explainability
- priority framing
- decision hygiene

## Support агент

- `Knowledge Registry Curator`

**Отвечает за:**
- доменный вход из `Extractor Bank`;
- thematic clustering;
- curator summary для strategist context.

**Методы и знания:**
- domain mapping
- thematic clustering
- registry summaries

## Engineering support

- `Environment Engineer`

**Отвечает за:**
- truthful contract для health-check integration;
- observability нового human-layer;
- единый status/verdict слой без drift.

**Методы и знания:**
- observability
- contract design
- stale/drift semantics
- acceptance gates

## Tooling support

- `Code Engineer`

**Отвечает за:**
- минимальную автоматику для health-check/report integration;
- безопасные file-level checks;
- lightweight parsing human-layer артефактов.

# Модель

- Primary model: `GPT-5`
- Support implementation model: `GPT-5.4-mini` / `Codex` для узких scripting slices

# Work products

1. `Strategist Skill Contract`
2. `Strategist Explain-Layer Spec`
3. `Strategist Input Matrix`
4. `Health-check integration spec` для human-layer

# Strategist Skill Contract

`Strategist` в этом контуре больше не трактуется как агент, который только пишет `DayPlan` и `WeekPlan`.

Его human-facing обязанность:

1. объяснять по-русски, что сейчас главное;
2. объяснять, что не брать сейчас и почему;
3. показывать следующий bounded шаг;
4. помогать спорить с приоритетом конструктивно, а не через ощущение “план не тот”;
5. переводить человеческий смысл из `Obsidian` в рабочее решение без потери truthful contracts.

## Что strategist обязан уметь говорить человеку

Каждый human-facing verdict обязан содержать:

1. `Что главное`
2. `Почему именно это`
3. `Что не брать сейчас`
4. `Следующий лучший bounded шаг`
5. `Какой сигнал изменит решение`

## Что strategist не имеет права делать

1. Подменять собой `DS-strategy` как task source-of-truth
2. Подменять собой `Pack` как knowledge source-of-truth
3. Выдавать красивые приоритеты без ссылки на реальный активный контекст
4. Игнорировать новый human-layer в `Obsidian`, если он уже materialized

# Strategist Explain-Layer Spec

## Формат weekly verdict

Weekly verdict должен отвечать на 5 вопросов:

1. В чём главный риск недели
2. Какой главный фокус недели
3. Какие 1-3 направления реально главные
4. Что не надо смешивать с этим фокусом
5. Какой guiding principle держать всю неделю

## Формат daily verdict

Daily verdict должен отвечать на 5 вопросов:

1. Что сейчас главное в текущем окне
2. Какой следующий bounded шаг лучший
3. Что брать в работу прямо сейчас
4. Что не брать прямо сейчас
5. Как выглядит сигнал хорошего дня

## Обязательный стиль

1. Полностью на русском
2. Без канцелярита и file-centric формулировок
3. Сначала человеческий смысл, потом ссылка на систему
4. Без “всё важно”; strategist обязан сужать фокус

# Strategist Input Matrix

Перед human-facing verdict strategist обязан читать следующие слои.

## Обязательные входы

1. `WeekPlan`
   - роль: weekly source-of-truth
   - зачем: не дать human-layer оторваться от активного weekly луча

2. `DayPlan`
   - роль: текущее operational окно
   - зачем: daily verdict не должен противоречить реальному старту дня

3. Активные `WP`
   - роль: task/governance факт
   - зачем: strategist должен видеть, какие bounded slices реально открыты

4. `Доска выбора`
   - роль: human decision layer
   - зачем: strategist должен видеть, что пользователь уже приблизил к выбору

5. `Доска стратега`
   - роль: собственный human-facing контур strategist
   - зачем: проверить freshness, не плодить внутренний drift

## Желательные входы

1. `Extractor Bank`
   - роль: доменная библиотека мыслей
   - зачем: strategist видит не только задачи, но и сырой тематический фон

2. `captures`
   - роль: intake evidence
   - зачем: если нужно проверить, откуда вообще растёт мысль

## Правило приоритета входов

Если входы конфликтуют, порядок доверия такой:

1. `DS-strategy` active WP / WeekPlan / DayPlan
2. `Доска выбора`
3. `Доска стратега`
4. `Extractor Bank`
5. `captures`

То есть strategist может использовать Obsidian как human context, но не имеет права ломать governance truth.

# Health-Check Integration Spec

Новый human-layer должен входить в общий operational verdict экзокортекса.

## Что должен проверять `health-check.sh`

1. Наличие `Доски выбора`
2. Наличие `00-Сводка доски выбора.md`
3. Freshness `Доски выбора`
4. Наличие `Доски стратега`
5. Наличие `00-Свежесть доски стратега.md`
6. Статус `Доски стратега`: `свежо / требует внимания / устарело / ждёт ручного решения`
7. Базовый drift-check:
   - если strategist board помечен как `устарело`, общий verdict не может быть fully green

## Как это должно отражаться в общем статусе

В `AGENTS-STATUS.md` должен появиться отдельный слой human-facing контура, а не отдельный параллельный дашборд.

Минимум:

1. `Obsidian human layer`
2. `Доска выбора`
3. `Доска стратега`

В `SESSION-OPEN` должно появиться отражение human-layer в приборной панели среды.

Минимум:

1. `Obsidian human layer: green/yellow/red`
2. Если human-layer stale или missing, это должно поднимать общий verdict минимум до `yellow`

## Truthful semantics

1. `green`
   - human-layer materialized
   - beacon-файлы есть
   - strategist board свежий
   - selection board beacon читается

2. `yellow`
   - human-layer есть, но stale/needs attention/manual waiting
   - machine-layer жив, но human-layer уже не полностью надёжен

3. `red`
   - missing critical human-layer artifacts
   - human-layer broken так, что мозгу экзокортекса нельзя полностью доверять

# Результат v1

`Strategist skill plan v1` считается выполненным, если:

1. strategist описан как human-facing агент;
2. explain-layer rules materialized;
3. input matrix materialized;
4. integration contract для общего `health-check` / `AGENTS-STATUS` / `SESSION-OPEN` зафиксирован;
5. следующий implementation slice можно открывать без архитектурной двусмысленности.

# Acceptance

1. Ясно описано, что strategist обязан объяснять человеку по-русски
2. Ясно описано, какие слои strategist обязан читать перед verdict
3. Ясно описано, как human-layer входит в единый `health-check`
4. Ясно описано, как новый контур должен отражаться в `SESSION-OPEN` и `AGENTS-STATUS`
5. Зафиксировано, что отдельный monitoring-layer не допускается: только единый контур экзокортекса
6. После v1 можно открывать уже implementation-slice на правку `health-check.sh` и `daily-report.sh`

# Rollout plan

## Шаг 1

Зафиксировать human-facing skill contract для strategist

## Шаг 2

Собрать input matrix: какие артефакты strategist обязан читать

## Шаг 3

Описать explain-layer rules на русском

## Шаг 4

Зафиксировать integration contract для `health-check` / `AGENTS-STATUS` / `SESSION-OPEN`

## Шаг 5

Открыть implementation slice на встраивание human-layer в единый контур экзокортекса

# Следующий шаг

`Strategist skill plan v1` materialized и truthfully закрыт:

1. зафиксирован human-facing skill contract для strategist;
2. зафиксированы explain-layer rules на русском;
3. materialized input matrix;
4. зафиксирован integration contract нового human-layer в единый `health-check` / `AGENTS-STATUS` / `SESSION-OPEN`;
5. устранена архитектурная двусмысленность: новый контур обязан жить внутри общей экзосистемы, а не рядом.

Следующий рабочий продукт:

- implementation slice на правку `health-check.sh` и `daily-report.sh` для встраивания human-layer в общий verdict экзокортекса.
