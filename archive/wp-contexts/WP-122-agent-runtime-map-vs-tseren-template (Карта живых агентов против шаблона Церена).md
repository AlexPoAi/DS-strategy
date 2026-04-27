---
type: work-plan
wp_id: 122
title: Карта живых агентов против шаблона Церена
created: 2026-04-26
status: done
owner: Strategist + Environment Engineer
domain: exocortex-engineering
mode: runtime-audit
---

# WP-122 — Карта живых агентов против шаблона Церена

## Зачем открыт

У владельца возник правомерный вопрос:

- мы много раз переносили IWE/экзокортекс по шаблону Церена;
- в workspace видны папки `extractor`, `scheduler`, `scout`, `strategist`, `verifier`;
- но в реальной жизни пользователь видит в основном только `strategist` и `extractor`;
- непонятно, кто из этих контуров реально живой runtime, а кто только архив, исследовательский слой или заготовка.

Без этой карты легко:

- думать, что агент “есть”, хотя он не запущен;
- путать runtime-агентов с artifact-bus папками;
- неправильно диагностировать, почему система “не работает как у Церена”.

## Цель slice

Собрать factual карту:

1. как именно устроен живой шаблон Церена;
2. какие роли там считаются каноническими;
3. какие runtime-контуры реально живы у нас;
4. какие папки в `DS-agent-workspace` не являются живыми агентами;
5. где именно разошлись шаблон, локальная эксплуатация и пользовательское восприятие.

## Первичные факты уже подтверждены

### Канонический шаблон Церена

По `FMT-exocortex-template/roles/README.md` базовый живой контур минимален:

- `Strategist (R1)`
- `Extractor (R2)`
- `Synchronizer (R8)` / `scheduler`

То есть уже на уровне шаблона нет обещания,
что `Scout`, `Verifier` или другие исследовательские роли автоматически являются живыми launchd-агентами.

### Что реально живо у нас

По `launchctl` и status-слою:

- живы:
  - `com.exocortex.scheduler`
  - `com.extractor.inbox-check`
  - `com.extractor.session-watcher`
- `Strategist` живёт как сценарии внутри `scheduler`, а не как отдельный постоянно видимый сервис.

Подтверждение в `~/.local/state/exocortex/status/`:

- `strategist-morning.status` — success
- `strategist-note-review.status` — success
- `strategist-week-review.status` — success
- `extractor-inbox-check.status` — сейчас failed / stale
- `synchronizer-code-scan.status` — success
- `synchronizer-daily-report.status` — success

### Что не выглядит живым runtime

- `scout`:
  - отдельного launchd-сервиса нет;
  - в папке лежат `results`, `trajectory`, `backlog.yaml`;
  - это больше исследовательский / methodological contour, а не живой агент.
- `verifier`:
  - есть папка, но нет подтверждённого runtime.
- `sadler`:
  - не найден; вероятнее всего пользователь имел в виду `scheduler`.
- `warfire`:
  - не найден как реальный агентный контур.

## Главная гипотеза разрыва

Система у нас не выглядит "точно как у Церена" не потому, что шаблон не перенесли,
а потому что смешались три слоя:

1. канонический runtime шаблона Церена;
2. наши локальные расширения и artifact-папки;
3. пользовательское ожидание, что любая папка в `DS-agent-workspace` = живой агент.

## Root cause, который удалось подтвердить

Отдельно найден реальный инженерный разрыв в live core:

- `Strategist` умеет переживать падение Claude auth за счёт fallback на `Codex`;
- `Extractor` тоже должен это уметь, но его `resolve_codex_path()` был слабее;
- в реальном runtime `Extractor` падал на `401 Invalid bearer token` и не переходил на Codex;
- из-за этого создавалось ощущение, что "у Церена работает, а у нас нет", хотя минимальный template-контур у нас был почти тем же.

Подтверждение:

- `extractor-inbox-check.status` показывал свежий fail;
- лог `~/logs/extractor/2026-04-26.log` содержал `authentication_error` и отсутствие успешного Codex fallback;
- `strategist` в то же время уже имел рабочий fallback-контур.

## Что материализовано этим slice

1. Truth-карта live core против artifact/research слоёв собрана.
2. В `DS-agent-workspace/CLAUDE.md` добавлено явное различение:
   - live runtime core;
   - research/trajectory;
   - placeholder роли.
3. В `FMT-exocortex-template` выровнен `resolve_codex_path()`:
   - `extractor`
   - `strategist`
   - `runtime-arbiter`
4. Теперь live core ищет `codex` не только через `PATH`, но и через:
   - `/Applications/Codex.app/...`
   - `/usr/local/bin/codex`
   - `/opt/homebrew/bin/codex`
   - `$HOME/.local/bin/codex`
   - актуальный binary внутри `~/.vscode/extensions/.../codex`

## Acceptance

1. Есть явный список: `живые runtime`, `artifact-bus`, `research/trajectory`, `legacy`.
2. Понятно, куда смотрим для truth:
   - `launchctl`
   - `~/.local/state/exocortex/status/*`
   - `current/AGENTS-STATUS.md`
3. Понятно, какие контуры реально broken сейчас.
4. Есть следующий bounded шаг: либо cleanup путаницы, либо починка конкретного runtime.

## Следующий честный шаг

1. Прогнать post-fix проверку `extractor` и подтвердить, что fallback теперь реально активируется.
2. После подтверждения решить cleanup второго слоя:
   - что переименовать;
   - что оставить как research layer;
   - что удалить как truly dead.
