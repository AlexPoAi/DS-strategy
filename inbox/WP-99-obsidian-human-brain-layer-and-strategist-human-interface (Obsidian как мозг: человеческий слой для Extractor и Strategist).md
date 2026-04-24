---
id: WP-99
title: "Obsidian as human brain layer for Extractor and Strategist"
status: in_progress
priority: high
owner: "Strategist + Knowledge Registry Curator + Environment Engineer"
created: 2026-04-21
updated: 2026-04-24
---

# Контекст

Сейчас экосистема лучше понятна агентам, чем человеку:

- сырые мысли попадают в `Obsidian` и `Telegram`;
- дальше intake-layer ведёт их в `DS-strategy/inbox/captures.md`;
- `Extractor` и `Strategist` частично работают, но human-facing слой слабый;
- пользователь не видит удобного обзора:
  - какие мысли уже накоплены;
  - как они разложены по доменам;
  - что из этого уже тянет на РП;
  - что считать знанием для Pack;
  - что брать в работу прямо сейчас.

Дополнительный симптом:

- `Strategist` материализует полезные `DayPlan/WeekPlan`, но не даёт ясного человеческого explain-layer;
- `Extractor` работает как conveyor, но не как удобная обзорная библиотека мыслей.

# Цель

Сделать `Obsidian` главным human-facing мозгом системы, не ломая текущий машинный pipeline.

Итоговый контур должен стать таким:

1. `Obsidian/Telegram -> captures`
2. `Extractor` разбирает intake
3. Человеку возвращается обзор в `Obsidian`:
   - банк мыслей по доменам;
   - ручка выбора, что брать в работу;
   - понятный strategist-layer с human verdict
4. Машина и человек больше не расходятся по интерфейсу и пониманию статуса мысли

# Scope

1. `Obsidian human brain layer`
   - навигация по vault как по мозгу;
   - отдельный human-readable слой поверх `captures`.
2. `Extractor Bank`
   - библиотека сырых/полусырых мыслей по предметным областям.
3. `Selection Board`
   - ручка выбора: что в работу, что в Pack, что на потом.
4. `Strategist human interface`
   - отдельный explain-layer для daily/weekly verdict.
5. `Safety & observability`
   - маяки: что обновилось, что не обновилось, где stale, где drift.

# Не входит в scope сейчас

- Полная автоматическая двусторонняя синхронизация всех статусов между `Obsidian`, `DS-strategy`, `Pack` и `Telegram`.
- Полный перенос source-of-truth задач из `DS-strategy` в `Obsidian`.
- Массовая перестройка всей структуры live Obsidian vault.

# Acceptance

1. Пользователь может зайти в `Obsidian` и увидеть:
   - мысли по доменам;
   - отдельный слой выбора;
   - отдельный strategist verdict layer.
2. По каждой выбранной мысли понятен следующий ручной путь:
   - `РП`
   - `Pack`
   - `later`
   - `keep raw`
3. Есть safety-маяки:
   - обновлялся ли `Extractor Bank`;
   - обновлялся ли `Selection Board`;
   - обновлялся ли strategist human layer;
   - есть ли drift между `captures` и human layer.
4. Стратег получает human-facing skill/contract, а не только file-output.
5. Архитектура остаётся truthful:
   - `captures` = queue для машины;
   - `Obsidian` = human interface;
   - `DS-strategy` = task/governance layer;
   - `Pack` = knowledge source-of-truth.
6. Новый human-layer не живёт отдельным monitoring-контуром:
   - он обязан быть встроен в единый `health-check`, `AGENTS-STATUS`, `SESSION-OPEN` и общий verdict экзокортекса.

# Архитектурные решения

## 1. Источник истины не переносим

- `captures.md` остаётся intake-очередью для машины;
- `DS-strategy` остаётся task/governance source-of-truth;
- `Pack` остаётся knowledge source-of-truth;
- `Obsidian` становится главным human-facing обзорным интерфейсом.

## 2. Новые human-facing слои

### A. `Extractor Bank`

Обзор банка мыслей по доменам.

### B. `Selection Board`

Ручной выбор, что делать дальше с мыслью.

Минимальные статусы:

- `new`
- `selected`
- `task`
- `pack`
- `later`

### C. `Strategist Board`

Человеческий слой, где стратег объясняет:

- что считает главным;
- что считает шумом;
- что предлагает взять в работу;
- что сознательно не брать сейчас.

# Этапы rollout

## Этап 1. Картография и truthful контракты

Цель:
- описать роли слоёв и границы истины;
- не смешать queue, governance и human-view.

Результат:
- архитектурная карта;
- glossary статусов;
- contract matrix.

## Этап 2. `Extractor Bank`

