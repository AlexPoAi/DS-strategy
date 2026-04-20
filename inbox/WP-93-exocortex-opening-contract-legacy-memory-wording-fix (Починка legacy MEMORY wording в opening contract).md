---
id: WP-93
title: "Exocortex opening contract legacy MEMORY wording fix"
status: done
priority: critical
owner: "Environment Engineer"
created: 2026-04-20
updated: 2026-04-20
---

# Контекст

В `health-check` пришла критика:
- `legacy_memory_wording` в `DS-strategy/exocortex/protocol-open.md`
- `legacy_memory_wording` в `DS-strategy/exocortex/checklists.md`

Это ломало opening contract и краснило мозг экзокортекса при открытии дня.

# Ритуал: сверка с Цереном -> эталон -> риск

## 1) Сверка с Цереном (upstream)

- В upstream `FMT-exocortex-template` формулировки действительно местами используют `MEMORY.md`.
- Это допустимо для его маршрутов, но в нашем контуре валидатор требует canonical route `memory/MEMORY.md`.

## 2) Эталон для нашего контура

- Для `DS-strategy/exocortex/*` canonical путь: `memory/MEMORY.md`.
- Проверка `opening_contract_files` должна проходить без legacy wording.

## 3) Оценка риска

- Риск без фикса: повторяющийся red на открытии, ложное ощущение поломки контура.
- Риск фикса: drift между source/mirror, если изменить только зеркало.
- Решение: поправить и source (`~/Github/memory/*`), и зеркала `DS-strategy/exocortex/*`.

# Что сделано

1. В source и mirrors заменён legacy `MEMORY.md` -> canonical `memory/MEMORY.md`:
   - `memory/protocol-open.md`
   - `memory/checklists.md`
   - `DS-strategy/exocortex/protocol-open.md`
   - `DS-strategy/exocortex/checklists.md`
   - `DS-strategy/exocortex/memory/protocol-open.md`
   - `DS-strategy/exocortex/memory/checklists.md`
2. Прогнан `health-check.sh`.

# Результат

- Критичные opening contract ошибки сняты.
- `health-check`: `opening_contract_files:8` -> `OK`.
- Остались только non-critical хвосты:
  - `strategist-week-review` failed;
  - `extractor-inbox-check` stale (норма после перезагрузки).

# Следующий шаг

Отдельный bounded slice на `strategist-week-review` runtime failure.
