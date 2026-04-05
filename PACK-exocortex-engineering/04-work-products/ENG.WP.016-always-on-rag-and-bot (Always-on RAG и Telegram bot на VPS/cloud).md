---
type: engineering-work-product
wp_id: ENG.WP.016
title: Always-on RAG и Telegram bot на VPS/cloud
date: 2026-04-05
status: active
priority: critical
linked_inbox: ENGINEERING
author: Environment Engineer (Codex)
---

# ENG.WP.016 — Always-on RAG и Telegram bot на VPS/cloud

## Контекст

После `ENG.WP.014` и `ENG.WP.015` выбран первый practical move:

- не переносить сразу `strategist/extractor/scheduler`;
- сначала вынести продуктовый/API-first слой в always-on runtime;
- сделать так, чтобы `VK-offee` бот и RAG не зависели от включённого ноутбука.

Это самый безопасный и самый полезный первый шаг гибридной архитектуры:

- локальные deep-work агенты остаются local-primary;
- продуктовый Telegram-контур становится cloud-primary.

## Цель

Собрать implementation plan и acceptance criteria для двух сервисов:

1. [VK-offee-rag](/Users/alexander/Github/VK-offee-rag) как always-on API
2. [VK-offee/telegram-bot](/Users/alexander/Github/VK-offee/telegram-bot) как always-on Telegram process

Итоговое состояние:

- бот отвечает при выключенном ноутбуке;
- RAG API доступен по стабильному remote endpoint;
- local runtime остаётся только для dev/debug;
- нет двойного запуска локального и облачного polling bot.

## Scope

### In scope

- deployment contract для `VK-offee-rag`
- deployment contract для `VK-offee/telegram-bot`
- env/source-of-truth для облачного слоя
- health / smoke tests
- rule `single active bot process`
- переключение `RAG_API_URL` на remote endpoint

### Out of scope

- redesign `strategist`
- redesign `extractor`
- перенос `scheduler` в облако
- полный Kubernetes / heavy infra layer

## Целевой runtime

### Service 1 — RAG API

Репозиторий:

- [VK-offee-rag](/Users/alexander/Github/VK-offee-rag)

Требования:

- always-on process на VPS/cloud
- стабильный host/port или reverse-proxy URL
- env из отдельного server-side secret store
- health endpoint или lightweight readiness check

Минимальный контракт:

- process manager: `systemd`, `pm2` или другой always-on supervisor
- логирование в серверные логи
- restart policy при падении

### Service 2 — Telegram bot

Репозиторий:

- [VK-offee/telegram-bot](/Users/alexander/Github/VK-offee/telegram-bot)

Требования:

- один активный polling process
- чтение `RAG_API_URL` из server env
- локальный запуск допускается только как debug-mode

Минимальный контракт:

- cloud bot = primary
- local bot = disabled by default
- явная защита от accidental double-run

## Ключевые инженерные решения

### 1. Single active bot process

Обязательное правило:

- если cloud bot активен, локальный polling не должен запускаться как обычный runtime.

Практически это значит:

- нужен флаг/переменная режима (`BOT_RUNTIME_MODE=cloud|local-debug`)
- или отдельный guard в стартовом скрипте

### 2. Stable remote RAG endpoint

Локальный `localhost` больше не может быть основным адресом для продуктового бота.

Нужно:

- выделить remote endpoint
- обновить env-конфиг для bot-runtime
- зафиксировать, где хранится canonical `RAG_API_URL`

### 3. Secret placement

Cloud secrets не должны жить в git.

Для этого контура нужны минимум:

- `OPENAI_API_KEY`
- `TELEGRAM_BOT_TOKEN`
- `RAG_API_URL` / host settings
- при необходимости дополнительные app vars

## Acceptance criteria

Работа считается завершённой, если:

1. `VK-offee-rag` доступен на VPS/cloud по стабильному endpoint
2. `VK-offee` bot подключён к remote RAG, а не к локальному `localhost`
3. при выключенном ноутбуке бот продолжает отвечать
4. двойной запуск bot process исключён
5. есть smoke test и recovery note

## Smoke tests

### Test A — cloud normal mode

1. ноутбук выключен или локальный bot process не запущен
2. cloud bot активен
3. запрос в Telegram получает корректный ответ

### Test B — RAG health

1. health/readiness check для remote RAG проходит
2. bot может получить ответ от RAG endpoint

### Test C — no-double-run

1. попытка локального запуска в обычном режиме либо блокируется,
2. либо явно уходит в `local-debug` без второго polling primary

## Practical next step

Следующий инженерный проход должен собрать:

1. текущую VPS/cloud площадку и способ деплоя
2. фактический стартовый скрипт/entrypoint для `VK-offee-rag`
3. фактический стартовый скрипт/entrypoint для `VK-offee/telegram-bot`
4. целевую схему env для сервера

## Фактическая карта текущего деплоя

### Что уже есть

