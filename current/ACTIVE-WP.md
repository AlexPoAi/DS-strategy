---
id: WP-129-scout-review-layer-for-tseren-core
title: Scout как review-input слой для ядра Церена
status: done
approved: consumed
approval_consumed_at: 2026-04-29 14:45
approval_renewed_at: 2026-04-29
approved_at: 2026-04-29
approved_by: user
sensitive_scope:
  - DS-strategy:current/ACTIVE-WP.md
  - DS-strategy:current/SESSION-CONTEXT.md
  - DS-strategy:current/WeekPlan W18 2026-04-27.md
  - DS-strategy:docs/WP-REGISTRY.md
  - DS-strategy:inbox/WP-129-scout-review-layer-for-tseren-core (Scout как review-input слой для ядра Церена).md
  - DS-strategy:archive/wp-contexts/WP-129-scout-review-layer-for-tseren-core (Scout как review-input слой для ядра Церена).md
  - DS-strategy:exocortex/
---

# ACTIVE-WP — WP-129

Закрытый bounded slice после day-open 2026-04-29.

## Что делаем

- Закрываем bounded slice про `Scout` как review/input слой для ядра Церена.
- Фиксируем, что `Scout` не становится вторым центром приоритетов или параллельной доской.
- Оставляем operational launcher/runbook отдельным следующим WP, если он вообще понадобится.

## Что уже подтверждено

- `Scout` у Церена и у нас не является обязательным core-runtime сервисом;
- локальный `Scout` stale по данным `analytics.md` и мартовским отчётам;
- `Доска выбора` не должна быть competing layer поверх ядра Церена;
- контракт `Scout -> review/input -> Strategist core -> DayPlan/WeekPlan/Attention` materialized в `DS-agent-workspace`.

## Следующий шаг

1. Если понадобится operational-возврат `Scout`, открыть отдельный WP под runbook/launcher.
2. Не смешивать этот следующий шаг с уже закрытым контрактным slice.
