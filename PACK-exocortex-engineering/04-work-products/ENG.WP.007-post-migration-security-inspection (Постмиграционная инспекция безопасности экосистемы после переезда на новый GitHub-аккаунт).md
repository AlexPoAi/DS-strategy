---
type: engineering-work-product
wp_id: ENG.WP.007
title: Постмиграционная инспекция безопасности экосистемы после переезда на новый GitHub-аккаунт
date: 2026-04-04
status: active
priority: high
linked_inbox: SECURITY
author: Environment Engineer (Codex)
---

# ENG.WP.007 — Постмиграционная инспекция безопасности экосистемы после переезда на новый GitHub-аккаунт

## Контекст

Экосистема переезжает на новый GitHub-аккаунт. Старый аккаунт и старые публичные репозитории считаются потенциально скомпрометированным контуром.

Цель этого WP — провести полную post-migration инспекцию безопасности на новом аккаунте, не ломая рабочие автоматизации, и подготовить безопасный порядок ротации секретов и зачистки следов.

---

## Scope

### Репозитории экосистемы

- `VK-offee`
- `VK-offee-rag`
- `DS-strategy`
- `DS-agent-workspace`
- `FMT-exocortex-template`
- `creativ-convector`
- `PACK-iwe-culture`
- `DS-Knowledge-Index-Tseren`
- `agency-agents`

### Что проверяем

1. Visibility и доступы новых репозиториев на новом GitHub-аккаунте
2. Локальные `remote.origin.url` и каналы аутентификации (`git`, `gh`, VS Code, Claude Code)
3. Runtime-хранилища секретов (`.env`, `~/.config/aist/env`, локальные конфиги среды)
4. GitHub Actions secrets и зависимые workflow
5. Локальные OAuth-файлы и интеграции (Google Drive / Sheets, Saby, Telegram)
6. Следы секретов в документации, логах и истории git

---

## Подтверждённые риски на момент открытия WP

### История и публичность

- В истории `VK-offee` ранее подтверждались утечки Telegram bot token и частично Anthropic key
- Ключевые репозитории экосистемы были публичными

### Локальная среда

- В `~/Github/.claude/settings.json` найден прямой Telegram bot token в командах `curl`
- Секреты распределены между несколькими runtime-контурами:
  - `VK-offee/telegram-bot/.env`
  - `VK-offee-rag/.env`
  - `~/.config/aist/env`
  - GitHub Actions secrets
  - локальные конфиги среды

### Архитектурный риск

- Нет единого source-of-truth для секретов и каналов авторизации
- Экосистема использует несколько независимых auth-слоёв одновременно

---

## Рабочий порядок

### Этап 1 — инвентаризация

- Зафиксировать все репозитории на новом аккаунте
- Проверить, что целевые репозитории private
- Собрать таблицу: `секрет → где хранится → кто использует → риск ротации`

### Этап 2 — изоляция доступа

- Убедиться, что новые `remote.origin.url` не содержат токены
- Проверить collaborators, GitHub Apps, webhooks, Actions permissions

### Этап 3 — ротация

- GitHub PAT / repo token
- Telegram bot token
- OpenAI / Anthropic keys
- Google OAuth tokens при необходимости
- Saby secrets при необходимости

### Этап 4 — верификация

- Проверить `git push/pull`
- Проверить Telegram notifications
- Проверить sync Google Drive / Sheets
- Проверить VK-offee bot / RAG
- Проверить cloud/local scheduler workflows

### Этап 5 — чистка следов

- Санитизация документации
- Удаление секретов из локальных конфигов, где они не должны жить
- Решение по rewrite history только после успешной ротации

---

## Артефакты, которые должны появиться по итогам

- `security-migration-audit-report.md`
- `rotation-runbook.md`
- `residual-risks.md`
- при необходимости: `secret-inventory.md` или `.csv`

---

## Factual Secret Inventory (срез на 2026-04-05)

Ниже — factual inventory без раскрытия значений. Это уже не план, а подтверждённый срез по локальной экосистеме.

### 1. Локальные runtime secret stores

