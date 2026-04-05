---
type: engineering-work-product
wp_id: ENG.WP.014
title: OpenAI-first always-on миграция агентного слоя
date: 2026-04-05
status: active
priority: critical
linked_inbox: ENGINEERING
author: Environment Engineer (Codex)
---

# ENG.WP.014 — OpenAI-first always-on миграция агентного слоя

## Контекст

Подтверждён главный инфраструктурный дефект экосистемы:

- пока ноутбук включён, локальные агенты работают;
- как только ноутбук выключается, значимая часть агентного слоя перестаёт существовать как runtime.

Это означает, что проблема не только в модели или ключах, а в том, что агенты остаются **desktop-bound**:

- локальный `claude` CLI
- `launchd`
- локальные `~/.config/*` env layers
- локальные логи, lock-файлы и state markers

Параллельно подтверждено, что:

- OpenAI API доступен и рабочий;
- `VK-offee-rag` и часть API-first контуров архитектурно легче переводятся в always-on режим;
- `strategist` / `extractor` / `scheduler` не переводятся простым “подставить другой ключ”, а требуют нового runtime-контракта.

## Цель

Разделить агентный слой на два класса:

1. **Migratable first**
   - можно переводить на OpenAI-first / always-on быстро

2. **Requires refactor**
   - пока остаются desktop-bound
   - требуют отдельного runner/runtime redesign

Итогом должен стать roadmap, который уменьшает зависимость экосистемы от включённого ноутбука.

## Карта контуров

### 1. Migratable first

| Контур | Текущий runtime | Почему можно выносить | Целевой runtime |
|---|---|---|---|
| [VK-offee-rag](/Users/alexander/Github/VK-offee-rag) | локальный FastAPI + `.env` | API-first, уже отделён от UI, OpenAI доступен | always-on service на VPS/сервере |
| [VK-offee/telegram-bot](/Users/alexander/Github/VK-offee/telegram-bot) | локальный polling bot + `RAG_API_URL` | продуктовый бот может жить отдельно от desktop-агентов | always-on bot + remote RAG API |
| `creativ-convector` AI workflows | GitHub Actions / scripts | уже близко к API-first модели | GitHub Actions + repo secrets |
| отдельные util tools типа [fpf-consult.sh](/Users/alexander/Github/DS-strategy/tools/fpf-consult.sh) | shell + OpenAI env | не требуют локального `claude` раннера как архитектуры | API-first utility layer |

### 2. Requires refactor

| Контур | Почему desktop-bound сейчас | Что мешает миграции |
|---|---|---|
| [strategist.sh](/Users/alexander/Github/FMT-exocortex-template/roles/strategist/scripts/strategist.sh) | завязан на локальный `claude` CLI, protocol-runner, logs, state | нужен OpenAI-compatible runner, а не только другой key |
| [extractor.sh](/Users/alexander/Github/FMT-exocortex-template/roles/extractor/scripts/extractor.sh) | тот же CLI/runtime pattern + файловая работа в локальном workspace | нужен новый execution contract |
| [scheduler.sh](/Users/alexander/Github/FMT-exocortex-template/roles/synchronizer/scripts/scheduler.sh) | завязан на `launchd`, local state и локальные роли | нужен always-on orchestration layer |
| `day-open/day-close/week-review` protocol runs | protocol-driven Claude/Codex workflows | нужны единые remote-capable runners или явный split local/cloud |

## Truthful архитектурный вывод

### Что нельзя делать

- нельзя “перевести всех агентов на OpenAI” одной заменой ключа;
- нельзя считать, что OpenAI API автоматически заменит `claude` CLI как execution runtime;
- нельзя выносить `scheduler/strategist/extractor` на VPS без redesign state, locks, logs и protocol execution.

### Что можно делать уже сейчас

1. Вынести `VK-offee-rag` в always-on runtime.
2. Привязать `VK-offee` bot к remote RAG API.
3. Считать GitHub Actions и API-first workflows отдельным облачным слоем.
4. Оставить `strategist/extractor/scheduler` как desktop-bound до отдельного refactor-RP.

## Предлагаемый roadmap

### Фаза A — снять зависимость продуктового контура от ноутбука

1. `VK-offee-rag` → always-on API
2. `VK-offee` bot → always-on bot process
3. smoke test продуктового Telegram-контура

### Фаза B — описать remote runtime contract для агентов экзокортекса

1. state store
2. logs
3. lock model
4. protocol runner
5. notifications

### Фаза C — решить судьбу `strategist/extractor/scheduler`

Варианты:

- новый OpenAI-first runner
- hybrid model: cloud scheduler + local deep-work agents
- VPS-hosted CLI/runtime

## Practical next step

Ближайший наименее рискованный ход:

1. не трогать пока `strategist/extractor/scheduler`
2. сфокусироваться на `VK-offee-rag` и `VK-offee` как first migration target
3. открыть следующий implementation WP на `always-on RAG + bot`

## Truthful status

- карта пригодности к миграции собрана
- OpenAI-first direction признан реалистичным
- массовый перевод “всех агентов” признан неправильной стратегией
- следующая реализация должна идти через product/API-first слой, а не через ломку desktop-bound агентного ядра
