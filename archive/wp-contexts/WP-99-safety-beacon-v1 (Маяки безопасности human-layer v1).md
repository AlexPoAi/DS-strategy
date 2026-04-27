---
id: WP-99-S2
parent_wp: WP-99
title: "Safety Beacon v1"
status: done
priority: high
owner: "Environment Engineer"
created: 2026-04-21
updated: 2026-04-21
---

# Контекст

Новые human-facing слои уже materialized:

- `Extractor Bank`
- `Доска выбора`
- `Доска стратега`

Но без явных safety-маяков пользователь не видит:

- что реально обновилось;
- что зависло;
- что stale;
- где возник drift между machine-layer и human-layer.

# Цель

Сделать `Safety Beacon v1` для human-layer так, чтобы система честно показывала:

1. сработал ли слой;
2. когда обновлялся последний раз;
3. что требует ручного решения;
4. есть ли противоречие с активным governance-layer.

# Scope

1. Beacon для `Доски выбора`
2. Beacon для `Доски стратега`
3. Русскоязычные статусы:
   - `свежо`
   - `требует внимания`
   - `устарело`
   - `ждёт ручного решения`
4. Truthful contract:
   - beacon не притворяется маршрутизатором;
   - beacon только показывает состояние.

# Не входит в scope v1

- Полная автосинхронизация `Obsidian -> DS-strategy`
- Автосоздание `РП` из карточек
- Автоматический разбор всех captures без ручной проверки

# Агентная схема

## Primary агент

- `Environment Engineer`

**Отвечает за:**
- freshness semantics;
- stale semantics;
- drift detection;
- truthful beacon contract.

**Методы и знания:**
- observability
- acceptance gates
- status semantics
- manual review checkpoints

## Support агент

- `Code Engineer`

**Отвечает за:**
- frontmatter parsing;
- summary generation;
- лёгкие безопасные скрипты.

**Методы и знания:**
- markdown parsing
- file-level automation
- summary scripts

## Product support

- `Strategist`

**Отвечает за:**
- human-readable wording;
- понятные формулировки сигналов;
- связь между beacon и decision flow.

# Модель

- Primary model: `GPT-5`
- Support implementation: `Codex` / `GPT-5.4-mini` для узких tooling slices

# Work products

1. `Safety Beacon Spec`
2. beacon-сводка для `Доски выбора`
3. beacon-сводка для `Доски стратега`
4. правила интерпретации сигналов

# Acceptance

1. Пользователь может зайти в human-layer и за минуту понять:
   - что свежее;
   - что устарело;
   - что выбрано, но не маршрутизировано;
   - где нужен ручной разбор
2. Все статусы на русском
3. Beacon не подменяет `DS-strategy`, а только сигнализирует
4. Есть хотя бы один проверяемый freshness-сигнал и один waiting/manual signal

# Rollout plan

## Шаг 1

Зафиксировать beacon contract и русские статусы

## Шаг 2

Доделать `Доску выбора` сводкой состояния

## Шаг 3

Доделать `Доску стратега` сводкой свежести и stale-сигналом

## Шаг 4

Проверить, что сигналы не противоречат активному `WeekPlan` и `DS-strategy`

# Следующий шаг

`Safety Beacon v1` materialized и truthfully закрыт:

1. `Доска выбора` получила автоматическую beacon-сводку:
   - `00-Сводка доски выбора.md`
   - считает статусы карточек;
   - показывает `ждёт ручного решения`, `кандидаты в Pack`, наличие/отсутствие маршрута;
2. найден и исправлен дефект beacon-скрипта:
   - служебная заметка без frontmatter больше не считается карточкой;
3. `Доска стратега` получила стандартизированный freshness-beacon:
   - `свежо`
   - `требует внимания`
   - `устарело`
   - `ждёт ручного решения`
4. bounded acceptance для v1 выполнен.

Следующий рабочий продукт:

- `Strategist skill plan v1` для human-facing объяснений и усиления explain-layer.
