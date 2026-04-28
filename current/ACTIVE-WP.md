---
id: WP-128-human-layer-freshness-and-scout-verdict
title: Доска выбора и Scout — truthful freshness и verdict
status: in_progress
approved: direct-user-command
approval_consumed_at: 2026-04-29 00:43
approval_renewed_at: 2026-04-29
approved_at: 2026-04-29
approved_by: user
sensitive_scope:
  - DS-strategy:current/ACTIVE-WP.md
  - DS-strategy:current/SESSION-CONTEXT.md
  - DS-strategy:current/WeekPlan W18 2026-04-27.md
  - DS-strategy:inbox/WP-128-human-layer-freshness-and-scout-verdict-alignment (Доска выбора и Scout — truthful freshness и verdict).md
  - DS-strategy:docs/WP-REGISTRY.md
  - DS-strategy:current/ENGINEERING-CHRONOLOGY.md
---

# ACTIVE-WP — WP-128

Следующий bounded slice после восстановления extractor full-loop.

## Что делаем

- Разводим upstream core и локальные human-layer extensions truthfully.
- Проверяем, что именно делает `selection board` жёлтой: stale beacon, broken route или real manual-attention.
- Выносим truthful verdict по `Scout`: active контур, stale или archival.

## Что уже подтверждено

- `Доска выбора` не является upstream core-слоем Церена и не имеет отдельного Claude skill;
- stale-warning по `selection board` уже снят штатным refresh beacon и свежим `health-check`;
- `Scout` живёт отдельно в `DS-agent-workspace/scout`, давно не обновлялся и не подтверждён как live launchd/runtime сервис.

## Следующий шаг

1. Проверить, есть ли у `Scout` живой route кроме artifact-storage и day-open mention.
2. Decide по `Scout`: `active`, `stale` или `archival`.
3. Зафиксировать итоговый truthful verdict по human-layer.
