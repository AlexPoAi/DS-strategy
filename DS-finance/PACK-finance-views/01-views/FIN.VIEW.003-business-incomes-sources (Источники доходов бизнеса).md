---
type: finance-view
id: FIN.VIEW.003
domain: DS-finance
contour: business-finance
title: Источники доходов бизнеса
status: draft
version: 0.8
created: 2026-04-27
source_wp: 120
---

# FIN.VIEW.003 — Business incomes sources

## Назначение

Структура источников поступления денег в бизнес.

## Operating income (операционные доходы)

### Coffee shops (кофейни)

- `samokisha` (Самокиша);
- `turgeneva` (Тургенева);
- `lugovaya` (Луговая).

Операционный доход кофеен связан с продажами и должен раскладываться по
точкам, каналам и продуктам.

## Non-operating income (неоперационные доходы)

- `deposit_interest` (проценты по депозитному счёту).

## Связь с cash

- `operating_income -> cash_inflows`;
- `deposit_interest -> cash_inflows`.

## Ограничения

- не объединять точки в один поток;
- не смешивать операционные и пассивные доходы;
- каждый источник должен быть идентифицируем;
- доход = начисление, не обязательно фактические деньги.
