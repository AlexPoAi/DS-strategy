---
type: finance-view
id: FIN.VIEW.002
domain: DS-finance
contour: business-finance
title: Операционная модель финансов бизнеса
status: draft
version: 0.7
created: 2026-04-27
source_wp: 120
---

# FIN.VIEW.002 — Business-finance operating model

## Назначение

Описать `business-finance` как контур управления операционными деньгами бизнеса.

## Цель

- генерация cash;
- контроль эффективности использования ресурсов.

## Data layer

- `incomes` (выручка от операционной деятельности);
- `expenses` (расходы бизнеса);
- `cash` (деньги бизнеса);
- `assets` (активы бизнеса);
- `liabilities` (обязательства бизнеса).

## Transformation layer

- `cashflow` (денежный поток);
- `balance` (остаток денег);
- `profit` (прибыль);
- `unit_economics` (эффективность точки / продукта);
- `asset_efficiency` (эффективность активов);
- `dynamics` (день / неделя / месяц).

## Ограничения

- не смешивать с `personal-finance`;
- не учитывать инвестиции как операционный бизнес;
- каждая трата должна иметь категорию;
- каждый актив должен иметь функцию.
