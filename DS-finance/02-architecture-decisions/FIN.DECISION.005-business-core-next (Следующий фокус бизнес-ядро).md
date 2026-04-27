---
type: architecture-decision
id: FIN.DECISION.005
domain: DS-finance
title: Следующий фокус бизнес-ядро
status: accepted
date: 2026-04-27
source_wp: 120
---

# FIN.DECISION.005 — Следующий фокус: business-finance core

## Решение

Следующий рабочий фокус — добить `business-finance core`.

`Personal-finance` не разворачивать первым.

## Почему

Бизнес является источником cash и питает основные инициативы:

- кофейни;
- Парк;
- ремонты;
- улучшения;
- часть личных контуров через вывод денег.

Если бизнес-ядро будет мутным, личный контур тоже начнёт искажать аналитику.

## Что входит в business-finance core

- `cash` (фактические деньги бизнеса);
- `cashflow` (движение денег бизнеса);
- `required_expenses` (обязательные расходы бизнеса);
- `assets` (активы бизнеса);
- `liabilities` (обязательства бизнеса);
- `transfer_out` и `transfer_in` (явные трансферы).
