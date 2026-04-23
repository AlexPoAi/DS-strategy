---
type: work-product
pack: PACK-exocortex-engineering
id: ENG.WP.045
title: Реестр инженерных веток предметных областей
created: 2026-04-23
status: active
---

# ENG.WP.045 — Реестр инженерных веток предметных областей

## Задача

Создать в инженерном слое отдельную карту предметных веток, чтобы было видно:

- по каким доменам уже проходили инженерные работы;
- где лежит engineering-context по каждой области;
- какие WP materialized вокруг этой области.

## Что создано

- `PACK-exocortex-engineering/ENGINEERING.DOMAIN.REGISTRY.md`
- `PACK-exocortex-engineering/engineering-branches/management/ENGINEERING-CONTEXT.md`

## Принцип

Предметный домен остаётся primary source-of-truth.

Инженерный слой хранит:

- карту инженерных вмешательств;
- registry веток;
- context по истории инженерных работ вокруг каждой предметной области.

## Первый materialized branch

- `management`

Для него зафиксировано:

- различение домена через `FPF -> SRT -> SPF`;
- materialization роли `управляющего кофейней`;
- creation навигационного слоя `CONTEXT + DOCUMENT-REGISTRY`.
