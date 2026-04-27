---
type: architecture-decision
id: FIN.DECISION.009
domain: DS-finance
title: Расходы бизнеса v0.9
status: accepted
date: 2026-04-27
source_wp: 120
---

# FIN.DECISION.009 — Business-finance / expenses v0.9

## Решение

Структура расходов бизнеса зафиксирована и готова к использованию в расчётах.

`Personal-finance` выделен отдельно и не участвует в бизнес-аналитике.

## Классификация

### Operating expenses (операционные расходы кофеен)

- `payroll_barista` (зарплаты сотрудников кофеен);
- `rent_locations` (аренда точек);
- `utilities` (коммунальные платежи);
- `fuel_procurement` (бензин: закупка и логистика);
- `kitchen_payroll` (зарплата поваров).

### Management expenses (управление)

- `operations_manager` (операционный менеджер);
- `accounting_services` (бухгалтерия).

### Legal / Tax (налоги и юридические платежи)

- `taxes_ip` (налоги по ИП);
- `taxes_llc` (налоги по ООО).

### Asset-related expenses (расходы, связанные с активами)

- `land_rent` (аренда участков ООО Terra);
- `loan_payments` (кредит за коммерческое здание).

### Strategic / Projects (стратегические проекты)

- `park_project` (проект Парк): аренда, бухгалтерия, прочие расходы.

### External obligations (внешние обязательства)

- `samir_payment` (фиксированная выплата 170000).

## Исключено из Business-finance

- домашняя аренда;
- коммунальные дома;
- репетиторы / занятия;
- расходы семьи;
- вторая машина.

## Ограничения

- не смешивать personal и business;
- каждый расход должен иметь категорию;
- фиксировать регулярность: ежемесячный / разовый.
