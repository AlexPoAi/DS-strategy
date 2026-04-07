---
type: engineering-work-product
wp_id: ENG.WP.011
title: Выравнивание opening-state и day-close маршрута экзокортекса
date: 2026-04-05
status: active
priority: critical
linked_inbox: ENGINEERING
author: Environment Engineer (Codex)
---

# ENG.WP.011 — Выравнивание opening-state и day-close маршрута экзокортекса

## Контекст

После серии ремонтов стало видно, что экосистема расходится в двух критичных пользовательских маршрутах:

1. **Открытие сессии**
   - `health-check` говорит одно
   - `daily-report` говорит другое
   - `AGENTS-STATUS.md` и `SESSION-OPEN (Экран открытия сессии).md` устаревают и не пересобираются автоматически

2. **Закрытие дня**
   - `strategist.sh day-close` и ручной агентный маршрут теперь входят в один протокол
   - но итоговый human-readable summary для пользователя и Telegram всё ещё не канонизирован

Пользовательское требование жёсткое:

- я и Claude должны проходить день по **одинаковому маршруту**
- после `открывай сессию` и `закрой день` не должно быть разных truth-источников
- summary должен быть один и того же класса и качества

## Симптомы

- `daily-report.sh` содержал path drift и не собирался
- свежий `SchedulerReport` уже пишется в `DS-agent-workspace`, а старые consumer-ы читают `DS-strategy/current`
- `AGENTS-STATUS.md` и `SESSION-OPEN (Экран открытия сессии).md` не пересобираются текущим refresh-маршрутом
- `health-check` пишет мягкий verdict `норма после перезагрузки`, который не равен настоящему session-open verdict
- `day-close` runner починен, но Telegram получает token report вместо канонического human-readable day-close summary

## Цель

Сделать единый operational contract:

### Для открытия дня

- один truthful verdict opening-state
- один источник истины для `SchedulerReport`, `AGENTS-STATUS.md`, `SESSION-OPEN`
- один refresh-маршрут, который реально пересобирает opening artifacts

### Для закрытия дня

- один канонический day-close route для всех агентов
- один human-readable итоговый summary
- token-report не подменяет собой закрытие дня

## Scope

- [daily-report.sh](/Users/alexander/Github/FMT-exocortex-template/roles/synchronizer/scripts/daily-report.sh)
- [health-check.sh](/Users/alexander/Github/FMT-exocortex-template/roles/synchronizer/scripts/health-check.sh)
- [templates/synchronizer.sh](/Users/alexander/Github/FMT-exocortex-template/roles/synchronizer/scripts/templates/synchronizer.sh)
- при необходимости downstream артефакты в `DS-strategy/current/`

## Deliverables

1. Fresh opening artifacts собираются текущим operational route.
2. `health-check` и `session-open` не противоречат друг другу по severity.
3. `day-close` summary существует как канонический выход.
4. Truthful summary одинаково достижим для меня и для Claude.

## Truthful стартовый статус

- path drift в `daily-report` уже подтверждён и частично снят
- `strategist day-close` уже выровнен с `protocol-close.md`
- главный текущий разрыв: **source-of-truth и user-facing summaries**, а не shell-entrypoints как таковые

## Фактический результат на 2026-04-05

### Opening-state

- [daily-report.sh](/Users/alexander/Github/FMT-exocortex-template/roles/synchronizer/scripts/daily-report.sh) починен по путям и снова собирается без template-placeholder drift
- в `daily-report.sh` восстановлена генерация:
  - [AGENTS-STATUS.md](/Users/alexander/Github/DS-strategy/current/AGENTS-STATUS.md)
  - [SESSION-OPEN (Экран открытия сессии).md](/Users/alexander/Github/DS-strategy/current/SESSION-OPEN%20%28%D0%AD%D0%BA%D1%80%D0%B0%D0%BD%20%D0%BE%D1%82%D0%BA%D1%80%D1%8B%D1%82%D0%B8%D1%8F%20%D1%81%D0%B5%D1%81%D1%81%D0%B8%D0%B8%29.md)
- свежий [SchedulerReport 2026-04-05.md](/Users/alexander/Github/DS-agent-workspace/scheduler/reports/SchedulerReport%202026-04-05.md) снова создаётся по operational route
- opening artifacts снова truthfully показывают сегодняшнее состояние, а не снимок конца марта

### Day Close

- [templates/synchronizer.sh](/Users/alexander/Github/FMT-exocortex-template/roles/synchronizer/scripts/templates/synchronizer.sh) выровнен на актуальный `SchedulerReport` в `DS-agent-workspace`
- `synchronizer/day-close` больше не зависит от устаревшего пути `DS-strategy/current/SchedulerReport ...`
- human-readable `day-close` summary приведён к контракту WP-41:
  - `🔒 Закрытие дня`
  - `✅ Что сделано`
  - `🟢/🟡 Состояние системы`
  - `🔜 На завтра (топ-3)`
- smoke test через [notify.sh](/Users/alexander/Github/FMT-exocortex-template/roles/synchronizer/scripts/notify.sh) пройден: новый `day-close` summary ушёл в Telegram

## Truthful итог

- **opening-state restored** — да
- **canonical day-close summary restored** — да
- **Claude и я опираемся на один и тот же operational route сильнее, чем раньше** — да

Остаточный риск:

- `health-check` всё ещё формулирует часть деградации как «норма после перезагрузки», а `SESSION-OPEN` как `yellow` verdict; это уже не path drift, а семантическая калибровка языка и severity
- `ENG.WP.010` остаётся актуален как слой про сам `day-close` protocol-runner, но пользовательский summary-route теперь выровнен

## Follow-up 2026-04-07 — Canonical MEMORY route

Новый агент при прохождении ритуала открытия мог ошибочно считать knowledge-infra жёлтой, если проверял legacy path `~/Github/MEMORY.md`, которого уже нет как отдельного файла.

Что исправлено:

- canonical route для WP Gate и ритуала открытия зафиксирован как `~/Github/memory/MEMORY.md`;
- root `~/Github/MEMORY.md` признан только backward-compatible alias, а не отдельным source-of-truth;
- ключевые opening instructions обновлены так, чтобы отсутствие root alias не трактовалось как инфраструктурная ошибка при наличии рабочего `memory/MEMORY.md`.

Truthful результат:

- новый агент больше не должен выдавать ложный yellow-status только из-за отсутствия старого root `MEMORY.md`;
- source-of-truth для knowledge/opening layer снова один: `memory/MEMORY.md`.
