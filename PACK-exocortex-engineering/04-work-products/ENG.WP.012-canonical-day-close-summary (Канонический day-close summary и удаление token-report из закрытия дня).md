---
type: engineering-work-product
wp_id: ENG.WP.012
title: Канонический day-close summary и удаление token-report из закрытия дня
date: 2026-04-05
status: active
priority: critical
linked_inbox: ENGINEERING
author: Environment Engineer (Codex)
---

# ENG.WP.012 — Канонический day-close summary и удаление token-report из закрытия дня

## Контекст

После выравнивания opening-state и day-close route стало видно, что сам пользовательский итог дня ещё не стабилизирован до одного контракта:

- Claude присылает хороший human-readable day-close summary
- автоматический close-flow может прислать только token-report
- пользователь явно подтвердил, что token-report не нужен и не несёт operational value

Требование пользователя к каноническому итогу дня:

1. видно состояние экзокортекса;
2. видно, какие агенты реально отработали;
3. видно, что сделано за день;
4. видно, что в работе;
5. видно, где нужно внимание пользователя;
6. видно, какие приоритеты брать завтра первыми.

## Цель

Сделать единый day-close contract для всех агентов:

- human-readable summary обязателен;
- token-report исключён из обязательного close-route;
- summary одинакового класса доступен и через `strategist day-close`, и через канонический `protocol-close`, и через Telegram notify route.

## Scope

- [close-task.sh](/Users/alexander/Github/close-task.sh)
- [protocol-close.md](/Users/alexander/Github/FMT-exocortex-template/memory/protocol-close.md)
- [templates/synchronizer.sh](/Users/alexander/Github/FMT-exocortex-template/roles/synchronizer/scripts/templates/synchronizer.sh)

## Канонический контракт day-close summary

Итог после команды `закрой день` должен содержать:

1. `Состояние экзокортекса`
2. `Какие агенты отработали`
3. `Что сделано за день`
4. `Что в работе`
5. `Где нужно внимание`
6. `Приоритеты на завтра`

## Правило по token-report

- token-report больше не является обязательной частью закрытия дня;
- close-route не должен подменять human-readable summary техническим usage-отчётом;
- при необходимости token-report может существовать как отдельный диагностический инструмент, но не как часть day-close contract.

## Truthful результат

- token-report исключён из обязательного close-route;
- day-close summary расширен до управленческого отчёта;
- канонический состав итогового отчёта закреплён в протоколе Day Close.
