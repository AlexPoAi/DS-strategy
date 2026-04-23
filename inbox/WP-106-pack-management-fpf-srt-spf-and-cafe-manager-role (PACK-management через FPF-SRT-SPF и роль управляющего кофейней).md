---
type: work-plan
wp_id: 106
title: PACK-management через FPF-SRT-SPF и роль управляющего кофейней
created: 2026-04-23
status: done
owner: Environment Engineer
support:
  - FPF Консультант
  - Strategist
domain: vk-coffee
mode: domain-architecture
---

# WP-106 — PACK-management через FPF -> SRT -> SPF

## Зачем открыт

Нужно truthfully различить `PACK-management`, прежде чем добавлять туда роль
`управляющего кофейней` и переносить в этот контур factual events вида:

- ремонт;
- readiness помещения;
- переезд;
- запуск новой зоны;
- крупная управленческая закупка оборудования.

## Граница slice

### В scope

- `PACK-management`
- role-card `управляющего кофейней`
- один formalized `FPF -> SRT -> SPF pass`

### Не в scope

- Park-contour
- warehouse-contour
- runtime-артефакты
- перенос реальных factual updates дня про ремонт и barista class

## Truthful result

- `PACK-management` подтверждён как primary management domain
- management-domain расширен до `cafe management / readiness / change coordination`
- materialized роль `управляющего кофейней`
- зафиксировано, что repair/readiness/relocation/launch идут сюда как primary source

## Следующий bounded шаг

Отдельным WP занести сегодняшние factual updates:

- ремонт кухни;
- машина для `barista class`;

уже в новый management-contour как primary layer.
