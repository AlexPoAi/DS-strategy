---
type: work-product
id: WP-69
date: 2026-04-17
priority: critical
category: engineering
status: in_progress
---

# WP-69 — Pristine-выравнивание экзокортекса под Церен

## Цель

Убрать постоянные ремонтные циклы и выровнять инженерный контур по рабочему шаблону Церена: канонические маршруты памяти, переносимость runtime и предсказуемая валидация шаблона.

## Контракт выполнения

1. Сначала сверка с Цереном (template-first), потом фиксы в форке.
2. Безопасные изменения без destructive-reset.
3. Каждый шаг фиксируется в хронологии инженерного контура.

## Что уже выполнено (2026-04-17)

1. `FMT-exocortex-template`: удалены персональные хардкоды путей и Tseren-specific repo naming в runtime-слое.
2. `FMT-exocortex-template`: `memory/MEMORY.md` возвращён в формат скелета (валидация проходит).
3. `FMT-exocortex-template`: `setup/validate-template.sh` теперь проходит полностью (`ALL CHECKS PASSED`).
4. `DS-strategy/exocortex`: устранён legacy wording в opening contract (`MEMORY.md` -> `memory/MEMORY.md`) в `protocol-open.md` и `checklists.md`.

## Следующий срез

1. Прогнать live-postcheck экзокортекса после синка (статусы opening/runtime/extractor).
2. Закрыть остаточные красные статусы в brain verdict (если сохраняются после нормализации маршрутов).
3. Зафиксировать финальный closeout по WP-69 с rollback-note.

## Нанятый агент

- Environment Engineer (роль: выравнивание инженерного контура и runtime-контракта).
