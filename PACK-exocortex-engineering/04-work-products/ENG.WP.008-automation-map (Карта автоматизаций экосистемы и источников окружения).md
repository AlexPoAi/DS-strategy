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

### Инженерное правило

При любой работе с автоматизациями сначала определять:

1. runtime source-of-truth для `env`
2. точку запуска
3. smoke test после изменения

---

## Что ещё нужно дозаполнить

- полный перечень GitHub Actions по всем репозиториям
- перечень launchd plist и их фактический статус
- карта cron/ручных scheduler-контуров, если они есть
- соответствие `секрет -> automation -> repo -> smoke test`
- владелец каждого критичного automation-path

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
