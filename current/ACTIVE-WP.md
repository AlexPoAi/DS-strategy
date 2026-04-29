---
id: WP-129-scout-review-layer-for-tseren-core
title: Scout как review-input слой для ядра Церена
status: in_progress
approved: direct-user-command
approval_consumed_at: 2026-04-29 13:50
approval_renewed_at: 2026-04-29
approved_at: 2026-04-29
approved_by: user
sensitive_scope:
  - DS-strategy:current/ACTIVE-WP.md
  - DS-strategy:current/SESSION-CONTEXT.md
  - DS-strategy:current/WeekPlan W18 2026-04-27.md
  - DS-strategy:current/DayPlan 2026-04-29.md
  - DS-strategy:docs/WP-REGISTRY.md
  - DS-strategy:inbox/WP-129-scout-review-layer-for-tseren-core (Scout как review-input слой для ядра Церена).md
---

# ACTIVE-WP — WP-129

Новый bounded slice после day-open 2026-04-29.

## Что делаем

- Возвращаем `Scout` как review/input слой для ядра Церена.
- Не даём `Scout` превратиться во второй центр приоритетов или параллельную доску.
- Привязываем его выходы к `Strategist`, `DayPlan`, `WeekPlan` и `Требует внимания`.

## Что уже подтверждено

- `Scout` у Церена и у нас не является обязательным core-runtime сервисом;
- локальный `Scout` stale по данным `analytics.md` и мартовским отчётам;
- `Доска выбора` не должна быть competing layer поверх ядра Церена.

## Следующий шаг

1. Проверить текущий запуск и review-route `Scout`.
2. Зафиксировать целевой контракт `Scout` как input-layer.
3. Вернуть его в локальный рабочий контур без параллельной доски.
