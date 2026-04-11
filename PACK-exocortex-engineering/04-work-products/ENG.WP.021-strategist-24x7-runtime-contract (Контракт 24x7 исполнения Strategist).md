---
type: engineering-work-product
wp_id: ENG.WP.021
title: Контракт 24/7 исполнения Strategist
date: 2026-04-06
status: active
priority: critical
linked_inbox: ENGINEERING
author: Environment Engineer (Codex)
---

# ENG.WP.021 — Контракт 24/7 исполнения Strategist

## Контекст

После [ENG.WP.015-local-first-cloud-fallback-architecture (Local-first / cloud-fallback архитектура агентного слоя).md](/Users/alexander/Github/DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.015-local-first-cloud-fallback-architecture%20%28Local-first%20%2F%20cloud-fallback%20%D0%B0%D1%80%D1%85%D0%B8%D1%82%D0%B5%D0%BA%D1%82%D1%83%D1%80%D0%B0%20%D0%B0%D0%B3%D0%B5%D0%BD%D1%82%D0%BD%D0%BE%D0%B3%D0%BE%20%D1%81%D0%BB%D0%BE%D1%8F%29.md), [ENG.WP.019-strategist-reliability-history (История надёжности и сбоев Strategist).md](/Users/alexander/Github/DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.019-strategist-reliability-history%20%28%D0%98%D1%81%D1%82%D0%BE%D1%80%D0%B8%D1%8F%20%D0%BD%D0%B0%D0%B4%D1%91%D0%B6%D0%BD%D0%BE%D1%81%D1%82%D0%B8%20%D0%B8%20%D1%81%D0%B1%D0%BE%D0%B5%D0%B2%20Strategist%29.md) и [ENG.WP.020-strategist-hardening (Укрепление надёжности Strategist).md](/Users/alexander/Github/DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.020-strategist-hardening%20%28%D0%A3%D0%BA%D1%80%D0%B5%D0%BF%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5%20%D0%BD%D0%B0%D0%B4%D1%91%D0%B6%D0%BD%D0%BE%D1%81%D1%82%D0%B8%20Strategist%29.md) стало ясно:

- `Strategist` можно сделать надёжнее локально;
- но это не решает базовую проблему `24/7`;
- пока ноутбук выключен, `launchd + claude CLI + local logs/locks/state` недоступны;
- следовательно, нынешний `Strategist` не является truly always-on контуром.

## Главный вопрос этого WP

Что именно должно означать для `Strategist` требование:

- “работать 24/7 даже при выключенном ноутбуке”?

И через какой runtime-контракт это можно сделать без разрушения truthful semantics.

## Truthful baseline

На сегодня:

- `Strategist` = `local-primary`
- работает через `launchd` на Mac
- исполняет сценарии через локальный `claude` CLI
- зависит от:
  - локальных logs
  - локальных lock-директорий
  - локального auth/session state
  - локального файлового workspace

Следовательно:

- при выключенном ноутбуке `Strategist` не должен считаться активным;
- если он “должен работать 24/7”, нужен отдельный runtime-контракт.

## Варианты 24/7-модели

### Вариант A — Local-only truth

`Strategist` остаётся только локальным.

Когда ноутбук выключен:

- `Strategist` честно считается offline;
- always-on контур не пытается его подменять;
- система работает дальше без него.

Плюсы:

- минимальный риск semantic drift
- не надо выдумывать cloud-clone

Минусы:

- нет настоящего 24/7 для стратегических сценариев

### Вариант B — Remote-capable Strategist runner

Создаётся отдельный runner, который умеет:

- исполнять protocol-driven сценарии вне ноутбука;
- работать либо на VPS, либо на отдельном always-on узле;
- использовать совместимый model-provider/runtime;
- писать truth-artifacts в тот же source-of-truth контур.

Плюсы:

- настоящий 24/7 режим

Минусы:

- большой redesign
- высокий риск рассинхрона с local runner

### Вариант C — Split by scenario

Разделить `Strategist` на два класса сценариев:

1. `local-only deep work`
   - `strategy-session`
   - сложный `note-review`
   - интерактивный `day-close`

2. `cloud-safe scheduled scenarios`
   - `morning` / `day-plan`
   - возможно `week-review`
   - возможно отдельный `status/opening summary`

Плюсы:

- реалистичный путь к частичному 24/7
- не надо выносить весь Strategist сразу

Минусы:

- нужна аккуратная декомпозиция сценариев
- нужен `no-double-run` и heartbeat contract

## Предварительный вердикт

Наиболее реалистичный путь сейчас:

- не делать полный cloud clone `Strategist`;
- идти через `Вариант C`:
  - выделить cloud-safe сценарии;
  - оставить deep-work сценарии local-only;
  - построить один truthful runtime contract между local и cloud.

## Что обязательно должно появиться

### 1. Runtime mode source-of-truth

Система должна знать:

- local strategist active?
- cloud strategist active?
- кто primary сейчас?

### 2. No-double-run rule

Один и тот же сценарий не должен:

- одновременно стартовать локально и в облаке;
- писать два conflicting результата.

### 3. Unified result semantics

И local, и cloud runner должны писать одинаковые result classes:

