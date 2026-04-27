---
type: architecture-decision
id: FIN.DECISION.007
domain: DS-finance
title: Business-finance v0.7
status: accepted
date: 2026-04-27
source_wp: 120
---

# FIN.DECISION.007 — Business-finance v0.7

## Решение

Первый детализируемый контур — `business-finance`.

## Назначение

Управление операционными деньгами бизнеса.

## Цель

- генерация cash;
- контроль эффективности использования ресурсов.

## Data layer

- `incomes` (выручка от операционной деятельности);
- `expenses` (расходы: `fixed`, `variable`, `one_time`);
- `cash` (деньги бизнеса: кассы, счета);
- `assets` (оборудование, товар, инфраструктура);
- `liabilities` (кредиты, кредиторка, обязательства).

## Transformation layer

- `cashflow = cash_inflows - cash_outflows`;
- `cash_balance = previous_cash + cashflow`;
- `profit = incomes - expenses`;
- `unit_economics = revenue - variable_expenses`;
- `asset_efficiency = profit / assets_value`;
- динамика: день / неделя / месяц.

## Ограничения

- не смешивать с `personal-finance`;
- не учитывать инвестиции внутри операционного бизнеса;
- каждый актив должен иметь функцию;
- каждая трата должна иметь категорию.
