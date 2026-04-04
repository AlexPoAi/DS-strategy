---
type: engineering-work-product
wp_id: ENG.WP.010
title: Устранение дрейфа entrypoint для day-close у Strategist
date: 2026-04-05
status: active
priority: high
linked_inbox: ENGINEERING
author: Environment Engineer (Codex)
---

# ENG.WP.010 — Устранение дрейфа entrypoint для day-close у Strategist

## Контекст

После миграции `day-close` из старого prompt-файла в протокол [protocol-close.md](/Users/alexander/Github/FMT-exocortex-template/memory/protocol-close.md) shell-entrypoint стратега остался привязан к несуществующему пути `roles/strategist/prompts/day-close.md`.

Из-за этого:

- сам протокол закрытия дня в экосистеме уже существует и используется;
- но ручной запуск `strategist.sh day-close` падает на lookup prompt-файла;
- возникает расхождение между source-of-truth протокола и реальным runner entrypoint.

## Симптом

- `bash /Users/alexander/Github/FMT-exocortex-template/roles/strategist/scripts/strategist.sh day-close`
- ошибка: `ERROR: Command file not found: .../roles/strategist/prompts/day-close.md`

## Цель

Выровнять `day-close` entrypoint стратега с текущим source-of-truth:

- `day-close` должен читать [protocol-close.md](/Users/alexander/Github/FMT-exocortex-template/memory/protocol-close.md)
- остальные сценарии не должны регрессировать

## Границы изменения

В scope:

- [strategist.sh](/Users/alexander/Github/FMT-exocortex-template/roles/strategist/scripts/strategist.sh)

Вне scope:

- полная переработка `day-plan`
- изменение логики `scripts/day-close.sh`
- изменение Week Close / Quick Close

## План ремонта

1. Добавить special-case для `day-close` в runner стратега.
2. Сохранить существующую модель запуска для остальных сценариев.
3. Проверить shell-синтаксис.
4. Повторно запустить `day-close` и проверить, проходит ли lookup протокола.

## Критерий готовности

- `strategist.sh day-close` больше не ищет `prompts/day-close.md`
- runner читает `memory/protocol-close.md`
- сценарий стартует без ошибки lookup

## Фактический результат на 2026-04-05

- drfit entrypoint устранён: `day-close` теперь читает [protocol-close.md](/Users/alexander/Github/FMT-exocortex-template/memory/protocol-close.md)
- в runner также устранён отдельный runtime-блокер: `CLAUDE_PATH` больше не зависит от template-placeholder и корректно ищется через `$HOME/.local/bin/claude` с fallback на `command -v claude`
- повторный запуск `strategist.sh day-close` проходит через runner и реально стартует Claude

Truthful status:

- **runner repaired** — да
- **manual protocol entry works** — да
- **fully autonomous day-close flow** — ещё нет

Во время повторного прогона Claude корректно загрузил протокол, увидел незакоммиченные изменения и остановился на интерактивной точке принятия решения. Значит основной дефект entrypoint снят, но следующий слой работы — это уже не path drift, а донастройка режима исполнения `day-close` как протокола.

## Остаточный риск

- возможен следующий дефект уже внутри самого day-close протокола или downstream-скриптов;
- но дрейф entrypoint как отдельная поломка должен быть снят.
- `day-close` пока нельзя считать полностью автономным shell-ритуалом; он остаётся protocol-driven и может требовать следующего шага/подтверждения внутри Claude.
