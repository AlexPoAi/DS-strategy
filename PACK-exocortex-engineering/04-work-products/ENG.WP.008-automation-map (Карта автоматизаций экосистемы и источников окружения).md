---
type: engineering-work-product
wp_id: ENG.WP.008
title: Карта автоматизаций экосистемы и источников окружения
date: 2026-04-05
status: active
priority: high
linked_inbox: ENGINEERING
author: Environment Engineer (Codex)
---

# ENG.WP.008 — Карта автоматизаций экосистемы и источников окружения

## Контекст

Экосистема разрослась до нескольких репозиториев, локальных runtime-контуров и облачных автоматизаций. Входящему агенту трудно быстро понять, что именно автоматизировано, где живут точки запуска, откуда берутся переменные окружения и какие контуры нельзя ломать при миграции, ротации ключей и инфраструктурных изменениях.

Цель этого WP — создать живую инженерную карту автоматизаций экосистемы, чтобы любой агент мог быстро увидеть сквозную схему запуска, зависимости, источники окружения и критичные пути.

---

## Назначение документа

Этот документ отвечает на четыре вопроса:

1. Что в экосистеме запускается автоматически
2. Где именно находится точка запуска
3. Откуда конкретный контур берёт `env` и секреты
4. Что сломается, если менять этот контур

---

## Как читать карту

Для каждой автоматизации фиксируются:

- `Контур` — репозиторий или системный слой
- `Тип запуска` — GitHub Actions / launchd / shell / bot / локальный watcher
- `Точка запуска` — конкретный файл, workflow или скрипт
- `Источник env` — `.env`, GitHub Secrets, `~/.config/...`, системный credential store и т.д.
- `Зависимости` — внешние сервисы и соседние репозитории
- `Выход` — куда пишет результаты
- `Критичность` — насколько опасно ломать этот контур
- `Примечание` — важный operational context

---

## Текущая карта контуров

| Контур | Тип запуска | Точка запуска | Источник env | Основные зависимости | Выход | Критичность | Примечание |
|---|---|---|---|---|---|---|---|
| `DS-strategy` | governance / coordination | inbox, session context, close-flow | локальный git, локальная среда, возможно GitHub auth | `FMT-exocortex-template`, Pack'и, локальные скрипты | контекст, inbox, инженерные WP | Высокая | Governance-ядро, нельзя ломать без влияния на всю экосистему |
| `FMT-exocortex-template` | launchd + shell automation | `roles/*/scripts`, `scheduler.sh`, `strategist.sh`, `extractor.sh` | локальная среда, `~/.config/...`, возможные GitHub secrets | `DS-strategy`, файловая система, Telegram, локальные watcher'ы | заметки, алерты, служебные артефакты | Очень высокая | Базовый execution-layer экзокортекса |
| `VK-offee` | bot + local scripts + sync | `telegram-bot/*`, `.github/scripts/*` | `telegram-bot/.env`, Google OAuth files, внешние env | Telegram, Google Drive, Google Sheets, RAG/API | ответы бота, синхронизация знаний | Очень высокая | Source-of-truth домена + живой бот |
| `VK-offee-rag` | local/backend service | runtime app / API слой | `.env` | `VK-offee`, векторный индекс, LLM/API | RAG API и поиск | Высокая | Инструментальный слой доступа к Pack |
| `creativ-convector` | workflows + processing | repo scripts / GitHub Actions | `.env.example` как шаблон, реальные secrets вне git | `VK-offee`, заметки, AI APIs | извлечённые/обработанные материалы | Средняя/высокая | Downstream-контур, нельзя разорвать source-of-truth связь |
| `DS-agent-workspace` | agent artifact bus | manual/agent-driven | зависит от локальной среды агента | агенты, `DS-strategy` | артефакты выполнения | Средняя | Не главный runtime, но важен для handoff |

---

## Подтверждённые automation-точки

### GitHub Actions