| Место | Тип | Git-статус | Кто использует | Риск |
|---|---|---|---|---|
| [/.claude/settings.json](/Users/alexander/Github/.claude/settings.json) | локальный config/allowed commands | локальный файл, не versioned source-of-truth | локальная среда Codex/Claude, Telegram/OpenAI-related команды | высокий |
| [FMT-exocortex-template/.claude/settings.json](/Users/alexander/Github/FMT-exocortex-template/.claude/settings.json) | repo-local settings | **tracked** | FMT template/runtime | средний |
| [VK-offee-rag/.env](/Users/alexander/Github/VK-offee-rag/.env) | runtime env | ignored, не tracked | `src/api.py`, `src/indexer.py`, `src/query.py` через `load_dotenv()` | высокий |
| [VK-offee/telegram-bot/.env](/Users/alexander/Github/VK-offee/telegram-bot/.env) | runtime env | ignored, не tracked | `bot.py`, `rag_client.py`, `fetch_invoices.py`, `find_topics.py`, `monitor_bot.py`, тесты | высокий |
| [VK-offee/.github/scripts/credentials.json](/Users/alexander/Github/VK-offee/.github/scripts/credentials.json) | Google OAuth client credentials | ignored, не tracked | Google Drive/Sheets sync scripts | высокий |
| [VK-offee/.github/scripts/token.pickle](/Users/alexander/Github/VK-offee/.github/scripts/token.pickle) | Google OAuth access token | ignored, не tracked | Google sync scripts | высокий |
| [VK-offee/.github/scripts/token_upload.pickle](/Users/alexander/Github/VK-offee/.github/scripts/token_upload.pickle) | Google OAuth access token | ignored, не tracked | upload/sync scripts | высокий |

### 2. Репозитории и tracked/non-tracked status

Подтверждено через `git ls-files` и `git check-ignore`:

- [VK-offee-rag/.env.example](/Users/alexander/Github/VK-offee-rag/.env.example) — tracked
- [creativ-convector/.env.example](/Users/alexander/Github/creativ-convector/.env.example) — tracked
- [FMT-exocortex-template/.claude/settings.json](/Users/alexander/Github/FMT-exocortex-template/.claude/settings.json) — tracked
- [VK-offee/telegram-bot/.env](/Users/alexander/Github/VK-offee/telegram-bot/.env) — ignored, not tracked
- [VK-offee-rag/.env](/Users/alexander/Github/VK-offee-rag/.env) — ignored, not tracked
- [VK-offee/.github/scripts/credentials.json](/Users/alexander/Github/VK-offee/.github/scripts/credentials.json) — ignored, not tracked
- [VK-offee/.github/scripts/token.pickle](/Users/alexander/Github/VK-offee/.github/scripts/token.pickle) — ignored, not tracked
- [VK-offee/.github/scripts/token_upload.pickle](/Users/alexander/Github/VK-offee/.github/scripts/token_upload.pickle) — ignored, not tracked

### 3. Какие секреты реально используются в коде

| Секрет / группа | Где используется | Контур |
|---|---|---|
| `OPENAI_API_KEY` | `VK-offee-rag/src/*.py`, `VK-offee/plannings/*.py`, `DS-strategy/tools/fpf-consult.sh`, `creativ-convector` scripts/workflows | OpenAI API / embeddings / summarization |
| `ANTHROPIC_API_KEY` | `VK-offee-rag/src/query.py`, `creativ-convector` workflows/scripts, token-monitor/docs | Anthropic/Claude API |
| `TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID` | `FMT` synchronizer/strategist/extractor scripts, `DS-strategy` workflows/tools, `VK-offee` bots | Telegram transport / monitor / alerts |
| `SABY_EMAIL`, `SABY_PASSWORD`, `SABY_APP_CLIENT_ID`, `SABY_APP_SECRET`, `SABY_SECRET_KEY` | `VK-offee/saby-integration/*` | Saby integration |
| `WAKATIME_API_KEY` | `FMT` strategist/synchronizer scripts | WakaTime collection |
| Google OAuth (`credentials.json`, `token.pickle`, `token_upload.pickle`) | `VK-offee/.github/scripts/*sync*` | Drive / Sheets sync |

### 4. Подтверждённые места многослойного хранения

Один и тот же operational контур опирается сразу на несколько слоёв:

- локальные `.env`
- `~/.config/aist/env`
- GitHub Actions secrets
- локальные `.claude/settings.json`
- OAuth-файлы в `VK-offee/.github/scripts/`

Это подтверждает главный структурный риск: нет единого source-of-truth для секретов и auth-layer.

### 5. Документация и примеры, требующие различения

Есть два типа docs:

1. **Sanitized/placeholder docs** — допустимы, но не являются runtime-risk сами по себе
   - [VK-offee/БЕЗОПАСНОСТЬ API КЛЮЧИ В GIT.md](/Users/alexander/Github/VK-offee/%D0%91%D0%95%D0%97%D0%9E%D0%9F%D0%90%D0%A1%D0%9D%D0%9E%D0%A1%D0%A2%D0%AC%20API%20%D0%9A%D0%9B%D0%AE%D0%A7%D0%98%20%D0%92%20GIT.md)
   - [VK-offee/СРОЧНО СМЕНИТЬ ТОКЕНЫ.md](/Users/alexander/Github/VK-offee/%D0%A1%D0%A0%D0%9E%D0%A7%D0%9D%D0%9E%20%D0%A1%D0%9C%D0%95%D0%9D%D0%98%D0%A2%D0%AC%20%D0%A2%D0%9E%D0%9A%D0%95%D0%9D%D0%AB.md)
   - [VK-offee/telegram-bot/КАК ДОБАВИТЬ OPENAI КЛЮЧ.md](/Users/alexander/Github/VK-offee/telegram-bot/%D0%9A%D0%90%D0%9A%20%D0%94%D0%9E%D0%91%D0%90%D0%92%D0%98%D0%A2%D0%AC%20OPENAI%20%D0%9A%D0%9B%D0%AE%D0%A7.md)

2. **Docs, которые всё ещё задают опасные практики**
   - [VK-offee/telegram-bot/deploy.sh](/Users/alexander/Github/VK-offee/telegram-bot/deploy.sh) содержит места для ручной вставки ключей
   - [GIT-PUSH-SOLUTION.md](/Users/alexander/Github/VK-offee/GIT-PUSH-SOLUTION.md) содержит примеры `ghp_...`

### 6. Truthful исторический статус

- Быстрый текущий `git log --all -- telegram-bot/.env` в локальном срезе не показал path-history для этого файла.
- Это **не отменяет** ранее зафиксированный риск старых утечек; это значит, что перед решением о rewrite history нужно отдельно перепроверить историю по конкретным путям и коммитам более узким forensic-pass.

### 7. Текущий truthful вывод по ENG.WP.007

Что уже есть:

- фактическая карта основных secret stores;
- подтверждение tracked / ignored статуса ключевых локальных файлов;
- подтверждение многослойного хранения и auth fragmentation.

Что ещё не закрыто:

- GitHub Secrets inventory в новых приватных репозиториях;
- ротация по сервисам;
- smoke test после ротации;
- итоговые `security-migration-audit-report.md`, `rotation-runbook.md`, `residual-risks.md`.

### 8. Findings from live inspection (2026-04-07)

Подтверждено дополнительной live-проверкой:

- `remote.origin.url` в ключевых репозиториях сейчас без токенов в URL:
  - `VK-offee`, `VK-offee-rag`, `DS-strategy`, `DS-agent-workspace`, `FMT-exocortex-template`, `creativ-convector`, `agency-agents`
  - формат: `https://github.com/AlexPoAi/<repo>.git`
- `PACK-iwe-culture` сейчас без `origin`; это не секрет-риск, но это operational gap для репозитория из scope.
- `VK-offee/telegram-bot/.env`, `VK-offee-rag/.env`, `VK-offee/.github/scripts/credentials.json`, `token.pickle`, `token_upload.pickle`:
  - не tracked
  - ignored
  - остаются high-risk runtime stores, но не подтверждены как текущая утечка через git.
- В локальном `~/Github/.claude/settings.json` были подтверждены literal Telegram bot token values в allow-list командах `curl .../getUpdates`.
- В `VK-offee/GIT-PUSH-SOLUTION.md` были подтверждены опасные doc patterns:
  - пример `ghp_...`
  - `Authorization: token ...`
  - старый repo namespace `alexpoaiagent-sudo/...`

### 9. Applied hardening during ENG.WP.007 (2026-04-07)

В рамках этого цикла уже выполнено:

- Санитизирован [VK-offee/GIT-PUSH-SOLUTION.md](/Users/alexander/Github/VK-offee/GIT-PUSH-SOLUTION.md):
  - `ghp_...` заменён на env-based `GITHUB_TOKEN`
  - `Authorization: token` заменён на `Authorization: Bearer`
  - старый namespace `alexpoaiagent-sudo/...` заменён на `AlexPoAi/...`
- Санитизирован локальный [/.claude/settings.json](/Users/alexander/Github/.claude/settings.json):
  - literal Telegram bot token удалён из allow-list команд
  - команды переведены на env-based форму `bot$TELEGRAM_BOT_TOKEN/...`
  - удалён allow-list entry с push через token-in-URL и старый namespace; заменён на `git push origin main`

