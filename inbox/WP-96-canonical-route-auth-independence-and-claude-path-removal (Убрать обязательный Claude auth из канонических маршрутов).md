---
type: wp-context
wp: 96
title: Убрать обязательный Claude auth из канонических маршрутов
status: in_progress
priority: critical
owner: engineer
created: 2026-04-20
---

# WP-96 — Убрать обязательный Claude auth из канонических маршрутов

## Контекст

После вчерашнего инцидента подтвердился повторяющийся системный симптом:
`Not logged in · Please run /login (Claude path)`.

Проблема уже не про один сценарий `week-review`, а про сам canonical route layer:
- отдельные ритуалы и маршруты всё ещё могут заходить в обязательный `Claude path`;
- из-за этого любой агент может честно идти по правильному протоколу, но упираться в auth-blocker;
- пользовательский контракт нарушается: ритуал вроде существует, но не является guaranteed-working.

## Ритуал и метод работы

1. Сначала сверка с Цереном / upstream и живой реализацией.
2. Затем сверка с нашим эталоном: canonical route должен быть provider-agnostic, а не Claude-bound.
3. Потом оценка риска: что безопасно переключать на Codex сразу, а что нельзя ломать.
4. Только после этого кодовые правки и post-check.

## Что нужно сделать

1. Найти все живые canonical routes, где `Claude auth` всё ещё остаётся обязательным входом.
2. Убедиться, что `open / work / close / report` truthfully работают через `Codex`, если он доступен.
3. Убрать обязательность `claude /login` из тех маршрутов, где это противоречит уже зафиксированному контракту.
4. Прогнать post-check по агентам и ритуалам.
5. Зафиксировать anti-regression note в инженерном pack.

## Нанятые агенты

- `Archimedes` — sidecar-аудит на поиск оставшихся `Claude-first` route-хвостов.

## Целевой результат

- любой агент может пройти канонический ритуал без ручного `claude /login`, если `Codex` доступен;
- `Claude` остаётся только fallback / optional provider path;
- инженерный контур перестаёт зависеть от disabled / expired Anthropic auth.

## Slice 1 — Диагностика и первый safe fix

### Что подтвердилось

- В `day-close` больше не найден живой обязательный `Claude-first` route.
- Реальный хвост остался в `strategist week-review` как legacy/debug override:
  `STRATEGIST_WEEK_REVIEW_FORCE_CLAUDE=1`.
- В документации оставался устаревший тезис, что весь агентный контур требует `claude /login`.

### Что исправлено

1. Legacy override `week-review -> Claude` больше не может включиться случайно:
   теперь он требует сразу два флага:
   - `STRATEGIST_WEEK_REVIEW_FORCE_CLAUDE=1`
   - `STRATEGIST_ALLOW_LEGACY_CLAUDE_OVERRIDE=1`
2. `DS-strategy/docs/ARCHITECTURE.md` выровнен под фактический контракт:
   `Codex-primary / Claude-fallback`.
3. Комментарий в `FMT-exocortex-template/scripts/day-close.sh` выровнен:
   это provider-agnostic route, а не `Claude-only`.

### Проверка

- `bash -n roles/strategist/scripts/strategist.sh` — OK
- `bash -n scripts/day-close.sh` — OK
