---
type: work-plan
wp_id: 108
title: Инженерные ветки предметных областей и context для management
created: 2026-04-23
status: done
owner: Environment Engineer
support:
  - Strategist
domain: exocortex-engineering
mode: engineering-registry
---

# WP-108 — Инженерные ветки предметных областей и context для management

## Зачем открыт

Нужно завести второй слой поверх предметных доменов:

- не source-of-truth самих доменов;
- а инженерную карту того, какие работы проходили по каким предметным областям.

Для этого materialized:

1. общий реестр инженерных веток предметных областей;
2. первый context-файл по ветке `management`.

## Что materialized

- `ENG.WP.045`
- `ENGINEERING.DOMAIN.REGISTRY.md`
- `engineering-branches/management/ENGINEERING-CONTEXT.md`

## Truthful verdict

Slice закрыт как seed-layer.

Следующий честный шаг:

- по этому же шаблону можно добавлять ветки `park-development`, `warehouse`,
  `obsidian-human-layer` и другие домены.