### 10. Residual risks after this slice

После выполненных правок всё ещё остаются открытые риски:

- секреты по-прежнему хранятся в нескольких runtime-контурах без единого source-of-truth;
- не проведена ротация Telegram/OpenAI/Anthropic/Google/Saby;
- не проверены GitHub Secrets в новых приватных репозиториях;
- не проведён отдельный forensic-pass по старому GitHub-источнику и истории старых публичных репозиториев;
- локальный `.claude/settings.json` остаётся high-risk config surface, даже после удаления literal token values.

---

## Rotation Runbook (безопасный порядок ротации)

Ниже — практический порядок ротации, выстроенный так, чтобы не уронить экосистему.

### Принцип

- ротируем по одному контуру;
- после каждой ротации делаем smoke test;
- не делаем mass rotation;
- не чистим историю git до окончания ротации и стабилизации.

### Wave 1 — Telegram

**Что ротировать**

- `TELEGRAM_BOT_TOKEN`
- `TELEGRAM_CHAT_ID` — не секрет в том же классе, но проверить актуальность маршрутов

**Где обновлять**

- `~/.config/aist/env`
- `VK-offee/telegram-bot/.env`
- GitHub Actions secrets в `DS-strategy` / `FMT-exocortex-template` / других репо, где есть Telegram workflows
- локальные config/routes, если ещё есть fallback paths

**Почему первая волна**

- Telegram-канал самый видимый для операционной обратной связи;
- старые утечки исторически касались именно Telegram token;
- smoke test простой и быстрый.

**Smoke test**

- `notify.sh synchronizer health-check`
- `notify.sh synchronizer day-close`
- `VK-offee` bot `/start` или минимальный ping

### Wave 2 — OpenAI / Anthropic

**Что ротировать**

- `OPENAI_API_KEY`
- `ANTHROPIC_API_KEY`

**Где обновлять**

- `VK-offee-rag/.env`
- `VK-offee/telegram-bot/.env`
- `creativ-convector` runtime `.env` / GitHub Actions secrets
- `DS-strategy/tools/fpf-consult.sh` depends on env source

**Почему вторая волна**

- это влияет на RAG, AI enrichment и часть консультационных инструментов;
- но легче изолируется, чем Google OAuth.

**Smoke test**

- `VK-offee-rag` health/query
- `VK-offee` bot с AI-сценарием
- `creativ-convector` AI workflow smoke

### Wave 3 — Google OAuth

**Что ротировать / переподнимать**

- `credentials.json` — только если есть подозрение на компрометацию client credentials
- `token.pickle`
- `token_upload.pickle`

**Где обновлять**

- `VK-offee/.github/scripts/credentials.json`
- `VK-offee/.github/scripts/token.pickle`
- `VK-offee/.github/scripts/token_upload.pickle`

**Почему третья волна**

- это высокорисковый operational контур;
- при неудачной ротации ломаются Drive / Sheets sync.

**Smoke test**

- один sync Google Drive
- один sync Google Sheets
- один upload scenario

### Wave 4 — Saby

**Что ротировать**

- `SABY_EMAIL`
- `SABY_PASSWORD`
- `SABY_APP_CLIENT_ID`
- `SABY_APP_SECRET`
- `SABY_SECRET_KEY`

**Где обновлять**

- runtime `.env` / локальный env-layer, который реально читает `saby_scraper.py` и `test_connection.py`

**Почему четвёртая волна**

- это изолированный контур;
- не является центральным нервом экосистемы;
- но содержит чувствительные учётные данные.

**Smoke test**

- `test_connection.py`
- один минимальный сценарий `saby_scraper.py`

### Wave 5 — GitHub access / repo tokens / secrets hygiene

**Что ротировать**

- PAT / repo-specific tokens / service tokens, если ещё используются
- GitHub Actions secrets, где есть исторический риск или старые токены

**Где обновлять**

- GitHub account / repo secrets
- credential helper / `gh auth` / local remotes

**Smoke test**

- `git fetch`
- `git push`
- один Actions workflow manual re-run

---

## Residual Risks (после текущего среза)

Даже после выполнения runbook останутся риски, которые нужно признать отдельно:

1. **История git**
   - старые секреты могли остаться в исторических коммитах и форках/клонах

2. **Локальный `.claude/settings.json`**
   - это не versioned source-of-truth, но всё ещё чувствительный слой локальной среды

