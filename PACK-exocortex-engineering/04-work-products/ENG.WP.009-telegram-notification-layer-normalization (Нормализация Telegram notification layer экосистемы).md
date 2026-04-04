---
type: engineering-work-product
wp_id: ENG.WP.009
title: Нормализация Telegram notification layer экосистемы
date: 2026-04-05
status: active
priority: high
linked_inbox: ENGINEERING
author: Environment Engineer (Codex)
---

# ENG.WP.009 — Нормализация Telegram notification layer экосистемы

## Контекст

В экосистеме существует несколько независимых Telegram-контуров:

- агентские уведомления через `notify.sh`
- health-check и operational alerts
- отчёты `daily-telegram` / token-report
- облачные GitHub Actions отчёты
- отдельные доменные боты, включая `VK-offee`

Исторически эти контуры росли не как единая система, а как набор локальных решений. Из-за этого:

- разные скрипты берут Telegram env из разных источников
- часть сценариев работает только при уже экспортированных переменных
- нет единой схемы уровней уведомлений
- сложно понять, какой Telegram-контур является source-of-truth для какого класса сообщений

Точечный симптом, который вскрыл проблему 05.04:
- `DS-strategy/tools/send-token-report.sh` не загружал `~/.config/aist/env`, из-за чего token-report не отправлялся в Telegram, хотя сам токен существовал в env-layer

---

## Цель WP

Собрать и нормализовать весь Telegram notification layer экосистемы так, чтобы:

1. каждый notification-script использовал понятный source-of-truth для env
2. было ясно, какой контур шлёт какие типы сообщений
3. critical alerts не смешивались с шумом
4. каждый путь имел smoke test и predictable fallback

---

## Scope

### Контуры, входящие в WP

- `FMT-exocortex-template/roles/synchronizer/scripts/notify.sh`
- `FMT-exocortex-template/roles/synchronizer/scripts/health-check.sh`
- `FMT-exocortex-template/roles/synchronizer/scripts/daily-telegram-report.sh`
- `FMT-exocortex-template/roles/strategist/scripts/strategist.sh`
- `FMT-exocortex-template/roles/extractor/scripts/extractor.sh`
- `DS-strategy/tools/send-token-report.sh`
- `DS-strategy/.github/workflows/cloud-scheduler.yml`
- смежно: `VK-offee/telegram-bot/*` как отдельный продуктовый Telegram-контур

### Вне scope

- пользовательские сценарии самого `VK-offee` knowledge-bot
- UX/меню телеграм-ботов
- ротация Telegram токена как security-задача

---

## Что нужно нормализовать

### 1. Source-of-truth для env

Для каждого скрипта зафиксировать:

- читает ли он `~/.config/aist/env`
- ожидает ли уже экспортированные env vars
- использует ли GitHub Actions secrets
- зависит ли от локального `.env`

### 2. Классы уведомлений

Нужно различить как минимум:

- `critical alerts`
  - auth failure
  - агент не запускается
  - health-check красный
- `operational reports`
  - daily telegram report
  - token usage report
  - cloud health report
- `info/noise`
  - некритичные completion/success уведомления

### 3. Каналы доставки

Проверить:

- chat id
- topic/thread id, если используется
- единый ли это Telegram-чат для всей инженерки
- нужно ли развести alert/report каналы

### 4. Smoke tests

Для каждого контура нужен короткий тест:

- как вручную воспроизвести отправку
- какой ожидаемый output/log
- как понять, что контур исправен

---

## Подтверждённые симптомы

- `send-token-report.sh` не отправлял отчёт из-за отсутствия загрузки env-layer
- `daily-telegram` ранее падал из-за `TELEGRAM_CHAT_ID`
- `notify.sh` уже ломался из-за path drift
- notification layer частично распределён между local shell env, `~/.config/aist/env` и GitHub Actions secrets

---

## Первичный inventory Telegram notification paths

