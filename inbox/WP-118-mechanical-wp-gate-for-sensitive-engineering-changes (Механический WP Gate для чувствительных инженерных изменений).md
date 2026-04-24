---
type: work-product
id: WP-118
status: in_progress
priority: critical
created: 2026-04-24
updated: 2026-04-24
owner: Engineer
domain: exocortex
approved: true
---

# WP-118 — Механический WP Gate для чувствительных инженерных изменений

## Почему открыто

Инцидент 2026-04-24: агент выполнил инженерное упрощение root-helper'ов без предварительного открытия и согласования РП.

Вывод: текстовые правила, skills и CLAUDE.md недостаточны как предохранитель. Нужен механический gate в close-flow, который не позволит закрыть чувствительные изменения без активного одобренного РП.

## Согласованный scope

Разрешено:
- создать `DS-strategy/current/ACTIVE-WP.md`;
- добавить `WP-118` в контекстные слои `DS-strategy`;
- добавить проверку активного РП в `FMT-exocortex-template/scripts/close-task.sh`;
- обновить установленную копию `~/Github/close-task.sh`;
- проверить shell-синтаксис и close-flow.

Не входит:
- перенос `.claude`;
- миграция агентства;
- изменение launchd;
- массовая чистка репозиториев;
- откат предыдущих коммитов без отдельного решения.

## Acceptance criteria

- Если есть изменения в чувствительных зонах, `close-task.sh` требует `DS-strategy/current/ACTIVE-WP.md`.
- `ACTIVE-WP.md` должен содержать `approved: true`.
- Scope активного РП должен покрывать изменённые repo/path.
- Root-helper drift проверяется сравнением установленной копии с template source-of-truth.
- Без выполнения gate задача не считается закрытой.

## Чувствительные зоны v1

- `DS-strategy`
- `FMT-exocortex-template`
- root-helper'ы workspace:
  - `close-task.sh`
  - `open-codex-github.sh`
  - `strategist-wrapper.sh`
  - `Codex-Github.code-workspace`

## Ритуальное подтверждение

Пользователь подтвердил внедрение: `да` после предложения открыть РП на механический WP Gate.
