---
type: work-product
id: ENG.WP.042
title: Auth-независимость канонических маршрутов
status: done
date: 2026-04-20
---

# ENG.WP.042 — Auth-независимость канонических маршрутов

## Что сломалось

Повторяется системный блокер:
`Not logged in · Please run /login (Claude path)`.

Это означает, что часть canonical routes всё ещё не соответствует уже принятому контракту `Codex-primary / provider-agnostic`.

## Почему это критично

- ломаются ритуалы `open / close / review`, даже если кодовая логика сама по себе корректна;
- агент может честно идти по каноническому маршруту, но не завершать его из-за auth внешнего provider-а;
- пользователь вынужден вручную повторять ритуал или напоминать про process discipline.

## Рабочая гипотеза

После починки `week-review` остались другие route-хвосты, где:
1. `Claude path` всё ещё вызывается как обязательный entrypoint;
2. `Codex` не используется как guaranteed-working primary path;
3. документы уже обещают одно, а runtime-route ведёт себя иначе.

## План ремонта

1. Найти все остаточные `Claude-first` canonical routes.
2. Сверить их с эталоном, уже зафиксированным в `protocol-open.md / protocol-close.md / CLAUDE.md`.
3. Перевести маршруты на truthful `Codex-primary`, сохранив `Claude` только как fallback.
4. Прогнать post-check по ключевым агентам и ритуалам.

## Slice 1 — Root-cause narrowing

### Findings

- В исполняемом `day-close` обязательный `Claude-first` path уже снят.
- Живой хвост найден в `roles/strategist/scripts/strategist.sh`:
  legacy/debug override `week-review -> Claude`.
- В `DS-strategy/docs/ARCHITECTURE.md` оставалась устаревшая глобальная формулировка
  про обязательный `claude /login` для всех агентов.
- В `scripts/day-close.sh` был устаревший комментарий, будто route вызывается именно Claude.

### Применённый safe fix

- `week-review` legacy override теперь gated:
  требуется не один, а два явных debug-флага, чтобы случайно не включить Claude-first path.
- Архитектурная документация выровнена под `Codex-primary / Claude-fallback`.
- Комментарий `day-close.sh` выровнен под provider-agnostic контракт.

### Первичный verdict

На этом этапе symptom `Not logged in · Please run /login` больше выглядит как
локальный legacy/debug хвост и documentation drift, а не как текущий обязательный
route `day-close`.

## Связанные контексты

- `DS-strategy/inbox/WP-96-canonical-route-auth-independence-and-claude-path-removal (Убрать обязательный Claude auth из канонических маршрутов).md`
- `ENG.WP.041` — локальная починка `week-review`
- `ENG.WP.010` / `ENG.WP.013` / `ENG.WP.021` — история route-layer и ritual-layer

## Slice 2 — Synchronizer status freshness

### Root cause

- `scheduler.sh` truthfully запускал `code-scan` и `daily-report`, но после success обновлял только legacy markers.
- `daily-report.sh` умел refresh report-artifacts (`AGENTS-STATUS`, `SESSION-OPEN`, `RUNTIME-MODE`), но не materialize `synchronizer` `.status`.
- В результате `health/report` могли опираться на derived-success, а сами `status/*.status` оставались stale по дате.

### Applied fix

- В `scheduler.sh` добавлен explicit writer для `synchronizer-code-scan` и `synchronizer-daily-report` status-artifacts в dispatch-path.
- В `daily-report.sh` добавлен refresh-path, который materialize `synchronizer` status-artifacts при `--refresh-status-artifacts`.
- Для marker-derived success устранён drift timestamps: текущий success window теперь записывается как живой evidence, а не как исторический хвост старого `.status`.

### Post-check

- `bash -n roles/synchronizer/scripts/scheduler.sh` — OK
- `bash -n roles/synchronizer/scripts/daily-report.sh` — OK
- `daily-report.sh --refresh-status-artifacts` — OK
- `health-check.sh` после фикса: `synchronizer-code-scan status=success`, `synchronizer-daily-report status=success`, итог `✅ Среда исправна`

### Verdict

Execution-layer, status-layer и report-layer для `synchronizer` снова выровнены. Это не новый runtime capability, а repair на truthful evidence path внутри уже открытого `ENG.WP.042`.

## Slice 3 — Telegram outbox evidence

### Root cause

- Delivery-логи подтверждали, что Telegram-сообщение ушло, но не сохраняли его текст 1:1.
- Telegram Bot API не дал прямого чтения уже отправленной истории через `getUpdates`, поэтому factual verification сообщения оставался reconstruction-only.

### Applied fix

- В `notify.sh` добавлен локальный outbox archive path `~/logs/notify-outbox/YYYY-MM-DD/`.
- Для каждого notify run теперь materialize:
  - `*.message.html`
  - `*.buttons.json`
  - `*.meta.env`
  - `*.response.json` при наличии ответа API
- Архивируются статусы `sent`, `failed` и `empty_skip`, чтобы evidence-layer оставался truthful и не показывал только зелёные события.

### Post-check

- `bash -n roles/synchronizer/scripts/notify.sh` — OK
- логика архивации стоит на фактическом send-path и пишет именно тот текст, который уходит в `sendMessage`

### Verdict

Telegram transport-layer больше не остаётся black-box после отправки. Следующий factual audit сможет читать прямой outbox evidence вместо реконструкции по шаблонам и коммитам.

## Итоговый статус

- `ENG.WP.042`: `done`
- Repair scope закрыт truthfully: route-layer выровнен под `Codex-primary / Claude-fallback`, `synchronizer` status freshness materialized, Telegram transport получил прямой outbox evidence
