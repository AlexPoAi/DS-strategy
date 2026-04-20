---
type: work-product
id: ENG.WP.041
title: Восстановление strategist week-review через Codex primary
status: done
date: 2026-04-20
---

# ENG.WP.041 — Восстановление strategist week-review через Codex primary

## Что сломалось

`strategist-week-review` регулярно падал по auth в Claude:
`Not logged in · Please run /login`.

## Root cause

1. Week-review принудительно уводился в Claude path override.
2. Сообщение `Not logged in · Please run /login` не классифицировалось как auth-failure.

## Исправление

- Файл: `FMT-exocortex-template/roles/strategist/scripts/strategist.sh`
- Правки:
  - Week-review override включается только через явный флаг `STRATEGIST_WEEK_REVIEW_FORCE_CLAUDE=1`.
  - Auth pattern расширен на `Not logged in .*Please run /login`.

## Верификация

1. `bash .../strategist.sh week-review` → success через Codex.
2. `bash .../health-check.sh` → `✅ Среда исправна`, `strategist-week-review status=success`.

## Связанный коммит

- `FMT-exocortex-template`: `eb7900c`

