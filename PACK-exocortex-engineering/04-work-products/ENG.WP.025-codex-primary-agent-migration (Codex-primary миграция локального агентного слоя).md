---
type: engineering-work-product
wp_id: ENG.WP.025
title: Codex-primary миграция локального агентного слоя
date: 2026-04-07
status: completed
priority: high
linked_inbox: ENG-codex-primary
author: Environment Engineer (Codex)
---

# ENG.WP.025 — Codex-primary миграция локального агентного слоя

## Контекст

После `ENG.WP.024` в системе уже был provider fallback `Claude -> Codex`, но основной путь всё ещё оставался Claude-first.

Это оставляло два ограничения:

- operational path всё ещё по умолчанию шёл через Anthropic;
- `Codex` был только страховкой, а не основным стабильным provider'ом.

## Цель

Перевести локальные file-based агенты на режим:

- `Codex` как primary provider
- `Claude` как fallback provider

без изменения их runtime-класса (`local-primary` остаётся local-primary).

## Scope

- `FMT-exocortex-template/roles/strategist/scripts/strategist.sh`
- `FMT-exocortex-template/roles/extractor/scripts/extractor.sh`
- базовая архитектурная и onboarding-документация

## Что сделано

- в оба runner'а добавлен `AI_CLI_PROVIDER_PRIMARY`
- дефолтное значение переведено на `codex`
- при доступном `Codex` runner сначала использует `codex exec`
- если `Codex` primary path падает, runner truthfully пытается `Claude`
- если `Claude` дальше тоже недоступен, сохраняется уже внедрённый слой деградации и result semantics

## Документация

- в `ENG.WP.015` добавлено уточнение: provider migration в `Codex` не отменяет runtime truth о том, что `Strategist` / `Extractor` остаются `local-primary`
- в `LEARNING-PATH.md` исполнители `Стратег` и `Экстрактор` отражены как `AI CLI (Codex primary, Claude fallback)`
- в `README.md` и `SETUP-GUIDE.md` ослаблена Anthropic-centric формулировка: `Codex` теперь указан как нормальный и рекомендуемый путь для локального агентного слоя
- legacy entrypoint `claude-run.sh` переведён в wrapper, а канонический extractor entrypoint теперь `ai-run.sh`
- `ECOSYSTEM.md` и `setup.sh` обновлены под AI-CLI-first wording вместо Claude-only wording
- выполнен focused doc cleanup в high-signal документах:
  - `README.md`
  - `docs/IWE-HELP.md`
  - `docs/LEARNING-PATH.md`
  - `docs/onboarding/onboarding-guide.md`
  чтобы onboarding и quick-help больше не обещали Claude-only режим там, где система уже работает как `Codex-primary / Claude-fallback`
- дополнительно выровнен installer/quickstart слой:
  - `setup.sh` теперь внутренне использует нейтральный `AI_CLI_PATH`, сохраняя совместимость с существующим `{{CLAUDE_PATH}}` placeholder
  - `README.md` quickstart теперь предлагает `codex` или `claude`, а не только Claude-only вход

## Проверка

- `bash -n` прошёл для обоих runner'ов
- mock smoke test подтвердил `Codex-primary` путь для `Strategist`
- ранее подтверждённые smoke tests `Claude -> Codex` fallback остаются валидны
- `ai-run.sh` проходит `bash -n`
- legacy wrapper `claude-run.sh` успешно резолвится в `ai-run.sh`
- high-signal docs приведены к AI-CLI-first формулировкам без потери Claude fallback semantics
- `setup.sh` проходит `bash -n` после neutral naming cleanup

## Truthful status

Локальный агентный слой переведён в режим `Codex-primary / Claude-fallback`.
Это повышает provider stability, но не решает само по себе вопрос always-on runtime: `Strategist` и `Extractor` всё ещё являются `local-primary`, а не cloud-native агентами.