| Репозиторий | Workflow | Точка запуска | Источники env / secrets | Что делает | Критичность |
|---|---|---|---|---|---|
| `FMT-exocortex-template` | `cloud-scheduler.yml` | [cloud-scheduler.yml](/Users/alexander/Github/FMT-exocortex-template/.github/workflows/cloud-scheduler.yml) | `STRATEGY_REPO`, `HEALTH_CHECK_REPOS`, `BOT_HEALTH_URL`, `STRATEGY_REPO_TOKEN` | backup memory → exocortex, health-report по нескольким репо | Очень высокая |
| `FMT-exocortex-template` | `notify-update.yml` | [notify-update.yml](/Users/alexander/Github/FMT-exocortex-template/.github/workflows/notify-update.yml) | `BOT_WEBHOOK_URL`, `TEMPLATE_WEBHOOK_SECRET` | ежедневный дайджест изменений шаблона через bot webhook | Средняя |
| `FMT-exocortex-template` | `validate-template.yml` | [validate-template.yml](/Users/alexander/Github/FMT-exocortex-template/.github/workflows/validate-template.yml) | GitHub runner env | CI-валидация шаблона, контроль hardcoded paths/placeholders | Средняя |
| `DS-strategy` | `cloud-scheduler.yml` | [cloud-scheduler.yml](/Users/alexander/Github/DS-strategy/.github/workflows/cloud-scheduler.yml) | `BOT_HEALTH_URL`, `TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID` | nightly health-check экзокортекса + Telegram отчёт | Высокая |
| `creativ-convector` | `obsidian-ai-pr.yml` | [obsidian-ai-pr.yml](/Users/alexander/Github/creativ-convector/.github/workflows/obsidian-ai-pr.yml) | `OPENAI_API_KEY`, `ANTHROPIC_API_KEY` | ручной AI enrichment заметок и PR | Средняя |

### Локальные launchd / shell automation

| Репозиторий | Контур | Точка запуска | Источник env | Что делает | Выход | Критичность |
|---|---|---|---|---|---|---|
| `FMT-exocortex-template` | scheduler | [roles/synchronizer/scripts/scheduler.sh](/Users/alexander/Github/FMT-exocortex-template/roles/synchronizer/scripts/scheduler.sh) | локальная shell-среда, шаблонные пути `{{WORKSPACE_DIR}}`, локальные git credentials | диспетчер strategist/extractor/synchronizer задач | state markers, logs, git push/pull | Очень высокая |
| `FMT-exocortex-template` | health-check | [roles/synchronizer/scripts/health-check.sh](/Users/alexander/Github/FMT-exocortex-template/roles/synchronizer/scripts/health-check.sh) | `~/.config/aist/env`, launchctl, локальные state dirs | проверка здоровья агентов, auth-helper, scheduler, статусов | macOS notify, Telegram notify, logs | Очень высокая |
| `FMT-exocortex-template` | strategist | [roles/strategist/scripts/strategist.sh](/Users/alexander/Github/FMT-exocortex-template/roles/strategist/scripts/strategist.sh) | `~/.claude/projects/...`, `CLAUDE_PATH`, git auth | сценарии day-plan/session-prep/week-review/note-review | изменения в `DS-strategy`, push в git, локальные логи | Очень высокая |
| `FMT-exocortex-template` | extractor | [roles/extractor/scripts/extractor.sh](/Users/alexander/Github/FMT-exocortex-template/roles/extractor/scripts/extractor.sh) | `~/.config/aist/env`, `~/.claude/settings.json`, `anthropic_auth_helper.sh` | inbox-check, session-import, session-tasks и другие KE-сценарии | extraction reports, задачи, git commit/push в `DS-strategy` | Очень высокая |
| `FMT-exocortex-template` | session watcher | [roles/extractor/scripts/session-watcher.sh](/Users/alexander/Github/FMT-exocortex-template/roles/extractor/scripts/session-watcher.sh) | чистая launchd-среда | следит за `pending-sessions`, запускает import + tasks | перенос файлов в processed, chain-report | Высокая |
| `FMT-exocortex-template` | launchd plists | `roles/*/scripts/launchd/*.plist` | launchd | расписание strategist/extractor/scheduler/health-check | запуск shell-скриптов по графику | Очень высокая |
| `VK-offee` | monitor bot | [telegram-bot/start_monitor.sh](/Users/alexander/Github/VK-offee/telegram-bot/start_monitor.sh) | `~/.config/aist/env` | запуск монитора экзокортекса в Telegram | polling-бот, сообщения | Средняя |
| `VK-offee` | Telegram bot runtime | [telegram-bot/bot.py](/Users/alexander/Github/VK-offee/telegram-bot/bot.py) | `telegram-bot/.env` через `load_dotenv()` | ответы сотрудникам через RAG | Telegram polling, `bot.log` | Очень высокая |
| `VK-offee` | Google Drive sync | [auto-sync.sh](/Users/alexander/Github/VK-offee/.github/scripts/auto-sync.sh) | локальная shell-среда, git auth | запуск `sync_google_drive_v2.py`, auto-commit/push изменений | обновление `knowledge-base`, git commit/push | Высокая |
| `VK-offee` | Drive importer | [sync_google_drive.py](/Users/alexander/Github/VK-offee/.github/scripts/sync_google_drive.py) | `GOOGLE_DRIVE_FOLDER_ID`, `credentials.json`, `token.pickle` | импорт документов из Drive | файлы в `knowledge-base`, sync report | Высокая |
| `VK-offee` | Sheets importer | [sync-google-sheets.py](/Users/alexander/Github/VK-offee/.github/scripts/sync-google-sheets.py) | `credentials.json`, `token.pickle`, hardcoded folder id | импорт всех Google Sheets в CSV | CSV-файлы в `knowledge-base` | Высокая |
| `VK-offee` | Saby scraper | [saby_scraper.py](/Users/alexander/Github/VK-offee/saby-integration/saby_scraper.py) | `.env` через `load_dotenv()` | веб-автоматизация Saby Presto | html, screenshots, извлечённые данные | Средняя |
| `VK-offee-rag` | RAG API | [src/api.py](/Users/alexander/Github/VK-offee-rag/src/api.py) | `.env` через `load_dotenv()` | localhost API для поиска и ответа | FastAPI на `127.0.0.1`, `/health`, `/query` | Очень высокая |
| `creativ-convector` | session launcher | [начать-сессию.sh](/Users/alexander/Github/creativ-convector/%D0%BD%D0%B0%D1%87%D0%B0%D1%82%D1%8C-%D1%81%D0%B5%D1%81%D1%81%D0%B8%D1%8E.sh) | локальная python-среда | запуск стратегической сессии | manual workflow / локальный run | Низкая/средняя |

