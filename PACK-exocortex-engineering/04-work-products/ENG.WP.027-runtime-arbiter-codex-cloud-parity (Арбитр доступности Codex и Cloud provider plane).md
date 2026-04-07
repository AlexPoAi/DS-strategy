---
type: engineering-work-product
wp_id: ENG.WP.027
title: Арбитр доступности Codex и Cloud provider plane
date: 2026-04-07
status: completed
priority: high
linked_inbox: ENG-runtime-arbiter
author: Environment Engineer (Codex)
---

# ENG.WP.027 — Арбитр доступности Codex и Cloud provider plane

## Контекст

После `ENG.WP.024` и `ENG.WP.025` локальный агентный слой уже умел:

- делать provider fallback `Claude -> Codex`;
- жить в режиме `Codex-primary / Claude-fallback`.

Но это всё ещё оставляло semantic drift:

- primary provider был operational default'ом, а не truthful runtime verdict'ом;
- `health-check` по-прежнему считал Anthropic helper главным auth-сигналом;
- opening-state не показывал, какой provider реально доступен сейчас;
- система не умела честно выбирать “того провайдера, у которого подписка и доступ сейчас живы”.

## Цель

Ввести единый runtime-arbiter слой, который:

- читает policy из source-of-truth файла;
- определяет доступность `Codex` и `Claude`;
- выбирает primary provider автоматически;
- публикует runtime-mode артефакт для health/opening/reporting слоя.

## Scope

- `FMT-exocortex-template/roles/synchronizer/scripts/runtime-arbiter.sh`
- `FMT-exocortex-template/roles/strategist/scripts/strategist.sh`
- `FMT-exocortex-template/roles/extractor/scripts/extractor.sh`
- `FMT-exocortex-template/roles/synchronizer/scripts/health-check.sh`
- `FMT-exocortex-template/roles/synchronizer/scripts/daily-report.sh`
- `DS-strategy/current/RUNTIME-POLICY.env`

## Что сделано

- добавлен `runtime-arbiter.sh` как единая точка truth для provider/runtime plane;
- введён `RUNTIME-POLICY.env`:
  - `AI_PROVIDER_POLICY=auto`
  - `AI_PROVIDER_PREFERENCE=codex`
  - `AI_RUNTIME_POLICY=split`
  - `CLOUD_TAKEOVER_SCOPE=product-only`
  - `CLOUD_BOT_RUNTIME_DECLARED=declared`
- `strategist.sh` и `extractor.sh` переведены на `AI_CLI_PROVIDER_PRIMARY=auto`;
- при `auto` runner теперь берёт primary provider из runtime arbiter, а не из hardcoded default;
- `health-check.sh` перестал считать Anthropic helper единственным критерием здоровья provider-plane;
- `daily-report.sh`, `AGENTS-STATUS.md` и экран открытия сессии теперь показывают:
  - primary provider;
  - статус `Codex`;
  - статус `Claude`;
  - runtime policy;
  - local/cloud runtime verdict.
- диагностические сообщения в `strategist.sh` и `extractor.sh` выровнены под provider parity:
  - auth/preflight ошибки больше не выглядят как Claude-only инцидент;
  - сообщения пользователю теперь указывают на `Claude-compatible` path и реальный re-login hint;
  - staging/session cleanup и runner comments приведены к AI-CLI wording вместо Claude-only wording.

## Проверка

- `bash -n` прошёл для:
  - `runtime-arbiter.sh`
  - `strategist.sh`
  - `extractor.sh`
  - `health-check.sh`
  - `daily-report.sh`
- прямой запуск `runtime-arbiter.sh` успешно создаёт:
  - `DS-strategy/current/RUNTIME-MODE.md`
  - `~/.local/state/exocortex/runtime-arbiter.env`
- `runtime-arbiter.sh --env` возвращает shell assignments для runner'ов
- `daily-report.sh --dry-run` отражает runtime mode секцию
- `bash -n` повторно пройден после diagnostic wording cleanup в `strategist.sh` и `extractor.sh`

## Truthful status

Локальный агентный слой больше не должен жить как “жёстко Codex-first” или “жёстко Claude-first”.

Теперь truthful semantics такие:

- provider selection = `auto`, если не запрошено иначе;
- primary provider выбирается по реальной доступности и policy;
- `Codex` и `Claude` рассматриваются как равноправные provider-path'ы;
- local agents всё ещё остаются `local-primary`;
- cloud/product runtime остаётся отдельной осью и не смешивается с provider-choice.
