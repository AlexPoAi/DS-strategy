---
type: architecture-decision
id: FIN.DECISION.008
domain: DS-finance
title: Доходы бизнеса v0.8
status: accepted
date: 2026-04-27
source_wp: 120
---

# FIN.DECISION.008 — Business-finance / incomes v0.8

## Решение

Доходы бизнеса разделяются на операционные и неоперационные.

## Operating income

`coffee_shops` (кофейни):

- `samokisha` (Самокиша);
- `turgeneva` (Тургенева);
- `lugovaya` (Луговая).

## Non-operating income

- `deposit_interest` (проценты по депозитному счёту).

## Принципы

- каждая точка = отдельный источник;
- все источники должны быть явно перечислены;
- доход = начисление, не обязательно деньги;
- операционные и пассивные доходы не смешиваются.

## Связь с cash

- `operating_income -> cash_inflows` через продажи;
- `deposit_interest -> cash_inflows`.
