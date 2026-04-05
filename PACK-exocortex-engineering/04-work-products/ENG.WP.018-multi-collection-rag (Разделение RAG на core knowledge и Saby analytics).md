---
type: engineering-work-product
wp_id: ENG.WP.018
title: Разделение RAG на core knowledge и Saby analytics
date: 2026-04-05
status: active
priority: high
linked_inbox: ENGINEERING
author: Environment Engineer (Codex)
---

# ENG.WP.018 — Разделение RAG на core knowledge и Saby analytics

## Контекст

После `ENG.WP.017` подтверждено:

- индексация работает стабильно;
- в Chroma сейчас `579` документов;
- существенный объём индекса создают `knowledge-base/saby-reports/invoices`.

Удалять Saby-данные нельзя — они нужны. Проблема не в самих данных, а в том, что они смешаны с операционной базой знаний в одной коллекции.

## Цель

Разделить RAG на два knowledge-layer:

1. `core` — Pack, регламенты, operational knowledge
2. `saby` — invoices, sales и другие учётно-аналитические документы

И сохранить простой routing:

- обычные вопросы → `core`
- Saby/закупки/поставщики/накладные → `saby`

## Первый implementation slice

1. Разделить индексацию на две коллекции
2. Обновить query-layer под выбор нужной коллекции
3. Обновить `/health` и `/stats`, чтобы они показывали расклад по коллекциям
4. Не менять пока Telegram bot routing отдельно — оставить это внутри `VK-offee-rag`

## Truthful note

Этот WP не делает ещё:

- cross-collection merge ranking;
- multi-hop ответы с объединением `core + saby`;
- отдельные роли доступа к Saby;
- чистку старого единого индекса на сервере до повторной переиндексации.

## Реализованный slice

В [VK-offee-rag](/Users/alexander/Github/VK-offee-rag) уже подготовлен первый рабочий слой:

- [src/indexer.py](/Users/alexander/Github/VK-offee-rag/src/indexer.py)
  - индексация разделена на две коллекции:
    - `vkoffee_core_knowledge`
    - `vkoffee_saby_knowledge`
- [src/query.py](/Users/alexander/Github/VK-offee-rag/src/query.py)
  - обычные вопросы маршрутизируются в `core`
  - вопросы о закупках / накладных / поставщиках маршрутизируются в `saby`
- [src/api.py](/Users/alexander/Github/VK-offee-rag/src/api.py)
  - `/health` и `/stats` теперь умеют возвращать расклад по коллекциям

## Следующий шаг

Следующий practical step:

1. раскатить новый `VK-offee-rag` на VPS;
2. выполнить полный reindex в multi-collection режиме;
3. проверить `/health` и `/stats`;
4. сделать два smoke test запроса:
   - операционный / регламентный
   - финансовый / Saby