| Script / path | Репозиторий | Класс сообщений | Источник env | Target | Текущий риск | Комментарий для нормализации |
|---|---|---|---|---|---|---|
| `roles/synchronizer/scripts/notify.sh` | `FMT-exocortex-template` | operational + alerts | `TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID`, optional `TELEGRAM_MESSAGE_THREAD_ID` из локальной среды | инженерный Telegram-чат | Высокий | Нужен как основной общий transport-layer для локальных агентов |
| `roles/synchronizer/scripts/health-check.sh` | `FMT-exocortex-template` | critical alerts + health summary | `~/.config/aist/env` | инженерный Telegram-чат | Средний | Уже использует env-layer корректно, но должен быть согласован по формату с `notify.sh` |
| `roles/synchronizer/scripts/daily-telegram-report.sh` | `FMT-exocortex-template` | daily operational report | `~/.config/exocortex/telegram-token`, `~/.config/exocortex/telegram-chat-id` | инженерный Telegram-чат | Высокий | Отдельный storage layer, конфликтует с `~/.config/aist/env` |
| `roles/synchronizer/scripts/unprocessed-notes-check.sh` | `FMT-exocortex-template` | operational warning | `~/.config/exocortex/telegram-token`, `~/.config/exocortex/telegram-chat-id` | инженерный Telegram-чат | Высокий | Использует тот же альтернативный storage layer, требует унификации |
| `roles/strategist/scripts/strategist.sh` → `notify_telegram()` | `FMT-exocortex-template` | scenario completion + auth alert | через `notify.sh`, плюс прямой fallback alert через `TELEGRAM_BOT_TOKEN`/`TELEGRAM_CHAT_ID` | инженерный Telegram-чат | Средний/высокий | Сейчас смешаны два пути: через `notify.sh` и прямой `curl` |
| `roles/extractor/scripts/extractor.sh` → `notify_telegram()` | `FMT-exocortex-template` | scenario completion + auth alert | через `notify.sh` | инженерный Telegram-чат | Средний | Лучше оставить единый outbound путь только через `notify.sh` |
| `.github/workflows/cloud-scheduler.yml` | `DS-strategy` | cloud health report | GitHub Actions secrets `TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID` | инженерный Telegram-чат | Средний | Облачный контур, не должен зависеть от локальных env |
| `tools/send-token-report.sh` | `DS-strategy` | token usage report | `~/.config/aist/env` | инженерный Telegram-чат | Средний | Уже починен, теперь использует тот же env-layer, что и локальные alerts |
| `.github/workflows/cloud-scheduler.yml` | `FMT-exocortex-template` | cloud health / backup report | GitHub Actions secrets `TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID` | инженерный Telegram-чат | Средний | Тоже облачный слой, должен быть описан отдельно от local automation |
| `.github/workflows/notify-update.yml` | `FMT-exocortex-template` | template update broadcast | `BOT_WEBHOOK_URL`, `TEMPLATE_WEBHOOK_SECRET` | bot webhook / subscribers | Средний | Это уже не прямой Telegram API, а webhook-mediated delivery |
| `roles/extractor/scripts/telegram-to-captures.py` | `FMT-exocortex-template` | inbound capture intake | config file or env (`TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID`) | Telegram → captures | Средний | Это входящий Telegram-контур, не outbound alerts, но зависит от тех же ключей |
| `telegram-bot/bot.py` | `VK-offee` | product bot / user-facing Q&A | `telegram-bot/.env` | продуктовый бот кофейни | Отдельный контур | Не смешивать с инженерным notification layer |
| `telegram-bot/monitor_bot.py` | `VK-offee` | экзокортекс-мониторинг в Telegram | env (`TELEGRAM_BOT_TOKEN`) | отдельный monitor bot | Смежный | Нужна отдельная граница: это инженерный/операционный бот, но не transport-layer остальных скриптов |

---

## Выявленные структурные проблемы

### 1. Три разных storage layer для Telegram env

- `~/.config/aist/env`
- `~/.config/exocortex/telegram-token` + `telegram-chat-id`
- GitHub Actions secrets

### 2. Смешение transport-layer и продуктовых ботов

- `VK-offee` knowledge-bot живёт отдельно
- инженерные alert/report скрипты используют другой контур
- monitor-bot находится между ними и требует явной классификации

### 3. Непоследовательный outbound path

- часть скриптов шлёт через `notify.sh`
- часть шлёт прямым `curl`
- часть использует webhook instead of Telegram API

### 4. Нет явной модели классов сообщений

- completion messages
- daily reports
- auth alerts
- health alerts
- cloud reports

Сейчас они частично живут в одних и тех же каналах без явного разделения.

---

## Целевая архитектура Telegram notification layer

### Принцип 1. Разделять инженерный notification layer и продуктовые Telegram-боты

Должны существовать два разных логических контура:

- `engineering notification layer`
  - алерты
  - health-check
  - daily reports
  - token reports
  - cloud health reports
- `product bots`
  - `VK-offee` knowledge-bot
  - другие пользовательские Telegram-сценарии

Правило:
- продуктовый бот не является transport-layer для инженерных алертов по умолчанию
- инженерные скрипты не должны зависеть от runtime-логики `VK-offee` бота

### Принцип 2. Единый source-of-truth для локального Telegram env

Для локальных инженерных скриптов целевой source-of-truth:

