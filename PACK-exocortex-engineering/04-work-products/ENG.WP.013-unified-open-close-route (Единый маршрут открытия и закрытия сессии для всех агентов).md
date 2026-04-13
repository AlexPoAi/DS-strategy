---
type: engineering-work-product
wp_id: ENG.WP.013
title: Единый маршрут открытия и закрытия сессии для всех агентов
date: 2026-04-05
status: active
priority: critical
linked_inbox: ENGINEERING
author: Environment Engineer (Codex)
---

# ENG.WP.013 — Единый маршрут открытия и закрытия сессии для всех агентов

## Контекст

Пользователь считал, что `Codex` и `Claude` уже работают по одному маршруту `открывай сессию / закрой день`, но фактически маршрут расходился:

- `CLAUDE.md` и `FMT-exocortex-template/CLAUDE.md` описывали открытие/закрытие разными словами;
- `protocol-open.md` не закреплял канонический стартовый экран как обязательный контракт;
- `day-close` summary уже выровнен, но open-route ещё не был канонизирован на том же уровне.

## Цель

Сделать единый operational contract для всех агентов:

- один маршрут открытия сессии;
- один маршрут закрытия дня;
- один стартовый экран открытия;
- один human-readable day-close summary;
- никаких альтернативных «сокращённых» трактовок в разных `CLAUDE.md`.

## Scope

- [CLAUDE.md](/Users/alexander/Github/CLAUDE.md)
- [DS-strategy/exocortex/CLAUDE.md](/Users/alexander/Github/DS-strategy/exocortex/CLAUDE.md)
- [FMT-exocortex-template/CLAUDE.md](/Users/alexander/Github/FMT-exocortex-template/CLAUDE.md)
- [FMT-exocortex-template/memory/protocol-open.md](/Users/alexander/Github/FMT-exocortex-template/memory/protocol-open.md)
- [DS-strategy/exocortex/protocol-open.md](/Users/alexander/Github/DS-strategy/exocortex/protocol-open.md)

## Канонический контракт

### Открытие

Команды `открывай`, `открывай сессию`, `открывай день` должны вести в один и тот же маршрут:

1. чтение `protocol-open.md`;
2. сбор truthful opening-state;
3. вывод русского стартового экрана;
4. ритуал согласования;
5. только потом работа.

### Закрытие

Команды `закрываю`, `закрой день`, `всё`, `закрывай` должны вести в один и тот же маршрут:

1. чтение `protocol-close.md`;
2. truthful close-flow;
3. human-readable day-close summary;
4. `close-task.sh` как обязательное сохранение цикла.

## Truthful результат

- триггеры и маршруты на уровне `CLAUDE.md` выровнены;
- канонический стартовый экран закреплён в `protocol-open.md`;
- open/close route описан одинаково для всех агентов.

## Дополнительный hardening-срез (2026-04-13)

После появления ложного `red` startup-screen подтверждено:

- runtime/provider слой локально был жив;
- главный blocker шёл не от провайдеров, а от `opening-contract-check.sh`;
- check валился на legacy wording в:
  - `DS-strategy/exocortex/protocol-open.md`
  - `DS-strategy/exocortex/checklists.md`

Что исправлено:

- ссылки на голый `MEMORY.md` переведены на канонический путь `memory/MEMORY.md`;
- `opening-contract-check.sh` после правки снова возвращает `EXIT:0`.

Итог:

- startup-screen перестал краснеть из-за ложного protocol-route drift;
- маршрут открытия стал ближе к эталону: красный verdict теперь должен означать реальный structural/runtime blocker, а не устаревшую формулировку в документе.

## Примечание по source-of-truth

- versioned source-of-truth для маршрута теперь живёт в `DS-strategy/exocortex/*` и `FMT-exocortex-template/*`;
- корневой `~/Github/CLAUDE.md` — локальный mirror для рабочего окружения, он может обновляться синхронно, но не является единственным versioned источником истины.
