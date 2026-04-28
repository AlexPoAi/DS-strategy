---
type: work-product
work_product: WP-128
title: Доска выбора и Scout — truthful freshness и verdict
date: 2026-04-29
status: in_progress
owner: Codex
parent: WP-127
tags:
  - exocortex
  - scout
  - obsidian
  - human-layer
---

# WP-128 — Доска выбора и Scout

## Зачем открыт

После восстановления canonical route и `Extractor` в health-layer остался человеческий хвост: `selection board stale`, а в day-open/Claude-route продолжал фигурировать `Scout`. Нужно truthfully развести:

- что является upstream core у Церена;
- что является локальным human-layer расширением;
- что реально сломано, а что просто stale по freshness.

## Что уже установлено

### 1. Доска выбора

- `selection board` warning шёл не от сломанного runtime, а от stale beacon.
- Beacon живёт в Obsidian vault:
  - `/Users/alexander/Documents/Творческий конвеер/Доска выбора/00-Сводка доски выбора.md`
- Генератор beacon:
  - `/Users/alexander/Documents/Творческий конвеер/.obsidian/scripts/selection_board_beacon.py`
- После ручного прогона `2026-04-29 00:50` свежий `health-check` на `2026-04-29 00:51` подтвердил:
  - `ОК: human-layer selection board beacon свежий`
  - `✅ Среда исправна`

### 2. Claude route

- Отдельного Claude skill для `Доски выбора` не найдено.
- Claude учитывает `Scout` в [day-open/SKILL.md](/Users/alexander/Github/.claude/skills/day-open/SKILL.md), но не имеет отдельной встроенной логики для `selection board`.
- Значит, по `Доске выбора` у нас не hidden Claude algorithm, а локальный freshness contract.

### 3. Сверка с Цереном

- В `upstream/main` нет отдельного upstream-core слоя для `Доски выбора`.
- По `Scout` upstream явно показывает optional/local статус:
  - `roles/synchronizer/scripts/collectors.d/README.md` описывает `scout.sh` как ночной разведчик `если настроен DS-agent-workspace/scout/`
  - `setup/optional/setup-agent-workspace.sh` создаёт `scout/` как часть optional agent workspace
- Значит, `Scout` в контуре Церена не core-runtime, а дополнительный локальный слой.

### 4. Scout у нас сейчас

- Живёт в:
  - `/Users/alexander/Github/DS-agent-workspace/scout`
- Последняя живая активность старая:
  - директория и файлы обновлялись в марте 2026
  - `analytics.md` фиксирует `Последнее обновление: 2026-03-23`
- Truthful текущая гипотеза:
  - `Scout` существует, но сейчас stale и не подтверждён как active-green контур.

## Решение на текущий момент

- `Доска выбора` не требует runtime-recovery: её нужно просто поддерживать свежей через beacon.
- `Scout` нужно не "чинить вслепую", а отдельно решить на уровне governance:
  - либо вернуть в активный weekly/day-open контур и снова регулярно materialize;
  - либо truthfully оставить как local optional layer со статусом stale/archival.

## Acceptance

- `selection board stale` снят как warning и объяснён как human-layer freshness, а не runtime defect.
- Зафиксирован truthful verdict по `Scout`: `active`, `stale`, либо `archival`.
- В weekly/engineering context не смешиваются upstream core и локальные расширения.

## Следующий шаг

1. Проверить, есть ли у `Scout` живой launch/report route или это уже архивный слой.
2. Принять truthful governance-verdict по `Scout`.
3. Зафиксировать решение в контексте и закрыть `WP-128`.
