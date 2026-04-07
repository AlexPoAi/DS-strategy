---
type: engineering-work-product
wp_id: ENG.WP.026
title: Разделение RAG на core knowledge и Saby analytics
date: 2026-04-07
status: completed
priority: high
linked_inbox: R-3
author: Environment Engineer (Codex)
---

# ENG.WP.026 — Разделение RAG на core knowledge и Saby analytics

## Контекст

Operational Pack-knowledge и Saby-аналитика не должны жить как один неразличимый knowledge layer.

Если держать их в одной коллекции:

- retrieval смешивает operational knowledge и закупочную аналитику;
- обычные вопросы сотрудников могут получать нерелевантный закупочный контекст;
- `/health` и `/stats` не дают truthful picture по слоям знаний.

## Цель

Зафиксировать и довести до приёмки multi-collection контракт:

- `core` для operational knowledge
- `saby` для закупок / накладных / поставщиков / Saby reports

## Что подтверждено по коду

- `src/indexer.py`
  - индексирует `core` и `saby` как две отдельные коллекции
  - `knowledge-base/saby-reports/**` маршрутизируется в `saby`
- `src/query.py`
  - обычные вопросы идут в `core`
  - закупочные / поставщики / накладные / Saby / Presto идут в `saby`
- `src/api.py`
  - `/health` и `/stats` отдают counts по коллекциям

## Что добавлено в этом цикле

- в `src/query.py` добавлен явный `classify_query()` с truthful routing verdict:
  - `target_collection`
  - `reason`
- ответ `query()` теперь включает `routing`
- `/health` теперь явно показывает `routing_layers`
- `/stats` теперь явно показывает routing policy
- `README.md` обновлён под реальную multi-collection архитектуру
- добавлен тест `tests/test_routing.py`

## Проверка

- `./venv/bin/python -m unittest tests/test_routing.py` → `OK`
- smoke-check routing:
  - `Как приготовить капучино?` -> `core`
  - `Покажи накладную от поставщика` -> `saby`

## Truthful status

`R-3` можно считать выполненным:

- knowledge split физически есть
- query routing есть
- `/health` и `/stats` обновлены
- добавлена минимальная regression-проверка

Remaining next step уже другой: не разделение слоёв знаний, а улучшение качества routing heuristics и, при необходимости, гибридный cross-collection search.