В [VK-offee/telegram-bot/deploy.sh](/Users/alexander/Github/VK-offee/telegram-bot/deploy.sh) уже есть рабочий skeleton деплоя под Ubuntu:

- рабочая директория `/opt/vk-offee`
- клоны `VK-offee` и `VK-offee-rag`
- отдельные `venv` для RAG и bot
- `systemd` сервисы:
  - `vk-rag-api.service`
  - `vk-telegram-bot.service`

Это означает, что у продуктового контура уже есть **deployment seed**, а не только идея.

### Что уже подтверждено по entrypoint'ам

#### RAG API

- entrypoint: [VK-offee-rag/src/api.py](/Users/alexander/Github/VK-offee-rag/src/api.py)
- запуск через `python src/api.py`
- внутри `uvicorn.run(...)`
- env: `.env`
- health endpoint уже есть: `/health`

#### Telegram bot

- entrypoint: [VK-offee/telegram-bot/bot.py](/Users/alexander/Github/VK-offee/telegram-bot/bot.py)
- transport: `python-telegram-bot` polling
- env: `.env`
- RAG client: [VK-offee/telegram-bot/rag_client.py](/Users/alexander/Github/VK-offee/telegram-bot/rag_client.py)
- bot уже умеет работать через `RAG_API_URL`

### Где сейчас главный зазор

1. [VK-offee-rag/src/api.py](/Users/alexander/Github/VK-offee-rag/src/api.py) жёстко заточен под:
   - `API_HOST = "127.0.0.1"`
   - текстовый контракт `localhost only`

2. [VK-offee/telegram-bot/rag_client.py](/Users/alexander/Github/VK-offee/telegram-bot/rag_client.py) по умолчанию использует:
   - `RAG_API_URL=http://127.0.0.1:8000`

3. [VK-offee/telegram-bot/start.sh](/Users/alexander/Github/VK-offee/telegram-bot/start.sh) сейчас не является реальным runtime-entrypoint:
   - он завершается сообщением “бот временно отключён”

4. `deploy.sh` всё ещё клонирует старый GitHub namespace:
   - `https://github.com/alexpoaiagent-sudo/...`
   - значит перед реальным VPS rollout его нужно перевести на новый аккаунт `AlexPoAi`

### Truthful вывод по readiness

- `vk-rag-api.service` и `vk-telegram-bot.service` уже концептуально описаны;
- bot deployment path ближе к production, чем казалось;
- реальный блокер always-on запуска сейчас не в отсутствии systemd-скелета, а в том, что:
  - RAG официально считается localhost-only,
  - `RAG_API_URL` зафиксирован как local default,
  - `deploy.sh` смотрит в старый GitHub namespace.

## Следующий implementation slice

Наиболее правильный следующий шаг уже не общий, а точечный:

1. починить deployment contract в [VK-offee/telegram-bot/deploy.sh](/Users/alexander/Github/VK-offee/telegram-bot/deploy.sh):
   - новый GitHub namespace
   - явный remote-ready `RAG_API_URL`

2. подготовить `VK-offee-rag` к cloud mode:
   - вынести `API_HOST` в env
   - различить `localhost-dev` и `server-runtime`

3. ввести guard для `single active bot process`

## Truthful status

- implementation WP открыт;
- архитектурный first move выбран правильно;
- реальный deployment ещё не начат, но deployment seed в `telegram-bot/deploy.sh` уже существует.

## Fact update — implementation started

Уже внесены первые кодовые изменения, которые готовят контур к always-on режиму без фактического rollout:

1. [VK-offee-rag/src/api.py](/Users/alexander/Github/VK-offee-rag/src/api.py)
   - `API_HOST` больше не жёстко зашит в `127.0.0.1`
   - теперь host берётся из env с безопасным default `127.0.0.1`
   - API умеет truthful-ответ `local-only` vs `remote-enabled`

2. [VK-offee/telegram-bot/deploy.sh](/Users/alexander/Github/VK-offee/telegram-bot/deploy.sh)
   - GitHub namespace обновлён на `AlexPoAi`
   - server env дополнен `API_HOST`, `API_PORT`, `RAG_TIMEOUT`, `BOT_RUNTIME_MODE=cloud`

3. [VK-offee/telegram-bot/.env.example](/Users/alexander/Github/VK-offee/telegram-bot/.env.example)
   - создан versioned env template для cloud/local-debug режима

4. [VK-offee/telegram-bot/.gitignore](/Users/alexander/Github/VK-offee/telegram-bot/.gitignore)
   - добавлено исключение `!.env.example`, чтобы template реально жил в git несмотря на global ignore

5. [VK-offee/telegram-bot/rag_client.py](/Users/alexander/Github/VK-offee/telegram-bot/rag_client.py)
   - зафиксирован контракт: `localhost` допустим только как dev fallback, production/cloud обязан задавать `RAG_API_URL` явно

6. [VK-offee/telegram-bot/bot.py](/Users/alexander/Github/VK-offee/telegram-bot/bot.py)
   - в логах отражается `BOT_RUNTIME_MODE`, чтобы было видно, в каком режиме стартовал бот

