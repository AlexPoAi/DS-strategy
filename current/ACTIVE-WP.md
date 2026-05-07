---
id: WP-138
title: Проверка влияния обновления IWE на Exocortex
status: in_progress
approved: true
approved_at: 2026-05-07
approved_by: user
sensitive_scope:
  - DS-strategy:current/ACTIVE-WP.md
  - DS-strategy:current/SESSION-CONTEXT.md
  - DS-strategy:inbox/WP-138-iwe-update-impact-audit-2026-05-07.md
  - DS-strategy:inbox/INBOX-TASKS.md
  - DS-strategy:inbox/extraction-reports/
  - DS-strategy:current/RUNTIME-MODE.md
---

# ACTIVE-WP — WP-138

Bounded slice на проверку последствий обновления IWE для рабочего контура Exocortex.

## Что делаем

- Проверяем актуальность IWE через `update.sh --check`.
- Прогоняем контур проверки Exocortex после обновления (агенты, health, status-артефакты, extractor следы).
- Фиксируем verdict и наблюдаемые риски в рабочих продуктах.

## Что уже подтверждено

- IWE обновление запущено и подтянуто до upstream `0.29.32`.
- Контур утреннего открытия сессии подтвердил, что extractor-агенты загружены (`obsidian-fleeting-intake`, `session-watcher`, `inbox-check`).

## Следующий шаг

1. Снять честный post-update verdict по Exocortex.
2. Зафиксировать carry-over задачи по найденным отклонениям (если будут).