- `~/.config/aist/env`

В этом слое должны жить:

- `TELEGRAM_BOT_TOKEN`
- `TELEGRAM_CHAT_ID`
- при необходимости `TELEGRAM_MESSAGE_THREAD_ID`

Что должно уйти из основной схемы:

- `~/.config/exocortex/telegram-token`
- `~/.config/exocortex/telegram-chat-id`

Они могут существовать только как legacy fallback на время миграции, но не как целевая модель.

### Принцип 3. Один локальный transport-layer для outbound notifications

Целевой локальный outbound path:

- все локальные инженерные скрипты отправляют сообщения через `roles/synchronizer/scripts/notify.sh`

Это относится к:

- strategist completion/alerts
- extractor completion/alerts
- health-check alerts
- daily reports
- token usage reports
- unprocessed-notes warnings

Что не должно происходить в целевой модели:

- прямой `curl https://api.telegram.org/...` в нескольких несогласованных скриптах
- отдельные storage layers для одного и того же chat/token

### Принцип 4. Cloud notification layer остаётся отдельным

GitHub Actions workflows должны оставаться со своим source-of-truth:

- GitHub Actions secrets

Это касается:

- `DS-strategy/.github/workflows/cloud-scheduler.yml`
- `FMT-exocortex-template/.github/workflows/cloud-scheduler.yml`
- webhook-based `notify-update.yml`

Причина:

- cloud workflow не должен зависеть от локальной машины
- локальные env-файлы и `~/.config/aist/env` не являются его runtime-layer

### Принцип 5. Явная классификация сообщений

Целевая классификация:

#### A. Critical alerts

- auth failure
- agent failed
- health-check red
- broken automation path

Требование:
- должны приходить гарантированно
- минимальный шум
- понятный формат “нужна реакция”

#### B. Operational reports

- daily telegram report
- token usage report
- cloud health summary

Требование:
- регулярные отчёты
- человекочитаемый формат
- не смешивать с критическими алертами в одном стиле

#### C. Informational completions

- “day-plan завершён”
- “session-import завершён”
- “template update digest”

Требование:
- либо отдельный формат/канал
- либо ограничение частоты, чтобы не шуметь

### Принцип 6. У каждого notification path должен быть smoke test

Для каждого контура нужно зафиксировать:

- команду ручного прогона
- ожидаемый лог
- ожидаемое сообщение в Telegram
- fallback-поведение если env не найден

---

## Нормализационные решения по слоям

### Local engineering layer

Целевое решение:

- env: `~/.config/aist/env`
- transport: `notify.sh`
- вызовы из strategist/extractor/health/token/daily-report через единый слой

### Cloud layer

Целевое решение:

- env: GitHub Actions secrets
- transport: direct workflow send or dedicated reusable action
- отдельная документация по required secrets

### Product bot layer

Целевое решение:

- `VK-offee` бот живёт в своём runtime-контуре
- его `.env` и deploy не смешиваются с экзокортексными инженерными алертами

---

## Предлагаемый порядок нормализации

1. Зафиксировать целевую архитектуру и принять `~/.config/aist/env` как local source-of-truth
2. Выявить все локальные скрипты, которые ещё ходят напрямую в Telegram API
3. Перевести их на единый outbound path через `notify.sh` или обоснованно оставить отдельными
4. Legacy-слой `~/.config/exocortex/telegram-*` перевести в fallback, затем убрать
5. Разделить формат critical alerts и regular reports
6. Записать smoke tests по каждому notification path

---

## Выполнено 05.04 — этап 1 (low-risk env normalization)

- `DS-strategy/tools/send-token-report.sh`
  - добавлена загрузка `~/.config/aist/env`
  - runtime-проверка: отчёт по токенам снова отправляется в Telegram

- `FMT-exocortex-template/roles/synchronizer/scripts/daily-telegram-report.sh`
  - основной env-layer переведён на `~/.config/aist/env`
  - legacy fallback на `~/.config/exocortex/telegram-*` сохранён
  - дополнительно исправлен runtime-баг `get_workplan_status()` (`[: too many arguments]`)
  - runtime-проверка: ежедневный отчёт успешно отправлен в Telegram

- `FMT-exocortex-template/roles/synchronizer/scripts/unprocessed-notes-check.sh`
  - основной env-layer переведён на `~/.config/aist/env`
  - legacy fallback на `~/.config/exocortex/telegram-*` сохранён
  - runtime-проверка: alert сработал, выявлены 3 необработанные заметки
  - дополнительно исправлен баг форматирования Telegram-сообщения: сырые `\n` заменены на реальные переводы строк + `--data-urlencode`