Проверка:

- `python3 -m py_compile` для `VK-offee-rag/src/api.py`, `telegram-bot/rag_client.py`, `telegram-bot/bot.py` — OK
- `bash -n telegram-bot/deploy.sh` — OK

Это означает, что implementation уже начат на уровне кода, но ещё не прошёл через реальный VPS rollout и smoke test с выключенным ноутбуком.

## Historical evidence и текущий blocker

Из прошлых WP и session artifacts уже известно:

- старый VPS существовал и раньше использовался для `VK-offee` bot + RAG;
- бот и RAG уже запускались на Timeweb VPS `72.56.4.61`;
- позже был зафиксирован блокер: старый VPS больше не используется и нужен новый серверный контур.

Подтверждающие артефакты:

- [WP-38-vps-deploy-vkoffee-bot (Облачный деплой VK-offee бота и RAG API).md](/Users/alexander/Github/DS-strategy/inbox/WP-38-vps-deploy-vkoffee-bot%20%28%D0%9E%D0%B1%D0%BB%D0%B0%D1%87%D0%BD%D1%8B%D0%B9%20%D0%B4%D0%B5%D0%BF%D0%BB%D0%BE%D0%B9%20VK-offee%20%D0%B1%D0%BE%D1%82%D0%B0%20%D0%B8%20RAG%20API%29.md)
- [WP-42-vps-architecture-analysis (Анализ архитектуры VPS и сценарии работы).md](/Users/alexander/Github/DS-strategy/inbox/WP-42-vps-architecture-analysis%20%28%D0%90%D0%BD%D0%B0%D0%BB%D0%B8%D0%B7%20%D0%B0%D1%80%D1%85%D0%B8%D1%82%D0%B5%D0%BA%D1%82%D1%83%D1%80%D1%8B%20VPS%20%D0%B8%20%D1%81%D1%86%D0%B5%D0%BD%D0%B0%D1%80%D0%B8%D0%B8%20%D1%80%D0%B0%D0%B1%D0%BE%D1%82%D1%8B%29.md)
- [WP-43-fix-vps-embeddings (Починить RAG индексацию на VPS).md](/Users/alexander/Github/DS-strategy/inbox/WP-43-fix-vps-embeddings%20%28%D0%9F%D0%BE%D1%87%D0%B8%D0%BD%D0%B8%D1%82%D1%8C%20RAG%20%D0%B8%D0%BD%D0%B4%D0%B5%D0%BA%D1%81%D0%B0%D1%86%D0%B8%D1%8E%20%D0%BD%D0%B0%20VPS%29.md)

Truthful blocker:

- реальный rollout сейчас упирается не в отсутствие deploy-script, а в отсутствие подтверждённого нового VPS/runtime target.

## Rollout checklist

### Вариант A — новый VPS уже есть

1. Подтвердить сервер:
   - IP / SSH доступ
   - Ubuntu 22.04+
   - минимум 4GB RAM, 20GB SSD

2. Подтвердить runtime target:
   - рабочая директория `/opt/vk-offee`
   - `systemd` доступен
   - outbound доступ к OpenAI/Anthropic или рабочему proxy/base URL

3. На сервере выполнить:
   - clone/pull `VK-offee`
   - clone/pull `VK-offee-rag`
   - создать `venv`
   - заполнить server env:
     - `VK-offee-rag/.env`
     - `VK-offee/telegram-bot/.env`

4. Проверить server env contract:
   - `VK-offee-rag/.env`
     - `API_HOST=127.0.0.1` если бот и RAG на одном сервере
     - `API_PORT=8000`
     - `OPENAI_API_KEY`
     - `ANTHROPIC_API_KEY`
   - `VK-offee/telegram-bot/.env`
     - `TELEGRAM_BOT_TOKEN`
     - `RAG_API_URL=http://127.0.0.1:8000`
     - `BOT_RUNTIME_MODE=cloud`

5. Запустить `deploy.sh` или развернуть systemd units вручную.

6. Проверить systemd:
   - `vk-rag-api.service`
   - `vk-telegram-bot.service`

7. Прогнать smoke tests:
   - `curl http://127.0.0.1:8000/health`
   - проверка логов `journalctl`
   - вопрос боту в Telegram
   - тест при выключенном ноутбуке

### Вариант B — нового VPS ещё нет

1. Сначала закрыть инфраструктурный blocker:
   - выбрать provider
   - зарегистрировать новый VPS
   - получить IP/SSH

2. После этого вернуться к варианту A без перепроектирования кода.

## Smoke test contract — ноутбук выключен

Минимальный acceptance run:

1. локальный `VK-offee` bot process не запущен;
2. ноутбук выключен или disconnected;
3. на сервере живы:
   - `vk-rag-api.service`
   - `vk-telegram-bot.service`
4. пользователь пишет боту в Telegram;
5. бот отвечает через remote RAG;
6. в логах видно `BOT_RUNTIME_MODE=cloud`.
