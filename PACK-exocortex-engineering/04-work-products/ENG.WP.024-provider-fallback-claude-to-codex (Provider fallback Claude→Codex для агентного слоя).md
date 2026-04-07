---
type: engineering-work-product
wp_id: ENG.WP.024
title: Provider fallback Claude→Codex для агентного слоя
date: 2026-04-07
status: completed
priority: high
linked_inbox: ENG-provider-fallback
author: Environment Engineer (Codex)
---

# ENG.WP.024 — Provider fallback Claude→Codex для агентного слоя

## Контекст

После внедрения model cascade `Haiku -> Sonnet` остался следующий системный риск:

- оба runner'а всё ещё зависели от одного vendor-path (`claude`);
- при auth/preflight/model outage на стороне Anthropic агентный слой мог снова деградировать в hard fail;
- в локальной среде уже доступен рабочий `codex` CLI с успешным login status.

## Цель

Добавить второй слой деградации:

- сначала `Claude` как основной provider
- внутри него model cascade `Haiku -> Sonnet`
- при vendor-path failure -> fallback на `Codex`

## Scope

- `FMT-exocortex-template/roles/strategist/scripts/strategist.sh`
- `FMT-exocortex-template/roles/extractor/scripts/extractor.sh`

## Что реализовано

- добавлен provider fallback `Claude -> Codex`
- добавлены runtime-параметры:
  - `AI_CLI_PROVIDER_FALLBACK=codex`
  - `CODEX_MODEL=gpt-5.4`
  - `CODEX_PATH` как overrideable CLI path
- `strategist.sh` теперь уходит в `Codex`, если:
  - `Claude CLI` отсутствует
  - `Claude auth` падает
  - исчерпаны модели `Haiku -> Sonnet`, и provider-path всё равно недоступен
- `extractor.sh` теперь уходит в `Codex`, если:
  - `Claude CLI` отсутствует
  - `Claude preflight` не проходит
  - `Claude auth` падает
  - исчерпаны модели `Haiku -> Sonnet`, и provider-path всё равно недоступен
- в логах теперь фиксируется не только модель, но и provider:
  - `provider=codex`

## Проверка

- `bash -n` прошёл для `strategist.sh`
- `bash -n` прошёл для `extractor.sh`
- mock smoke test `Strategist`:
  - `Claude auth failed`
  - автоматический fallback на `Codex`
  - `Scenario result ... provider=codex`
- mock smoke test `Extractor`:
  - `Claude preflight failed`
  - автоматический fallback на `Codex`
  - `Process result ... provider=codex`

## Truthful status

Slice завершён и верифицирован на mock runtime.
Remaining caveat: production acceptance ещё полезно подтвердить на одном реальном scheduled запуске, но теперь агентный слой уже не завязан только на Anthropic-path.
