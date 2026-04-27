---
type: wp-context
wp: 94
title: Восстановление strategist week-review через Codex primary
status: done
priority: critical
owner: engineer
created: 2026-04-20
---

# WP-94 — Восстановление strategist week-review через Codex primary

## Контекст

После устранения legacy wording оставался предупреждающий блокер:
`strategist-week-review status=failed` с симптомом `Not logged in · Please run /login`.

## Диагностика

- Логи strategist показали принудительный override week-review в Claude path.
- Строка `Not logged in · Please run /login` не считалась auth-failure, из-за чего не включался codex fallback.

## Сверка и решение

- Выбрали целевой эталон текущего контура: primary provider = Codex при доступности.
- В `strategist.sh`:
  1. Убрали безусловный week-review override в Claude (теперь только при `STRATEGIST_WEEK_REVIEW_FORCE_CLAUDE=1`).
  2. Добавили распознавание `Not logged in .*Please run /login` как auth-failure.

## Результат

- Ручной запуск `week-review` прошёл успешно через Codex.
- `health-check` зелёный: `strategist-week-review status=success`.

