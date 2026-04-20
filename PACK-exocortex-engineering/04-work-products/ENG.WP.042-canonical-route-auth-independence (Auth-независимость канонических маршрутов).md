---
type: work-product
id: ENG.WP.042
title: Auth-независимость канонических маршрутов
status: in_progress
date: 2026-04-20
---

# ENG.WP.042 — Auth-независимость канонических маршрутов

## Что сломалось

Повторяется системный блокер:
`Not logged in · Please run /login (Claude path)`.

Это означает, что часть canonical routes всё ещё не соответствует уже принятому контракту `Codex-primary / provider-agnostic`.

## Почему это критично

- ломаются ритуалы `open / close / review`, даже если кодовая логика сама по себе корректна;
- агент может честно идти по каноническому маршруту, но не завершать его из-за auth внешнего provider-а;
- пользователь вынужден вручную повторять ритуал или напоминать про process discipline.

## Рабочая гипотеза

После починки `week-review` остались другие route-хвосты, где:
1. `Claude path` всё ещё вызывается как обязательный entrypoint;
2. `Codex` не используется как guaranteed-working primary path;
3. документы уже обещают одно, а runtime-route ведёт себя иначе.

## План ремонта

1. Найти все остаточные `Claude-first` canonical routes.
2. Сверить их с эталоном, уже зафиксированным в `protocol-open.md / protocol-close.md / CLAUDE.md`.
3. Перевести маршруты на truthful `Codex-primary`, сохранив `Claude` только как fallback.
4. Прогнать post-check по ключевым агентам и ритуалам.

## Связанные контексты

- `DS-strategy/inbox/WP-96-canonical-route-auth-independence-and-claude-path-removal (Убрать обязательный Claude auth из канонических маршрутов).md`
- `ENG.WP.041` — локальная починка `week-review`
- `ENG.WP.010` / `ENG.WP.013` / `ENG.WP.021` — история route-layer и ritual-layer
