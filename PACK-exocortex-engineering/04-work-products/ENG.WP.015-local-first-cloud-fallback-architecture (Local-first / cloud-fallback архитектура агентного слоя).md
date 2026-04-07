---
type: engineering-work-product
wp_id: ENG.WP.015
title: Local-first / cloud-fallback архитектура агентного слоя
date: 2026-04-05
status: active
priority: critical
linked_inbox: ENGINEERING
author: Environment Engineer (Codex)
---

# ENG.WP.015 — Local-first / cloud-fallback архитектура агентного слоя

## Контекст

После `ENG.WP.014` подтверждено:

- экосистема не может считаться truly always-on, пока значимая часть агентного слоя живёт только на ноутбуке;
- массовый перевод всех агентов на другой model-provider не решает проблему runtime;
- нужен не только новый provider, но и **единый контракт исполнения**: кто запускается локально, кто обязан жить в облаке и как происходит fallback без двойных запусков.

Пользовательский контракт сформулирован так:

- пока ноутбук включён, локальные агенты могут работать как primary runtime;
- когда локальный runtime недоступен, облачный слой должен брать на себя жизненно важные сервисы;
- маршруты не должны расползаться на “один агент делает так, другой иначе”.

## Цель

Описать гибридную архитектуру `local-first / cloud-fallback`, где:

1. локальные deep-work агенты продолжают работать в полном файловом workspace;
2. always-on сервисы и продуктовые контуры вынесены в VPS/cloud;
3. переключение между слоями определено через heartbeat и health semantics;
4. исключён double-run одного и того же контура одновременно локально и в облаке.

## Классы контуров

### 1. Local primary

Это контуры, которые остаются основными на ноутбуке и не должны бездумно переноситься в облако:

- [strategist.sh](/Users/alexander/Github/FMT-exocortex-template/roles/strategist/scripts/strategist.sh)
- [extractor.sh](/Users/alexander/Github/FMT-exocortex-template/roles/extractor/scripts/extractor.sh)
- [scheduler.sh](/Users/alexander/Github/FMT-exocortex-template/roles/synchronizer/scripts/scheduler.sh)
- protocol-driven runs: `day-open`, `day-close`, `week-review`, `note-review`

Причина:

- глубокая файловая работа в workspace;
- локальные logs / locks / state;
- завязка на CLI-runner и desktop context;
- высокий риск semantic drift при переносе без redesign.

### 2. Cloud primary

Это контуры, которые должны жить always-on в VPS/cloud и не зависеть от включённого ноутбука:

- [VK-offee-rag](/Users/alexander/Github/VK-offee-rag)
- [VK-offee/telegram-bot](/Users/alexander/Github/VK-offee/telegram-bot)
- базовые Telegram operational notifications
- GitHub Actions workflows
- API-first utility layer и консультационные скрипты, не требующие локального файлового контекста

### 3. Hybrid / fallback-capable

Это контуры, где допускается локальный primary с облачным backup или наоборот:

- health/status layer
- lightweight monitoring
- non-destructive reports
- часть retrieval/summary маршрутов, если они могут читать общий state из versioned artifacts

## Канонический контракт переключения

### Primary mode

- `local-primary`: ноутбук активен, heartbeat локального контура свежий, локальные агенты имеют право исполняться.
- `cloud-primary`: локальный heartbeat отсутствует или stale, always-on контур принимает исполнение сервисных задач.

### Heartbeat

Минимальный heartbeat должен отвечать на 3 вопроса:

1. ноутбук / local runtime жив?
2. локальный scheduler/strategist реально стартовали сегодня?
3. есть ли право у cloud backup брать на себя часть задач?

Кандидаты source-of-truth:

- [SESSION-CONTEXT.md](/Users/alexander/Github/DS-strategy/current/SESSION-CONTEXT.md)
- [AGENTS-STATUS.md](/Users/alexander/Github/DS-strategy/current/AGENTS-STATUS.md)
- [SESSION-OPEN (Экран открытия сессии).md](/Users/alexander/Github/DS-strategy/current/SESSION-OPEN%20%28%D0%AD%D0%BA%D1%80%D0%B0%D0%BD%20%D0%BE%D1%82%D0%BA%D1%80%D1%8B%D1%82%D0%B8%D1%8F%20%D1%81%D0%B5%D1%81%D1%81%D0%B8%D0%B8%29.md)
- отдельный `heartbeat.json` / `runtime-mode.md` в `DS-agent-workspace` или `DS-strategy/current/`

### Failover rule

Облачный fallback **не** должен запускаться по любой ошибке. Он активируется только если:

- local heartbeat stale;
- ноутбук offline;
- локальный primary явно помечен как unavailable;
- есть явный allowed-scope для cloud execution.

### No-double-run rule

Обязательное правило:

- один и тот же контур не может считаться одновременно локально активным и облачно активным без явного split.

Следствие:

- `VK-offee` bot нельзя держать одновременно в двух polling processes;
- `scheduler` не должен существовать одновременно в двух truth-producing экземплярах;
- один и тот же operational report не должен генерироваться из локального и облачного источника одновременно.

## Предлагаемое распределение ролей

| Контур | Local role | Cloud/VPS role | Truthful target state |
|---|---|---|---|
| `VK-offee-rag` | dev / maintenance | primary API | cloud-primary |
| `VK-offee/telegram-bot` | local debug only | primary bot runtime | cloud-primary |
| `health-check` | local detailed health | cloud backup status ping | hybrid |
| `daily-report` | primary truth-producing opening artifact | optional cloud health digest only | local-primary |
| `strategist` | primary deep-work agent | no direct clone until redesign | local-primary |
| `extractor` | primary inbox/file agent | no direct clone until redesign | local-primary |
| `scheduler` | primary orchestration | optional future cloud orchestrator after redesign | local-primary now |

## Что должно жить в VPS/cloud first

### Волна A

1. `VK-offee-rag` как always-on API service
2. `VK-offee` bot как always-on Telegram process
3. базовый health endpoint / service status

### Волна B

1. operational notifications
2. lightweight monitoring
3. optional remote consult endpoints на OpenAI

### Волна C

Отдельный redesign для:

- `strategist`
- `extractor`
- `scheduler`

## Чего нельзя делать

- нельзя строить cloud fallback без heartbeat contract;
- нельзя разрешать silent failover, после которого непонятно, кто сейчас primary;
- нельзя переносить protocol-heavy агенты в облако до redesign state/log/lock semantics;
- нельзя считать, что “OpenAI API есть” автоматически означает “агентный runtime уже portable”.

## Practical next step

Следующий implementation WP должен быть уже не общим, а конкретным:

1. always-on `VK-offee-rag`
2. always-on `VK-offee` bot
3. health / status marker для local vs cloud mode
4. smoke test: ноутбук online/offline и поведение продуктового контура

## Truthful status

- архитектурный split `desktop-bound` vs `always-on` уже собран;
- гибридная модель признана лучшей стратегией, чем массовый перенос всех агентов;
- контракт fallback теперь описан;
- implementation ещё не начат.

## Уточнение после provider migration

На 2026-04-07 локальный агентный слой уже может жить в режиме `Codex-primary / Claude-fallback`.

Это улучшает provider stability и снижает зависимость от Anthropic-path, но **не меняет** базовый truthful verdict этого WP:

- `Strategist`
- `Extractor`
- `Scheduler`

по-прежнему остаются `local-primary` контурами, пока их runtime/state/lock semantics не вынесены в отдельный cloud-capable contract.
