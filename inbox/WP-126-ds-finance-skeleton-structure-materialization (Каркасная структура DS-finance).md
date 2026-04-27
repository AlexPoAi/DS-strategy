---
type: work-plan
wp_id: 126
title: Каркасная структура DS-finance
created: 2026-04-27
status: done
owner: Strategist
support:
  - Environment Engineer
domain: finance
mode: domain-structure
---

# WP-126 — Каркасная структура DS-finance

## Зачем открыт

После различения `DS-finance` как отдельного домена нужно materialize не только
архитектурную идею, но и реальную файловую структуру, в которую смогут
встраиваться `Pack`, агенты и будущие `Finance View`.

## Цель slice

Создать минимальный, но канонический skeleton `DS-finance` внутри `DS-strategy`.

## Что materialized

1. Корневой манифест домена `DS-finance`
2. Первый концепт домена: `финансы системы создания`
3. Четыре стартовых `Pack`:
   - `PACK-finance-views`
   - `PACK-cash-discipline`
   - `PACK-project-funding`
   - `PACK-finance-agents`

## Truthful scope

В этот slice входит:

- только структура домена;
- naming;
- границы внутренних `Pack`.

В этот slice не входит:

- наполнение `Finance View`;
- методы и сущности каждого pack;
- новый repo под `DS-finance`;
- runtime и automation.

## Следующий честный шаг

Открыть следующий bounded slice на первые operational артефакты:

1. `Finance View — VK Coffee`
2. `Finance View — Park`
3. первый `cash-discipline verdict`