Цель:
- дать пользователю читаемую библиотеку мыслей по доменам.

Результат:
- папка в `Obsidian`;
- разделы по доменам;
- простая навигация.

## Этап 3. `Selection Board`

Цель:
- дать ручной инструмент выбора, что делать с мыслью дальше.

Результат:
- карточки выбора;
- frontmatter-статусы;
- manual-first workflow.

## Этап 4. `Strategist human layer`

Цель:
- сделать стратега видимым и понятным.

Результат:
- strategist board;
- daily/weekly human verdict;
- skill-plan для Strategist.

## Этап 5. Safety-маяки

Цель:
- видеть, что pipeline живой, а не “кажется работает”.

Результат:
- маркеры обновления;
- drift-checks;
- stale alerts;
- manual review checkpoints.

# Текущий статус bounded slices

1. `Selection Board v1`
   - статус: `done`
   - итог: materialized в `Obsidian` как русскоязычный слой ручного выбора

2. `Strategist Board v1`
   - статус: `done`
   - связанный WP: `WP-99-S1`
   - итог: materialized в `Obsidian` как human-facing verdict layer

3. `Safety Beacon v1`
   - статус: `done`
   - связанный WP: `WP-99-S2`
   - итог: materialized truthful сигналы `fresh/stale/manual attention` для `Доски выбора` и `Доски стратега`

4. `Strategist skill plan v1`
   - статус: `done`
   - связанный WP: `WP-99-S3`
   - итог: strategist прописан как human-facing агент, integration contract в единый `health-check` зафиксирован

5. `Human-layer health-check integration`
   - статус: `done`
   - связанный WP: `WP-99-S4`
   - итог: human-layer встроен в `health-check`, `AGENTS-STATUS` и `SESSION-OPEN`

# Назначение агентов по этапам

## Этап 1. Архитектура

- Primary: `Strategist`
- Support: `Environment Engineer`
- Модель: `GPT-5`
- Почему: нужен сильный смысловой разбор границ истины и workflow

### Ответственность

- `Strategist`:
  - определяет человеческую логику контура;
  - различает, где `мысль`, где `задача`, где `знание`;
  - проектирует weekly/daily explain-layer;
  - удерживает правило `1 домен -> 1 главный активный РП`.
- `Environment Engineer`:
  - проверяет, что архитектура не ломает truthful contracts;
  - следит, чтобы новые слои имели проверяемые маяки;
  - не даёт смешать source-of-truth между `Obsidian`, `DS-strategy`, `Pack`.

### Знания и методы

- `Strategist`:
  - weekly planning;
  - backlog triage;
  - human-facing prioritization;
  - explanation-first planning.
- `Environment Engineer`:
  - observability;
  - status semantics;
  - drift detection;
  - acceptance gates.

## Этап 2. Extractor Bank

- Primary: `Knowledge Registry Curator`
- Support: `Strategist`
- Модель: `GPT-5`
- Почему: задача на доменную картографию и human-readable укладку

### Ответственность

- `Knowledge Registry Curator`:
  - раскладывает мысли по предметным областям;
  - собирает human-readable обзор банка мыслей;
  - удерживает навигацию по доменам, а не по случайным файлам.
- `Strategist`:
  - проверяет, что доменная укладка помогает выбору приоритетов;
  - не даёт банку превратиться в мёртвый архив.

### Знания и методы

- `Knowledge Registry Curator`:
  - domain mapping;
  - registry thinking;
  - curator-style human summaries;
  - связка `Extractor -> Curator -> Strategist`.
- `Strategist`:
  - decision framing;
  - weekly relevance check;
  - work-selection heuristics.

## Этап 3. Selection Board

- Primary: `Strategist`
- Support: `Code Engineer`
- Модель: `GPT-5`
- Почему: нужен дизайн decision-layer и статусов

### Ответственность

- `Strategist`:
  - задаёт статусы и правила переходов;
  - объясняет, когда мысль идёт в `РП`, `Pack` или `later`;
  - проектирует ручной human workflow.
- `Code Engineer`:
  - делает минимальную механику чтения frontmatter;
  - пишет лёгкие скрипты/summaries без тяжёлой автоматизации;
  - не переносит source-of-truth из `DS-strategy`.

### Знания и методы

- `Strategist`:
  - task framing;
  - “bounded next step”;
  - manual-first workflow design.
- `Code Engineer`:
  - markdown/frontmatter parsing;
  - small tooling;
  - safe automation;
  - file-level contracts.

## Этап 4. Strategist human layer

- Primary: `Strategist`
- Support: `Knowledge Registry Curator`
- Модель: `GPT-5`
- Почему: это skill/explainability слой, а не чистая автоматика

### Ответственность