Вывод:
- low-risk этап нормализации прошёл успешно
- основной локальный env-layer для отчётных/alert-контуров подтверждён
- следующий этап уже затрагивает outbound-path нормализацию и требует большей осторожности

---

## Migration plan

### Группа A — перевести на `notify.sh`

Эти контуры должны использовать единый локальный transport-layer:

1. `roles/synchronizer/scripts/daily-telegram-report.sh`
   - Сейчас: читает `~/.config/exocortex/telegram-token` и `telegram-chat-id`
   - Цель: использовать `notify.sh` + `~/.config/aist/env`

2. `roles/synchronizer/scripts/unprocessed-notes-check.sh`
   - Сейчас: direct `curl` + `~/.config/exocortex/telegram-*`
   - Цель: использовать `notify.sh` + единый env-layer

3. Прямой alert-блок в `roles/strategist/scripts/strategist.sh`
   - Сейчас: локальный direct `curl` для canary/auth-like alert
   - Цель: либо через `notify.sh`, либо через dedicated helper, но не direct duplicate path

4. `roles/synchronizer/scripts/health-check.sh`
   - Сейчас: direct `curl`, но уже на правильном env-layer
   - Цель: решить архитектурно:
     - либо оставить direct sender как special-case alert path
     - либо перевести на `notify.sh` для полного унифицирования

5. `DS-strategy/tools/send-token-report.sh`
   - Уже использует `~/.config/aist/env`
   - Следующий шаг: решить, должен ли он остаться direct sender или вызываться через единый helper/notify transport

### Группа B — оставить как cloud-only

Эти контуры НЕ должны зависеть от локального env:

1. `DS-strategy/.github/workflows/cloud-scheduler.yml`
2. `FMT-exocortex-template/.github/workflows/cloud-scheduler.yml`
3. `FMT-exocortex-template/.github/workflows/notify-update.yml`

Правило:
- source-of-truth = GitHub Actions secrets / webhook secrets
- локальный `~/.config/aist/env` здесь не используется

### Группа C — считать legacy и вывести из основной схемы

1. `~/.config/exocortex/telegram-token`
2. `~/.config/exocortex/telegram-chat-id`

Статус:
- временный fallback на переходный период
- не использовать как целевой слой для новых/чинящихся скриптов

### Группа D — оставить вне инженерного notification layer

1. `VK-offee/telegram-bot/bot.py`
2. `VK-offee/telegram-bot/monitor_bot.py`

Причина:
- это отдельные продуктовые или смежные operational bots
- их нельзя бездумно включать в единый инженерный transport-layer

---

## Очерёдность внедрения

### Этап 1 — стабилизация без архитектурного риска

- зафиксировать целевой source-of-truth: `~/.config/aist/env`
- добавить/обновить documentation note, что `~/.config/exocortex/telegram-*` = legacy
- собрать smoke-test команды по каждому notification path

### Этап 2 — миграция legacy storage

- перевести `daily-telegram-report.sh`
- перевести `unprocessed-notes-check.sh`
- проверить, что отчёты и warnings продолжают приходить

### Этап 3 — унификация outbound path

- решить по `health-check.sh` и `send-token-report.sh`:
  - direct sender оставить как intentional exception
  - или обернуть через единый helper

### Этап 4 — нормализация классов сообщений

- разделить critical alerts и regular reports по формату
- при необходимости разделить chat/thread/topic routing

---

## Smoke tests, которые нужны перед реальной миграцией

1. `notify.sh` manual send
2. `health-check.sh` manual run
3. `daily-telegram-report.sh` manual run
4. `send-token-report.sh` manual run
5. `unprocessed-notes-check.sh` simulated alert
6. GitHub cloud-scheduler Telegram step

---

## Первые deliverables

- карта `script -> env-source -> message class -> target channel`
- таблица `symptom -> root cause -> fix`
- единое инженерное правило для Telegram env
- smoke-test checklist по каждому notification path

---

## Критерии завершения

- у каждого Telegram notification path есть явный env source-of-truth
- critical alerts и обычные отчёты разделены хотя бы логически
- все основные notification scripts проходят ручной smoke test
- карта и правило хранения зафиксированы в инженерных артефактах

---

## Связанные артефакты

- `ENG.WP.004` — починка path drift в `notify.sh`
- `ENG.WP.006` — auth failure detector + telegram chat-id
- `ENG.WP.008` — карта автоматизаций и источников окружения

---

## Статус

WP открыт. Следующий шаг — сделать read-only inventory всех Telegram notification paths и собрать матрицу `script -> env -> purpose -> risk`.
