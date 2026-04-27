---
id: WP-99-S4
parent_wp: WP-99
title: "Human-layer health-check integration"
status: done
priority: high
owner: "Environment Engineer"
created: 2026-04-21
updated: 2026-04-21
---

# Контекст

Архитектура нового human-layer уже materialized:

- `Extractor Bank`
- `Доска выбора`
- `Доска стратега`
- beacon-слой для выбора и strategist board
- strategist skill contract

Но общий operational контур экзокортекса ещё не видит этот слой:

- `health-check.sh` не проверяет human-layer;
- `AGENTS-STATUS.md` не отражает состояние human-layer;
- `SESSION-OPEN` не учитывает human-layer в общем verdict.

# Цель

Встроить новый human-layer в единый health/status/report контур экзокортекса так, чтобы общий мозг системы одним взглядом показывал:

1. жив ли machine-layer;
2. жив ли human-layer;
3. есть ли stale/drift/manual attention;
4. можно ли доверять общему operational verdict.

# Scope

1. Правка `health-check.sh`
2. Правка `daily-report.sh`
3. Добавление human-layer verdict в `AGENTS-STATUS.md`
4. Добавление human-layer verdict в `SESSION-OPEN`
5. Truthful semantics для `green/yellow/red`

# Не входит в scope v1

- Полная двусторонняя sync-логика между Obsidian и `DS-strategy`
- Автоматическое создание WP по карточкам
- Глубокий рефактор strategist/extractor runtime

# Агентная схема

## Primary агент

- `Environment Engineer`

**Отвечает за:**
- единый observability contract;
- truthful integration в общий health verdict;
- stale/drift semantics.

## Support агент

- `Code Engineer`

**Отвечает за:**
- shell-реализацию checks;
- parsing beacon artifacts;
- безопасную правку report-layer.

## Product support

- `Strategist`

**Отвечает за:**
- human-readable wording для новых статусов;
- согласование нового human-layer verdict с explain-layer.

# Модель

- Primary design: `GPT-5`
- Implementation support: `Codex` / `GPT-5.4-mini`

# Acceptance

1. `health-check.sh` видит human-layer
2. `AGENTS-STATUS.md` показывает human-layer как часть общей системы
3. `SESSION-OPEN` учитывает human-layer в общем verdict
4. stale/missing human-layer больше не остаётся невидимым для общего мозга экзокортекса

# Rollout plan

## Шаг 1

Добавить shell-check для `Доски выбора` и `Доски стратега`

## Шаг 2

Протянуть их verdict в `health-check.sh`

## Шаг 3

Протянуть их verdict в `build_agents_status`

## Шаг 4

Протянуть их verdict в `build_session_open`

## Шаг 5

Проверить итоговый общий verdict end-to-end

# Следующий шаг

`Human-layer health-check integration` materialized и truthfully закрыт:

1. `health-check.sh` теперь видит:
   - `Доску выбора`
   - `00-Сводка доски выбора.md`
   - `Доску стратега`
   - `00-Свежесть доски стратега.md`
2. общий `health-check` теперь поднимает warning, если human-layer требует внимания;
3. `AGENTS-STATUS.md` теперь показывает отдельную строку:
   - `Obsidian human layer`
4. `SESSION-OPEN` теперь учитывает human-layer в общем verdict мозга экзокортекса;
5. end-to-end проверка прошла:
   - `health-check.sh` отработал успешно;
   - `daily-report.sh --refresh-status-artifacts` пересобрал `AGENTS-STATUS` и `SESSION-OPEN`;
   - текущий общий verdict честно `yellow`, потому что `Доска выбора` ждёт ручного решения.

Следующий логичный bounded slice:

- связать `Extractor Bank` и `Доску выбора` с более явной маршрутизацией в `РП` / `Pack`, если захочешь идти дальше.
