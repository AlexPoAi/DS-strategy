---
id: ENG.WP.030
name: Доведение агентного слоя до подтверждённого целевого состояния
status: active
created: 2026-04-08
last_updated: 2026-04-08
owner: Environment Engineer
---

# ENG.WP.030 — Доведение агентного слоя до подтверждённого целевого состояния

## Контекст

Пользователь справедливо указал на системный разрыв: часть агентных ролей в документации описана сильнее, чем они подтверждены реальной работой.

Это особенно заметно на примере `Strategist`:
- в замысле он должен помогать разбирать хаос входящих и удерживать картину недели;
- в эксплуатации он реально доказал в основном ритуалы, weekly/morning/note-review и координационный слой;
- доказанного end-to-end поведения по структурированию хаоса репозиториев пока нет.

Значит, агентный слой нужно довести до truthful состояния:
- убрать завышенные claims;
- разделить `confirmed now` и `target capability`;
- верифицировать агентов на живых сценариях;
- зафиксировать зрелость каждого агента.

## Цель

Перевести агентный слой из режима `architecture intent` в режим `operationally verified capability`.

## Acceptance

- по каждому агенту описаны `confirmed capabilities` и `target capabilities`;
- завышенные обещания убраны или помечены как target-state;
- есть минимум по одному живому end-to-end сценарию на ключевого агента;
- зафиксированы failure modes и post-check;
- выдан итоговый truthful verdict: `ready / partial / design-only / broken`.

## Truth Matrix — Slice 1

### Strategist

**Подтверждено сейчас:**
- WP Gate и opening/closing coordination;
- morning / week-review / note-review operational path;
- работа с WeekPlan, SESSION-CONTEXT и INBOX как с координационным слоем;
- постановка приоритетов и удержание порядка работ в ритуальном контуре.

**Пока не доказано:**
- самостоятельный структурный разбор хаоса репозиториев;
- recovery потерянных входов в единый каталог;
- автономная каталогизация knowledge-layer по точкам и Pack'ам.

**Truthful verdict:** `partial`

### Extractor

**Подтверждено сейчас:**
- inbox-check и extraction-report контур;
- routing доменных и implementation inputs;
- фиксация extraction follow-ups в DS/Pack контуре.

**Пока не доказано:**
- стабильный end-to-end recovery потерянных пользовательских входов в единый каталог;
- надёжное возвращение этих элементов в active WP pipeline без ручной доработки.

**Truthful verdict:** `partial`

### Environment Engineer

**Подтверждено сейчас:**
- диагностика и ремонт operational среды;
- правка скриптов, launchd/scheduler/close-flow;
- truthful hardening отчётности и runtime contract;
- реальный post-check после инженерных изменений.

**Пока не доказано:**
- системная карта зрелости остальных агентов как повторяемый сервис;
- регулярный acceptance-cycle по всем агентам.

**Truthful verdict:** `ready` для среды, `partial` для meta-verification слоя.

### Synchronizer / Scheduler

**Подтверждено сейчас:**
- dispatch, health-check, daily-report, Telegram delivery;
- truthful runtime/status refresh;
- восстановление дневных и day-close отчётов.

**Пока не доказано:**
- стабильное использование как единого acceptance-harness для capability-testing всех агентов.

**Truthful verdict:** `ready` как operational dispatcher, `partial` как verification harness.

## Документы, где уже есть drift между intent и reality

- [strategist.md](/Users/alexander/Github/DS-agent-workspace/agency/agents/strategist.md)
- [environment-engineer.md](/Users/alexander/Github/DS-agent-workspace/agency/agents/environment-engineer.md)
- [roles/strategist/README.md](/Users/alexander/Github/FMT-exocortex-template/roles/strategist/README.md)
- [roles/extractor/README.md](/Users/alexander/Github/FMT-exocortex-template/roles/extractor/README.md)

## Slice 1 — что делаем сейчас

1. Зафиксировать truthful matrix по ролям.
2. Убрать самые явные завышения из agent docs.
3. Подготовить verification scenarios для `Strategist` и `Extractor`.

## Следующий slice

Следующим ходом нужно:
- скорректировать role/docs под truthful semantics;
- собрать test matrix `scenario -> expected artifact -> failure mode -> pass/fail`;
- начать с `Strategist`, потому что именно по нему пользователь первым заметил расхождение между замыслом и практикой.