---

## Критичные автоматизации для детализации

### 1. Стратег экзокортекса

- Репозиторий: `FMT-exocortex-template`
- Предполагаемые точки запуска:
  - `roles/strategist/scripts/strategist.sh`
  - `roles/synchronizer/scripts/scheduler.sh`
- Предполагаемые источники env:
  - локальная shell-среда
  - launchd plist
  - внешние env-файлы
- Риск:
  - поломка day-to-day orchestration
  - потеря регулярных проходов по контексту и задачам

### 2. Extractor / session watcher / inbox-check

- Репозиторий: `FMT-exocortex-template`
- Точки запуска:
  - `roles/extractor/scripts/extractor.sh`
  - `roles/extractor/scripts/session-watcher.sh`
  - `roles/extractor/scripts/launchd/*.plist`
- Риск:
  - потеря импорта заметок
  - разрыв захвата материалов в Pack/экзокортекс

### 3. Telegram bot VK-offee

- Репозиторий: `VK-offee`
- Точки запуска:
  - `telegram-bot/bot.py`
  - `telegram-bot/start_monitor.sh`
- Источники env:
  - `telegram-bot/.env`
  - возможно `~/.config/aist/env`
- Риск:
  - бот перестаёт отвечать
  - пропадает operational access к базе знаний

### 4. Google Drive / Sheets sync

- Репозиторий: `VK-offee`
- Точки запуска:
  - `.github/scripts/sync_google_drive.py`
  - `.github/scripts/sync_google_drive_v2.py`
  - `.github/scripts/sync-google-sheets.py`
  - `.github/scripts/upload_to_google_drive.py`
- Источники env и auth:
  - `credentials.json`
  - `token.pickle`
  - `token_upload.pickle`
  - возможные folder ids / env vars
- Риск:
  - остановка синхронизации знаний и рабочих документов

