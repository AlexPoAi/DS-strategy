---
type: finance-view
id: FIN.VIEW.004
domain: DS-finance
contour: business-finance
title: Структура расходов бизнеса
status: draft
version: 0.9
created: 2026-04-27
source_wp: 120
---

# FIN.VIEW.004 — Business expenses structure

## Назначение

Структура расходов операционного бизнеса.

## Operating expenses (операционные расходы кофеен)

- `payroll_barista` (зарплаты сотрудников кофеен);
- `rent_locations` (аренда точек: Самокиша, Тургенева, Луговая);
- `utilities` (коммунальные платежи);
- `fuel_procurement` (бензин: закупка и логистика);
- `kitchen_payroll` (зарплата поваров).

## Management expenses (управление)

- `operations_manager` (операционный менеджер);
- `accounting_services` (бухгалтерия).

## Legal / Tax (налоги и юридические платежи)

- `taxes_ip` (налоги по ИП);
- `taxes_llc` (налоги по ООО).

## Asset-related expenses (расходы, связанные с активами)

- `land_rent` (аренда участков ООО Terra);
- `loan_payments` (кредит за коммерческое здание).

## Strategic / Projects (стратегические проекты)

`park_project` (проект Парк):

- `rent` (аренда);
- `accounting` (бухгалтерия);
- `other_costs` (прочие расходы).

## External obligations (внешние обязательства)

- `samir_payment` (фиксированная выплата 170000).

## Исключено из Business-finance

Переносится в `personal-finance`:

- домашняя аренда;
- коммунальные дома;
- репетиторы / занятия;
- расходы семьи;
- вторая машина.

## Готовность

Структура расходов зафиксирована и готова к использованию в расчётах.