- `Strategist`:
  - выдаёт human-readable verdict;
  - объясняет, что главное, что шум, что переносится;
  - собирает daily/weekly board на русском.
- `Knowledge Registry Curator`:
  - подаёт стратегу банк мыслей в удобной форме;
  - помогает стянуть домены в ясную картину.

### Знания и методы

- `Strategist`:
  - weekly review;
  - daily planning;
  - narrative prioritization;
  - explainability.
- `Knowledge Registry Curator`:
  - thematic clustering;
  - cross-domain navigation;
  - “что уже накоплено” summaries.

## Этап 5. Safety-маяки

- Primary: `Environment Engineer`
- Support: `Code Engineer`
- Модель: `GPT-5` для архитектуры, `gpt-5.4-mini` допустим для узких code-slices
- Почему: здесь уже нужна проверяемая observability и safety semantics

### Ответственность

- `Environment Engineer`:
  - задаёт набор маяков;
  - определяет, что считать `fresh`, `stale`, `drift`, `manual waiting`;
  - проверяет, что новый слой не стал немым.
- `Code Engineer`:
  - materialize скрипты/сводки;
  - делает лёгкие отчёты по карточкам;
  - даёт минимальную автоматизацию без хрупкой магии.

### Знания и методы

- `Environment Engineer`:
  - safety checks;
  - observability design;
  - truthful status semantics.
- `Code Engineer`:
  - automation scripts;
  - report generation;
  - stable file I/O contracts.

# Матрица ответственности

| Этап | Primary агент | Support агент | Что делает primary | Что делает support |
|---|---|---|---|---|
| Архитектура | `Strategist` | `Environment Engineer` | задаёт human workflow и границы слоёв | проверяет truthful contracts и safety |
| `Extractor Bank` | `Knowledge Registry Curator` | `Strategist` | раскладывает мысли по доменам | сверяет с приоритетами и полезностью |
| `Selection Board` | `Strategist` | `Code Engineer` | задаёт статусы и ручной decision-flow | materialize лёгкую механику |
| `Strategist Board` | `Strategist` | `Knowledge Registry Curator` | пишет human verdict на русском | даёт доменную картину и summaries |
| `Safety-маяки` | `Environment Engineer` | `Code Engineer` | определяет beacons и semantics | делает скрипты/сводки |

# Skill-план

## Новые/усиливаемые скиллы

1. `Strategist`
   - human-facing verdict
   - weekly/daily explanation layer
   - ручное объяснение “почему это приоритет”
2. `Knowledge Registry Curator`
   - human-readable domain bank
   - ручная библиотека мыслей по доменам
3. `Environment Engineer`
   - safety beacons
   - drift/stale observability
4. `Code Engineer`
   - minimal automation for reading frontmatter statuses
   - sync/check scripts

# Safety-маяки

## Минимальный пакет

1. `Extractor Bank freshness beacon`
   - когда последний раз банк пересобирался из `captures`
2. `Selection Board drift beacon`
   - есть ли выбранные карточки без маршрутизации в `DS-strategy`
3. `Strategist Board freshness beacon`
   - есть ли актуальный daily/weekly verdict
4. `captures vs Obsidian drift beacon`
   - появились ли новые capture, которых ещё нет в human layer
5. `manual review beacon`
   - сколько карточек ждут ручного решения дольше N дней

# Первый bounded slice

Не делать всё сразу.

Самый честный первый slice:

1. зафиксировать contract matrix;
2. materialize `Selection Board` в Obsidian;
3. определить формат статусов;
4. сделать первый ручной цикл на 3-5 реальных мыслях.

# Выполненные bounded slices

1. ✅ `Selection Board v1`
   - materialized в `Obsidian`
   - добавлены первые реальные карточки выбора
2. ✅ `Strategist Board v1`
   - открыт как отдельный bounded work product `WP-99-S1`
   - materialized в `Obsidian` как human-facing слой стратега
3. ✅ `Live Obsidian vault cleanup and source unification`
   - живой vault подтверждён как `/Users/alexander/Documents/Творческий конвеер`
   - старое git-зеркало `/Users/alexander/Github/creativ-convector` удалено как источник путаницы
   - runtime-маршруты `health-check`, `daily-report`, `unprocessed-notes-check`, `chain-report`, `obsidian-to-captures`, `session-tasks` переведены на live vault
   - полезные архивные заметки возвращены во `1. Исчезающие заметки`
   - пустые/технические Obsidian `base/canvas` оставлены в карантине, а не во входящих
   - проверка: `health-check` завершился `✅ Среда исправна`

# Следующий шаг

После унификации live vault идти в `Safety Beacon v1` как следующий bounded slice с truthfully проверяемыми маяками и drift-check между `Obsidian` и `captures`.