- `success`
- `failed`
- `timeout`
- `auth_failed`
- `skipped_lock`
- `offline_by_design`
- `unsupported_path`

### 4. Auth model

Нельзя завязывать 24/7-контур только на локальный `claude /login`.

Нужна отдельная стратегия:

- либо OpenAI-compatible runner,
- либо remote Claude-compatible auth/runtime,
- либо явный отказ от cloud-run для части сценариев.

## Первый practical step

Не кодить всё сразу, а сначала сделать карту сценариев `Strategist`:

| Сценарий | Local-only | Cloud-safe | Нужен redesign |
|---|---|---|---|
| `morning/day-plan` |  |  |  |
| `session-prep` |  |  |  |
| `week-review` |  |  |  |
| `note-review` |  |  |  |
| `day-close` |  |  |  |
| `strategy-session` |  |  |  |

И только потом выбрать первый сценарий для реального 24/7 выноса.

## Карта сценариев Strategist

Ниже — первый factual split по текущим prompt'ам и runtime-зависимостям.

| Сценарий | Класс | Почему |
|---|---|---|
| `day-plan` | `legacy shell alias -> protocol-open` | Сам legacy prompt больше не является source-of-truth; runner уже резолвит открытие дня в canonical `protocol-open.md`, так что 24/7 контракт нужно строить вокруг opening-route, а не вокруг старого prompt-файла |
| `morning` | `cloud-safe candidate` | Сам shell-entrypoint локальный, но смысл сценария уже фактически сводится к scheduled opening route; после split можно выносить как cloud-safe `opening-summary` path |
| `session-prep` | `cloud-safe candidate with caveats` | Не требует живого пользователя, но сильно читает WeekPlan, inbox, Strategy, WORKPLAN и строит weekly draft; возможен вынос, если будет единый source-of-truth и no-double-run |
| `week-review` | `cloud-safe candidate with redesign` | Это лучший кандидат на 24/7 scheduled strategist-path, но он тяжёлый: собирает коммиты по всем репо, пишет в WeekPlan и DS-Knowledge-Index, зависит от truthful result semantics |
| `note-review` | `requires redesign` | Работает с живым локальным inbox, deterministic cleanup, archive flow и частично полуинтерактивной семантикой; слишком много локального mutable state |
| `day-close` | `local-only interactive only` | Завязан на `protocol-close`, governance batch, memory/backup semantics и по факту не годится для headless strategist-runner; `strategist.sh day-close` теперь truthfully возвращает `unsupported_path` |
| `strategy-session` | `local-only` | По смыслу это deep-work/interactive сценарий, не годится для always-on выноса |

## Первый design verdict

Для реального 24/7 не нужно пытаться вынести весь `Strategist` целиком.

Первый реалистичный split такой:

### Local-only остаются

- `strategy-session`
- `day-close`
- `note-review`

### Первыми cloud-safe кандидатами становятся

- `week-review`
- затем `session-prep`
- затем новый `morning/opening-summary` слой, но уже не через legacy `day-plan`

## Почему `week-review` — лучший первый кандидат

1. Это scheduled scenario, а не live collaboration
2. Он больше всего соответствует идее “система работает даже когда ноутбук выключен”
3. Он уже и так запускается автоматически по расписанию
4. Его результат хорошо проверяем:
   - появился блок итогов в WeekPlan?
   - создан пост недели?
   - записан truthful result class?

При этом он ещё достаточно сложный, чтобы стать правильным test-case для всего 24/7 runtime contract.

## Следующий practical step

Следующий инженерный шаг для этого WP уже уточнился после operational fixes 2026-04-07:

1. Не пытаться выносить `day-close` в 24/7-контур вообще
2. Считать первым реальным кандидатом на remote-capable pilot именно `week-review`
3. Для pilot-ветки зафиксировать:
   - runtime mode source-of-truth
   - no-double-run rule между local `launchd` и cloud runner
   - unified result semantics, включая `unsupported_path`
4. После этого открывать уже не общий discussion, а отдельный implementation slice под `week-review` как первый cloud-safe scenario

Не писать remote runner вслепую, а открыть следующий implementation slice:

1. `week-review` как первый cloud-safe strategist scenario
2. определить:
   - кто его запускает
   - где живёт auth
   - кто пишет truth-artifacts
   - как предотвращается double-run local/cloud

## Truthful status

WP только открыт.

Текущий правильный вывод:

- `Strategist` в текущем виде не является 24/7 агентом;
- hardening локального runner-а полезен, но не решает always-on задачу;
- для 24/7 нужен отдельный runtime contract, а не только “починить ещё один shell-скрипт”.

## Operational note after 2026-04-08 hardening

После очередного hardening-среза weekly semantics уже выровнены точнее:

- source-of-truth scheduler-window для `week-review` = `Понедельник 00:00`;
- legacy `Sunday` wording убран из runner-а и help-текста;
- prompt больше не привязан к несуществующему `DS-Knowledge-Index`, а резолвит реальный knowledge-index repo из workspace.

Это ещё не делает `week-review` cloud-ready, но снимает часть ложной вариативности перед следующим 24/7 implementation slice.
