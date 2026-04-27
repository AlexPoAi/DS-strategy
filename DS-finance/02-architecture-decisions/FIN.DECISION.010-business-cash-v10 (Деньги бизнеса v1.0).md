---
type: architecture-decision
id: FIN.DECISION.010
domain: DS-finance
title: Деньги бизнеса v1.0
status: accepted
date: 2026-04-27
source_wp: 120
---

# FIN.DECISION.010 — Business-finance / cash v1.0

## Решение

Cash бизнеса описывается как `state + storage points`: состояние и точки
хранения реальных денег.

## Структура cash

### Operating cash (операционные деньги)

- `cash_registers` (кассы точек):
  - `samokisha`;
  - `turgeneva`;
  - `lugovaya`.
- `bank_accounts` (расчётные счета):
  - `ip_accounts`;
  - `llc_accounts`.
- `transit` (деньги в пути: эквайринг, переводы).

### Reserve cash (резерв)

Резерв / подушка, не используется в операционке.

### Investment cash (инвестиционные деньги)

- `deposit_account` (депозитный счёт, генерирует проценты).

## Формула

`cash_total = operating_cash + reserve_cash + investment_cash`

## Статус

- структура хранения денег определена;
- типы денег разделены;
- связи зафиксированы;
- система знает, где деньги;
- можно считать реальный баланс;
- готово к интеграции с `transformation-layer`.

## Ограничения

- запрещено хранить деньги без категории;
- запрещено смешивать резерв и операционные деньги;
- транзит должен обнуляться;
- каждый счёт должен быть идентифицирован.
