---
type: work-product
id: WP-69
date: 2026-04-17
priority: critical
category: engineering
status: done
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
5. В post-check выявлен повторный drift root-копий `exocortex/*`; canonical wording восстановлен повторно и добавлен в обязательный контрольный прогон.

## Внешний блокер (2026-04-17)

1. На стороне Anthropic зафиксирован инцидент `organization disabled` для org `2e8cf63d-7da9-4588-8f78-243b5cf16659`.
2. Подан официальный appeal в Trust & Safety; статус — `waiting-response`.
3. До ответа Anthropic удерживаем инженерный контур через fallback-провайдеры и не используем чужие credentials.

## Следующий срез

1. ✅ Прогнать live-postcheck экзокортекса после синка (статусы opening/runtime/extractor/brain verdict).
2. ✅ Зафиксировать сверку с эталоном Церена (upstream/main) и текущий drift.
3. ⏳ Ожидать решения по appeal и зафиксировать post-incident contract по credentials/org (вынесено в отдельный reminder-трек, не блокирует инженерный closeout WP-69).
4. ✅ Зафиксировать финальный closeout по WP-69 с rollback-note.

## Нанятый агент

- Environment Engineer (роль: выравнивание инженерного контура и runtime-контракта).

## Post-check (2026-04-19)

1. `health-check`: критичных сбоев нет, opening/runtime контуры зелёные.
2. `validate-template`: `ALL CHECKS PASSED`.
3. Сверка с `upstream/main` (Церен) выполнена, новые апстрим-коммиты обнаружены и зафиксированы для отдельного whitelist-аудита.
4. Runtime truthful state: primary `codex`, fallback работает, canonical memory route стабилен.

## Закрытие

WP-69 закрыт как инженерный контур выравнивания. Внешний процесс `Anthropic appeal/refund` остаётся в отдельном reminder-треке и не считается незавершённым инженерным ремонтом этого WP.