3. **Многослойность**
   - даже после ротации нужно решить архитектурно, где канонически живут secrets:
     - `.env`
     - `~/.config/aist/env`
     - GitHub secrets
     - OAuth files

4. **Опасные docs/patterns**
   - часть документации всё ещё учит ручной вставке ключей или содержит risky examples

---

## Truthful следующий шаг

ENG.WP.007 после этого обновления находится в состоянии:

- **audit substantially progressed**
- **rotation plan defined**
- **implementation not yet executed**

Чтобы закрыть WP, следующим отдельным циклом нужно:

1. пройти `Wave 1` и `Wave 2`;
2. сделать smoke tests;
3. оформить `security-migration-audit-report.md` и `residual-risks.md`;
4. затем решать, нужен ли отдельный forensic/history pass.

---

## Fact Update — Wave 1 (Telegram) выполнен частично и подтверждён

### Что выполнено

- локальный operational Telegram layer использует новый актуальный token через `~/.config/aist/env`
- cloud repo secrets заведены в:
  - `AlexPoAi/DS-strategy`
  - `AlexPoAi/FMT-exocortex-template`
- установлены repo secrets:
  - `TELEGRAM_BOT_TOKEN`
  - `TELEGRAM_CHAT_ID`

### Что проверено

- `notify.sh synchronizer day-close` → сообщение отправлено успешно
- `Telegram Bot API getMe` → `HTTP 200`, bot identity валидна
- `gh secret list --repo` подтвердил наличие secrets в двух repo-level cloud контурах

### Truthful статус Wave 1

- **local Telegram route** — зелёный
- **cloud Telegram route (DS-strategy/FMT)** — secrets заведены
- **VK-offee product bot route** — token в локальном `.env` присутствует, но полноценный product smoke test ещё не зафиксирован в этом WP

### Что остаётся по Telegram

- при необходимости дополнительно прогнать product smoke test `VK-offee` bot
- отдельно решить, нужно ли заводить Telegram secrets в других repo-level или достаточно двух cloud репозиториев

---

## Критерии завершения

- Все целевые репозитории на новом аккаунте приватные
- Локальные remotes переведены на новый аккаунт без токенов в URL
- Критичные секреты ротированы или признаны безопасными по результатам инспекции
- Автоматизации проходят smoke test после миграции
- Зафиксирован остаточный риск и решение по истории git

---

## Handoff for Implementation

### Цель для агента-исполнителя

После завершения миграции на новый GitHub-аккаунт провести полную post-migration инспекцию безопасности экосистемы, затем поэтапно устранить уязвимости без разрушения текущих автоматизаций.

### Обязательный порядок действий

1. Read-only audit нового аккаунта и локальных remotes
2. Инвентаризация всех секретов и каналов авторизации
3. Проверка visibility, collaborators, GitHub Apps, Actions permissions
4. Ротация секретов по одному сервису
5. Smoke test после каждой ротации
6. Санитизация документации и локальных конфигов
7. Решение по rewrite history только в самом конце

### Что проверить в первую очередь

- `VK-offee`
- `VK-offee-rag`
- `DS-strategy`
- `DS-agent-workspace`
- `FMT-exocortex-template`
- `creativ-convector`

### Критичные места хранения секретов

- `~/Github/.claude/settings.json`
- `~/.config/aist/env`
- `VK-offee/telegram-bot/.env`
- `VK-offee-rag/.env`
- `VK-offee/.github/scripts/credentials.json`
- `VK-offee/.github/scripts/token.pickle`
- `VK-offee/.github/scripts/token_upload.pickle`
- GitHub Actions secrets в новых репозиториях

### Подтверждённые риски, которые нельзя игнорировать

- Старые утечки в истории `VK-offee`
- Публичность ключевых репозиториев до миграции
- Прямой Telegram token в локальном `~/Github/.claude/settings.json`
- Многослойное хранение одних и тех же секретов в разных runtime-контурах

### Ожидаемые выходные артефакты

- `security-migration-audit-report.md`
- `rotation-runbook.md`
- `residual-risks.md`
- `secret-inventory.md` или `.csv`

### Ограничения исполнения

- Не выполнять массовую ротацию “одним махом”
- Не переписывать историю git до завершения миграции и стабилизации нового контура
- Не удалять рабочие локальные secret stores без проверки зависимых сервисов
- Не ломать cloud/local scheduler, Telegram notifications, Drive/Sheets sync, RAG, bot deploy
