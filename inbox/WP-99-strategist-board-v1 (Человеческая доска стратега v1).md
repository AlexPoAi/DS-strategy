---
id: WP-99-S1
parent_wp: WP-99
title: "Strategist Board v1"
status: done
priority: high
owner: "Strategist"
created: 2026-04-21
updated: 2026-04-21
---

# Контекст

Пользователь не чувствует `Strategist` как видимого стратега:

- `DayPlan` и `WeekPlan` существуют, но живут как file-output;
- нет human-facing обзорного слоя в `Obsidian`;
- нет короткого понятного verdict:
  - что главное;
  - что шум;
  - что брать сейчас;
  - что сознательно не брать.

Нужен отдельный bounded slice, который не меняет весь `Strategist`, а materialize первый человеческий интерфейс стратега в `Obsidian`.

# Цель

Сделать `Strategist Board v1` — русскоязычный human-facing слой в `Obsidian`, где стратег объясняет:

1. главный фокус недели;
2. главный фокус дня;
3. что брать сейчас;
4. что откладывать;
5. почему.

# Scope

1. Папка `Доска стратега` в `Obsidian`
2. `README` и contract use-case
3. `Недельный verdict`
4. `Дневной verdict`
5. `Почему именно это главное`
6. Safety-маяки для freshness и stale

# Не входит в scope v1

- Полная автоматическая генерация на каждый день без ручной проверки
- Автосинхронизация с `DS-strategy` в обе стороны
- Полный рефактор промптов `Strategist`

# Агентная схема

## Primary агент

- `Strategist`

**Отвечает за:**
- human-readable verdict;
- объяснение приоритетов;
- перевод weekly/daily plan в человеческий обзор.

**Методы и знания:**
- weekly planning
- daily planning
- backlog triage
- bounded next step
- explainability

## Support агент

- `Knowledge Registry Curator`

**Отвечает за:**
- подачу доменного контекста;
- сводку банка мыслей;
- тематическую сборку входящего материала.

**Методы и знания:**
- thematic clustering
- domain mapping
- registry summaries

## Инженерный support

- `Environment Engineer`

**Отвечает за:**
- freshness/stale semantics;
- safety beacons;
- truthful contract для board-layer.

# Модель

- Primary model: `GPT-5`
- Почему:
  - нужен сильный смысловой synthesis;
  - это не coding-first slice, а explainability/design slice.

# Work products

1. `Доска стратега/README.md`
2. `Недельный verdict.md`
3. `Дневной verdict.md`
4. `Как читать сигналы стратега.md`
5. `Freshness beacon` для board-layer

# Acceptance

1. В `Obsidian` есть отдельная `Доска стратега`
2. Пользователь может открыть её и за 1-2 минуты понять:
   - что сейчас главное;
   - почему;
   - что не брать;
   - что следующий лучший шаг
3. Формулировки полностью на русском
4. Есть хотя бы один safety-beacon:
   - когда board обновлялся последний раз
5. `Strategist Board` не подменяет:
   - `WeekPlan`
   - `DayPlan`
   - `DS-strategy`
   а только делает их human-readable

# Safety-маяки

1. `Strategist Board freshness`
   - дата последнего обновления
2. `Strategist Board drift`
   - weekly/day verdict не должен противоречить активному `WeekPlan`
3. `Strategist Board stale`
   - если board старее рабочего окна, это должно быть видно

# Rollout plan

## Шаг 1

Materialize структуру `Доски стратега` в `Obsidian`

## Шаг 2

Написать `README` и человеческий contract

## Шаг 3

Сделать `Недельный verdict v1`

## Шаг 4

Сделать `Дневной verdict v1`

## Шаг 5

Добавить freshness beacon

# Следующий шаг

`Strategist Board v1` materialized и truthfully закрыт:

1. создана папка `Доска стратега` в `Obsidian`;
2. добавлены:
   - `README`;
   - `Недельный verdict`;
   - `Дневной verdict`;
   - `Как читать сигналы стратега`;
   - служебная заметка по freshness;
3. human-facing слой полностью на русском;
4. bounded acceptance для v1 выполнен.

Следующий рабочий продукт:

- `Safety Beacon v1` для `Selection Board` и `Strategist Board`.
