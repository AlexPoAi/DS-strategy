---
type: skill
pack: PACK-agent-skills
id: AGENT.SKILL.004
role: cross-domain
title: Скилл работы агентов с Google Workspace контурами
status: active
created: 2026-04-23
updated: 2026-04-23
---

# AGENT.SKILL.004 — Скилл работы агентов с Google Workspace контурами

## Назначение

Дать агенту повторяемый контракт для работы с:

- `Google Drive`
- `Gmail`
- `Google Calendar`

в условиях, когда в экосистеме существует несколько Google-контуров:

- app-connectors
- локальные OAuth-токены
- разные рабочие аккаунты

## Базовое правило

Сначала различить контур, потом действовать.

Агент не должен предполагать, что `Google Drive`, `Gmail` и `Google Calendar`
работают от одного и того же аккаунта.

Этот skill является общим маршрутом для Claude и Codex. Разные tool-surface
(`mcp__google-drive__*`, Google Drive app connector, локальные OAuth-скрипты)
не считаются разными процессами: это адаптеры поверх одного Google Workspace
контракта.

## Обязательная последовательность

1. Определить задачу:
   - `calendar`
   - `mail`
   - `drive-read`
   - `drive-write`

2. Определить канонический контур:
   - `calendar reminders / deadlines` → `Google Calendar connector` на `alexpoaiagent@gmail.com`
   - `official Park mail` → `Gmail connector` на `ООО ТЕРРА`
   - `quick Drive read/search` → `Google Drive app connector`
   - `guaranteed Park document write` → локальный `VK-offee` Drive API token на `alexpoaiagent@gmail.com`

3. Проверить, verified ли этот контур.

   Если у агента нет активного tool-доступа к нужному контуру, но в настройках
   есть разрешения или ссылки на него, это фиксируется как `route drift`, а не
   маскируется ручным обходом.

4. Только после этого:
   - создавать;
   - обновлять;
   - отправлять;
   - искать;
   - ставить follow-up.

## Когда включается alert

Считать это `Google drift`, если:

- документ создан, но не виден локальному токену;
- папка в `START-HERE` и фактическая рабочая папка не совпадают;
- письмо ушло, но follow-up или source-of-truth не materialized;
- connector и local API видят разные множества документов.

## Park-specific rule

Для проекта `Парк` Google Docs нельзя считать сохранёнными корректно,
пока они не лежат в видимой рабочей папке `Парк`.

Если документ создался “где-то в Drive”, это не done.

## Жёсткие запреты

- Нельзя считать `Google account` единым без проверки.
- Нельзя предполагать, что `Gmail` умеет безопасно auto-switch между несколькими
  аккаунтами без отдельной live-проверки.
- Нельзя создавать Park-документы в произвольный root Drive.
- Нельзя отправлять внешнее письмо без user approval.
- Нельзя закрывать WP как done, если source-of-truth не обновлён после tool-call.

## Критерий завершения

- агент явно назвал, через какой Google-контур он работает;
- агент явно назвал свой tool-adapter и подтвердил, что он идёт по этому skill,
  а не по отдельному Claude-only или Codex-only маршруту;
- документ/письмо/событие materialized в каноническом месте;
- при drift это не замаскировано, а зафиксировано как отдельный дефект.

## Каноническая модель на сейчас

- `personal`: `alexpoipad@gmail.com`
- `workspace Google`:
  - `Drive` → `alexpoaiagent@gmail.com`
  - `Calendar` → `alexpoaiagent@gmail.com`
- `external Park mail`:
  - `Gmail` → `oooterrasimf@gmail.com`
