---
type: wp-context
wp: 96
title: Убрать обязательный Claude auth из канонических маршрутов
status: in_progress
priority: critical
owner: engineer
created: 2026-04-20
---

# WP-96 — Убрать обязательный Claude auth из канонических маршрутов

## Контекст

После вчерашнего инцидента подтвердился повторяющийся системный симптом:
`Not logged in · Please run /login (Claude path)`.

Проблема уже не про один сценарий `week-review`, а про сам canonical route layer:
- отдельные ритуалы и маршруты всё ещё могут заходить в обязательный `Claude path`;
- из-за этого любой агент может честно идти по правильному протоколу, но упираться в auth-blocker;
- пользовательский контракт нарушается: ритуал вроде существует, но не является guaranteed-working.

## Ритуал и метод работы

1. Сначала сверка с Цереном / upstream и живой реализацией.
2. Затем сверка с нашим эталоном: canonical route должен быть provider-agnostic, а не Claude-bound.
3. Потом оценка риска: что безопасно переключать на Codex сразу, а что нельзя ломать.
4. Только после этого кодовые правки и post-check.

## Что нужно сделать

1. Найти все живые canonical routes, где `Claude auth` всё ещё остаётся обязательным входом.
2. Убедиться, что `open / work / close / report` truthfully работают через `Codex`, если он доступен.
3. Убрать обязательность `claude /login` из тех маршрутов, где это противоречит уже зафиксированному контракту.
4. Прогнать post-check по агентам и ритуалам.
5. Зафиксировать anti-regression note в инженерном pack.

## Нанятые агенты

- `Archimedes` — sidecar-аудит на поиск оставшихся `Claude-first` route-хвостов.

## Целевой результат

- любой агент может пройти канонический ритуал без ручного `claude /login`, если `Codex` доступен;
- `Claude` остаётся только fallback / optional provider path;
- инженерный контур перестаёт зависеть от disabled / expired Anthropic auth.

## Slice 1 — Диагностика и первый safe fix

### Что подтвердилось

- В `day-close` больше не найден живой обязательный `Claude-first` route.
- Реальный хвост остался в `strategist week-review` как legacy/debug override:
  `STRATEGIST_WEEK_REVIEW_FORCE_CLAUDE=1`.
- В документации оставался устаревший тезис, что весь агентный контур требует `claude /login`.

### Что исправлено

1. Legacy override `week-review -> Claude` больше не может включиться случайно:
   теперь он требует сразу два флага:
   - `STRATEGIST_WEEK_REVIEW_FORCE_CLAUDE=1`
   - `STRATEGIST_ALLOW_LEGACY_CLAUDE_OVERRIDE=1`
2. `DS-strategy/docs/ARCHITECTURE.md` выровнен под фактический контракт:
   `Codex-primary / Claude-fallback`.
3. Комментарий в `FMT-exocortex-template/scripts/day-close.sh` выровнен:
   это provider-agnostic route, а не `Claude-only`.

### Проверка

- `bash -n roles/strategist/scripts/strategist.sh` — OK
- `bash -n scripts/day-close.sh` — OK

## Slice 2 — Synchronizer status freshness

### Карточка открытия

- Агент: `Engineer`
- Работа: убрать drift между живым execution и status-artifacts у `synchronizer`
- Slice: `synchronizer status freshness + truthful health artifacts`
- Причина: `health-check` и report-layer уже могли быть зелёными, но `.status`-артефакты для `synchronizer-code-scan` и `synchronizer-daily-report` оставались с датой `2026-03-26`

### Что подтвердилось

- `scheduler.sh` после успешного `code-scan` и `daily-report` обновлял только legacy daily markers (`STATE_DIR/task-DATE`), но не переписывал `status/*.status`.
- `daily-report.sh --refresh-status-artifacts` обновлял `AGENTS-STATUS`, `SESSION-OPEN` и `RUNTIME-MODE`, но сам `.status`-layer `synchronizer` не materialize.
- Из-за этого execution-layer был живой, а evidence-layer частично дрейфовал до следующего ручного refresh.

### Что исправлено

1. В `roles/synchronizer/scripts/scheduler.sh` добавлен явный writer для `synchronizer-code-scan` и `synchronizer-daily-report` status-artifacts прямо в обычном dispatch-path.
2. В `roles/synchronizer/scripts/daily-report.sh` добавлена materialization-фаза для `synchronizer` status-artifacts при `--refresh-status-artifacts`.
3. Для marker-derived success теперь сохраняются truthful `UPDATED_AT / LAST_SUCCESS_AT / START_TS / END_TS` вместо исторического дрейфа из старых `.status`.

### Проверка

- `bash -n roles/synchronizer/scripts/scheduler.sh` — OK
- `bash -n roles/synchronizer/scripts/daily-report.sh` — OK
- `bash roles/synchronizer/scripts/daily-report.sh --refresh-status-artifacts` — OK
- `bash roles/synchronizer/scripts/health-check.sh` — `✅ Среда исправна`

### Карточка закрытия

- Агент: `Engineer`
- Slice: `synchronizer status freshness + truthful health artifacts`
- Статус: `completed`
- Verdict: `synchronizer` больше не зависит от отдельного ручного refresh, чтобы его status-layer выглядел свежим и truthful; execution, health и report-layer снова выровнены между собой
- Следующий шаг: продолжать `WP-96` только если найдутся другие canonical route-хвосты, где execution и evidence-layer снова расходятся

## Slice 3 — Telegram outbox evidence

### Карточка открытия

- Агент: `Engineer`
- Работа: materialize локальный outbox след для реальных Telegram-сообщений
- Slice: `notify outbox evidence`
- Причина: фактическую доставку по логам видно, но точный текст уже отправленного сообщения потом приходится восстанавливать по шаблонам и git-снимкам

### Что подтвердилось

- `notify.sh` умел отправлять и логировать `sent / failed / empty skip`, но не сохранял сам фактический текст сообщения.
- `Bot API` через `getUpdates` не дал историю уже отправленных сообщений, поэтому post-factum verification упирается в ограничение API.
- Значит truthful verification transport-layer требует локального `outbox`-следа прямо в момент отправки.

### Что исправлено

1. В `roles/synchronizer/scripts/notify.sh` добавлен outbox-архиватор.
2. Для каждого сценария теперь сохраняются:
   - фактический `message.html`,
   - `buttons.json`,
   - `meta.env`,
   - `response.json` от Telegram API при наличии.
3. Архивация происходит не только для `sent`, но и для `failed` и `empty_skip`, чтобы транспортный след оставался truthful.

### Проверка

- `bash -n roles/synchronizer/scripts/notify.sh` — OK
- структура записи проверена по коду: архивируется именно тот текст, который уходит в `sendMessage` после truncation-safe подготовки

### Карточка закрытия

- Агент: `Engineer`
- Slice: `notify outbox evidence`
- Статус: `completed`
- Verdict: дальше Telegram-сообщения не нужно будет восстанавливать по косвенным следам; у transport-layer появился прямой локальный outbox evidence
- Следующий шаг: при ближайшей реальной отправке проверить, что в `~/logs/notify-outbox/YYYY-MM-DD/` появляются `message.html + response.json`
