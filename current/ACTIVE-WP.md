---
id: WP-127-canonical-agent-route-alignment
title: Единый маршрут Claude Codex и runtime по эталону Церена
status: in_progress
approved: direct-user-command
approval_consumed_at: 2026-04-28 23:58
approval_renewed_at: 2026-04-28
approved_at: 2026-04-28
approved_by: user
sensitive_scope:
  - DS-strategy:current/ACTIVE-WP.md
  - DS-strategy:current/SESSION-CONTEXT.md
  - DS-strategy:current/WeekPlan W18 2026-04-27.md
  - DS-strategy:inbox/WP-127-canonical-agent-route-alignment-with-tseren (Единый маршрут Claude Codex и runtime по эталону Церена).md
  - DS-strategy:docs/WP-REGISTRY.md
  - DS-strategy:current/ENGINEERING-CHRONOLOGY.md
  - /Users/alexander/Github/.claude/settings.json
---

# ACTIVE-WP — WP-127

Каноническое инженерное продолжение после day-close 2026-04-28.

## Что делаем

- Выравниваем единый маршрут для `Claude`, `Codex` и automation по эталону Церена.
- Сверяем каждый path/env/runtime слой с `upstream/main`, чтобы не уходить далеко от канона.
- Не открываем второй `codex-only` маршрут и не делаем полный rollback без крайней необходимости.

## Что уже подтверждено

- root hooks существуют, но раньше ломались из-за относительного `.claude/hooks/...`;
- root `memory` route был broken и вызывал расхождение контекста между агентами;
- `~/.iwe-paths` был неполным и не экспортировал `IWE_RUNTIME`;
- после первичного фикса hooks/memory/env ручной root route уже снова единый.

## Следующий шаг

1. Прогнать свежую runtime-проверку для scheduler/health-check.
2. Сверить remaining drift с `upstream/main`.
3. Починить только те хвосты, которые мешают единому маршруту.
