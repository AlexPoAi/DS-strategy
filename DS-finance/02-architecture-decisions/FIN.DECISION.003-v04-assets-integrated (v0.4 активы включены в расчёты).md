---
type: architecture-decision
id: FIN.DECISION.003
domain: DS-finance
title: v0.4 активы включены в расчёты
status: accepted
date: 2026-04-27
source_wp: 120
---

# FIN.DECISION.003 — v0.4 assets integrated

## Решение

`v0.4` принимается как вычислительная база.

## Что добавлено

Активы включаются в слой преобразования:

- `assets_value = sum(assets)` (суммарная стоимость активов);
- `ROA = profit / assets_value` (эффективность активов);
- `asset_cash_conversion = cashflow / assets_value` (денежная отдача активов).

## Принцип

Актив должен быть:

- либо генерирующим cash;
- либо растущим в стоимости.

Актив без функции = замороженные деньги.
