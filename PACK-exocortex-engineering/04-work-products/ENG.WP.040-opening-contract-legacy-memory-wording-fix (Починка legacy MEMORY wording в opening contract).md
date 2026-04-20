---
id: ENG.WP.040
title: Починка legacy MEMORY wording в opening contract
status: done
created: 2026-04-20
updated: 2026-04-20
owner: Environment Engineer
---

# ENG.WP.040 — Opening Contract Legacy Wording Fix

## Контекст

Утренний health-check показывал две критичные ошибки opening contract:
- `legacy_memory_wording` в `DS-strategy/exocortex/protocol-open.md`
- `legacy_memory_wording` в `DS-strategy/exocortex/checklists.md`

## Сверка с Цереном и эталоном

1. В upstream Церена встречается wording `MEMORY.md`.
2. В нашем контуре эталон и проверка требуют canonical route `memory/MEMORY.md`.
3. Значит, локально нужен осознанный override под наш валидатор.

## Риск-анализ

- **Риск без фикса:** постоянный red при открытии дня, ложные тревоги, падение доверия к opening-state.
- **Риск частичного фикса:** если исправить только `DS-strategy/exocortex/*`, drift вернётся на следующем backup из source memory.
- **Снижение риска:** правка и source (`~/Github/memory/*`), и mirror (`DS-strategy/exocortex/*`).

## Реализация

Заменён legacy wording `MEMORY.md` -> `memory/MEMORY.md` в:
- `memory/protocol-open.md`
- `memory/checklists.md`
- `DS-strategy/exocortex/protocol-open.md`
- `DS-strategy/exocortex/checklists.md`
- `DS-strategy/exocortex/memory/protocol-open.md`
- `DS-strategy/exocortex/memory/checklists.md`

## Верификация

- Прогон: `roles/synchronizer/scripts/health-check.sh`
- Результат:
  - `OK: opening_contract_files:8`
  - критичные opening-contract ошибки сняты.

## Остаток

Не в scope этого WP:
- `strategist-week-review` failed;
- `extractor-inbox-check` stale.

Оба хвоста требуют отдельного bounded slice.
