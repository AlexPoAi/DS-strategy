---
type: engineering-work-product
wp_id: ENG.WP.023
title: Каскадный fallback моделей Haiku→Sonnet для агентного слоя
date: 2026-04-07
status: completed
priority: high
linked_inbox: R-2
author: Environment Engineer (Codex)
---

# ENG.WP.023 — Каскадный fallback моделей Haiku→Sonnet для агентного слоя

## Контекст

После W15 стало ясно:

- `Haiku` не всегда доступен на текущем ключе/маршруте;
- `Opus` operationally запрещён из-за cost/quota риска;
- runners должны не просто падать, а делать предсказуемый fallback на `Sonnet`.

## Цель

Сделать единый runtime contract:

- primary model: `claude-haiku-4-5`
- fallback model: `claude-sonnet-4-6`
- `Opus` запрещён на уровне runner logic

## Scope

- `FMT-exocortex-template/roles/strategist/scripts/strategist.sh`
- `FMT-exocortex-template/roles/extractor/scripts/extractor.sh`
- dispatch layer проверить на фактическую роль в model selection

## Truthful architectural note

Проверка показала:

- `scheduler.sh` сам модель не выбирает;
- он только вызывает `strategist.sh` и `extractor.sh`;
- значит реальный fallback должен жить в runner layer, а не в dispatch layer.

## Acceptance criteria

1. `strategist` и `extractor` сначала пытаются `Haiku`
2. При `model_unavailable`/equivalent model-path failure происходит автоматический fallback на `Sonnet`
3. `Opus` не может быть выбран через runtime env/model config без явного отказа
4. Логи фиксируют, какой model attempt был использован и случился ли fallback

## Выполненный slice

В текущем цикле уже реализовано:

- `strategist.sh`
  - добавлены `AI_CLI_PRIMARY_MODEL` и `AI_CLI_FALLBACK_MODEL`
  - default cascade: `claude-haiku-4-5` -> `claude-sonnet-4-6`
  - `Opus` блокируется через `sanitize_model()`
  - при `model_unavailable`-class ошибке runner делает автоматический fallback
  - логи фиксируют `model attempt` и `falling back`

- `extractor.sh`
  - та же каскадная модель и тот же запрет `Opus`
  - fallback применяется внутри `run_claude()`
  - success/failure логи теперь сохраняют использованную модель

## Проверка

- `bash -n` прошёл для `strategist.sh`
- `bash -n` прошёл для `extractor.sh`
- mock smoke test на runtime path подтвердил каскад:
  - попытка `claude-haiku-4-5`
  - детекция `model_unavailable`
  - автоматический fallback на `claude-sonnet-4-6`
  - успешное завершение на `Sonnet`

## Truthful status

Кодовая реализация сделана и базово верифицирована.
`scheduler.sh` осознанно не менялся, потому что не выбирает модель и не является owner этой логики.
Remaining риск: production runtime ещё стоит перепроверить на живом cron-цикле, но acceptance для инженерного slice выполнен.
