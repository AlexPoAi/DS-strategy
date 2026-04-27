---
type: finance-view
id: FIN.VIEW.005
domain: DS-finance
contour: business-finance
title: Структура денег бизнеса
status: draft
version: 1.0
created: 2026-04-27
source_wp: 120
---

# FIN.VIEW.005 — Business cash structure

## Назначение

Структура хранения и движения реальных денег бизнеса.

## Тип системы

`state + storage points` (состояние + точки хранения).

## Operating cash (операционные деньги)

### Cash registers (кассы точек)

- `samokisha` (Самокиша);
- `turgeneva` (Тургенева);
- `lugovaya` (Луговая).

### Bank accounts (расчётные счета)

- `ip_accounts` (счета ИП);
- `llc_accounts` (счета ООО).

### Transit (деньги в пути)

Деньги в пути: эквайринг, переводы.

Transit должен обнуляться и не должен накапливаться как постоянная категория.

## Reserve cash (резерв)

Резерв / подушка. Не используется в операционке.

## Investment cash (инвестиционные деньги)

- `deposit_account` (депозитный счёт, генерирует проценты).

## Формула

`cash_total = operating_cash + reserve_cash + investment_cash`

## Связи

- `operating_cash -> expenses`;
- `operating_cash -> assets`;
- `operating_cash -> transfer_out`;
- `investment_cash -> cashflow` через проценты;
- `reserve_cash -> emergency_transfer`.

## Готовность

- система знает, где деньги;
- можно считать реальный баланс;
- готово к интеграции с `transformation-layer`.