### 5. Post-migration security workflows

- Репозиторий: `DS-strategy`
- Связанный WP:
  - `ENG.WP.007`
- Риск:
  - при неверной ротации можно сломать все вышестоящие контуры

---

## Источники окружения и секретов

### Подтверждённые слои

- локальные `.env` файлы внутри репозиториев
- `~/.config/aist/env`
- `~/Github/.claude/settings.json`
- GitHub Actions secrets
- OAuth-файлы Google (`credentials.json`, `token.pickle`, `token_upload.pickle`)
- системные credential helpers (`git`, `osxkeychain`, `gh`)

### Подтверждённые соответствия `automation -> env`

| Automation | Основной env/source-of-truth | Комментарий |
|---|---|---|
| `FMT strategist` | `~/.claude/projects/...` + `CLAUDE_PATH` + локальный git auth | не завязан на repo-local `.env` |
| `FMT extractor` | `~/.config/aist/env`, `~/.claude/settings.json`, auth helper | самый чувствительный к локальной машине контур |
| `FMT health-check` | `~/.config/aist/env` | использует Telegram токен и chat id для алертов |
| `DS-strategy cloud-scheduler` | GitHub Actions secrets + repo variables | облачный слой, не зависит от launchd |
| `VK-offee Telegram bot` | `VK-offee/telegram-bot/.env` | bot runtime source-of-truth |
| `VK-offee monitor bot` | `~/.config/aist/env` | отдельный телеграм-контур, не тот же слой что `.env` бота |
| `VK-offee Google Drive/Sheets sync` | `credentials.json`, `token.pickle`, `token_upload.pickle`, локальный git auth | после синка может делать commit/push |
| `VK-offee-rag API` | `VK-offee-rag/.env` | localhost-only сервис для основного бота |
| `creativ-convector AI PR` | GitHub Actions secrets | ручной workflow_dispatch |

### Инженерное правило

При любой работе с автоматизациями сначала определять:

1. runtime source-of-truth для `env`
2. точку запуска
3. smoke test после изменения

---

## Что ещё нужно дозаполнить

- перечень launchd plist и их фактический статус
- карта cron/ручных scheduler-контуров, если они есть
- соответствие `секрет -> automation -> repo -> smoke test`
- владелец каждого критичного automation-path
- status/health endpoints и smoke-test команды по каждому критичному контуру

---

## Critical dependency paths

### Нельзя ломать без отдельной проверки

- `FMT-exocortex-template -> roles/synchronizer/scripts/scheduler.sh -> roles/strategist/scripts/strategist.sh`
- `FMT-exocortex-template -> roles/extractor/scripts/extractor.sh -> DS-strategy/inbox/*`
- `FMT-exocortex-template -> roles/synchronizer/scripts/health-check.sh -> Telegram notify`
- `DS-strategy -> .github/workflows/cloud-scheduler.yml -> Telegram`
- `VK-offee -> telegram-bot/bot.py -> VK-offee-rag/src/api.py`
- `VK-offee -> .github/scripts/auto-sync.sh -> git commit/push`
- `VK-offee -> sync_google_drive.py / sync-google-sheets.py -> Google OAuth files`

### Смежные риски

- один и тот же Telegram контур использует несколько storage layers
- часть automation работает локально, часть в GitHub Actions
- часть сценариев сама делает `git push`, что увеличивает риск непредсказуемых side effects
- миграция аккаунта и ротация секретов могут затронуть сразу несколько automation-path

---

## Use Case для входящего агента

Если агент заходит в экосистему и ему нужно понять automation-landscape, он должен:

1. Открыть этот WP
2. Определить нужный контур
3. Найти точку запуска и источник env
4. Проверить связанные WP и failure-modes
5. Только потом менять automation или секреты

---

## Связанные инженерные артефакты

- `ENG.WP.005` — semantics scheduler/strategist
- `ENG.WP.006` — auth failure detector и Telegram path
- `ENG.WP.007` — постмиграционная инспекция безопасности
- `ENG.FM.001` — типовые инциденты экзокортекса

---

## Статус

Документ открыт как living map и должен дозаполняться по мере аудита всех automation-контуров.
