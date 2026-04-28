---
id: WP-101-daily-telegram-runtime-authority
title: Exocortex — единый authority daily Telegram
status: open
approved: direct-user-command
approval_consumed_at: 2026-04-29 01:05
approval_renewed_at: 2026-04-29
approved_at: 2026-04-29
approved_by: user
sensitive_scope:
  - DS-strategy:current/ACTIVE-WP.md
  - DS-strategy:inbox/WP-101-dedupe-exocortex-daily-telegram-source-and-runtime-authority (Убрать дубли daily-telegram и закрепить один источник истины статуса).md
---

# ACTIVE-WP — WP-101

Следующий инженерный carry-over после закрытия `WP-127` и `WP-128`.

## Что делаем

- Убираем dual-send daily Telegram и оставляем один canonical sender статуса.
- Держимся за уже подтверждённый route `local authority`, не ломая product/cloud сервисы.
- Не смешиваем `runtime alignment` с отдельной политикой отправки статуса.

## Что уже подтверждено

- локальный `launchctl/codex` уже признан основным sender daily-status;
- VPS-контур не должен присылать competing daily report в тот же основной чат;
- `WP-127` и `WP-128` сняли route/env/human-layer ambiguity и расчистили контур для чистого решения по sender authority.

## Следующий шаг

1. Проверить текущий sender path локально и на VPS.
2. Закрепить один authority route в runtime/policy.
3. Подтвердить, что в основной чат приходит ровно один daily status.
