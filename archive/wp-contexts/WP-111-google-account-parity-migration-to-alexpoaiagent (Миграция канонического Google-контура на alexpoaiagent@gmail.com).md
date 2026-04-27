---
type: work-plan
wp_id: 111
title: Миграция канонического Google-контура на alexpoaiagent@gmail.com
created: 2026-04-23
status: done
owner: Environment Engineer
support:
  - Strategist
domain: exocortex-engineering
mode: connector-parity-migration
---

# WP-111 — Миграция канонического Google-контура на alexpoaiagent@gmail.com

## Зачем открыт

Нужно перевести канонический рабочий Google-контур экзосистемы:

- `Google Drive`
- `Google Calendar`

с личного `alexpoipad@gmail.com` на рабочий `alexpoaiagent@gmail.com`.

При этом:

- `alexpoipad@gmail.com` остаётся личным аккаунтом;
- `oooterrasimf@gmail.com` остаётся отдельным доменным mail-контуром `ООО ТЕРРА`
  для внешней Park-переписки.

## Target model

- `personal`: `alexpoipad@gmail.com`
- `canonical workspace`: `alexpoaiagent@gmail.com`
- `Park external mail`: `oooterrasimf@gmail.com`

## Acceptance

Slice считается успешным, если:

1. `Google Calendar` profile показывает `alexpoaiagent@gmail.com`;
2. `Google Drive` контур работает от канонического аккаунта;
3. operating contract обновлён под новую verified модель.

Если это упрётся в UI reconnect и не может быть завершено из терминала,
truthful verdict должен быть `blocked by reconnect`, а не `done`.

## Progress на 2026-04-23

Уже подтверждено:

- локальный `VK-offee` Google Drive token успешно мигрирован на `alexpoaiagent@gmail.com`;
- новый канонический аккаунт видит:
  - общую папку кофейни;
  - `Разработано в базе данных`;
  - `Отчёты для бота`;
  - `Новые документы`;
  - весь Park-контур и handoff-папку `Операционный менеджер`;
- по ключевым VK Coffee папкам подтверждён `full access`:
  - create
  - update
  - move
  - delete

Финально подтверждено:

- `Google Calendar connector` переподключён на `alexpoaiagent@gmail.com`;
- live-profile календаря показывает `alexpoaiagent@gmail.com`;
- проведён полный lifecycle test:
  - create
  - read
  - update
  - delete
- каноническая модель теперь такая:
  - `personal`: `alexpoipad@gmail.com`
  - `canonical workspace`: `alexpoaiagent@gmail.com`
  - `Park external mail`: `oooterrasimf@gmail.com`

## Truthful status

`WP-111` закрыт как `done`.

Что этот slice закрыл:

- канонический `Google Drive` закреплён за `alexpoaiagent@gmail.com`;
- канонический `Google Calendar` закреплён за `alexpoaiagent@gmail.com`.

Что остаётся отдельным следующим slice:

- стратегия по `Gmail`, если потребуется параллельная работа с несколькими
  почтовыми Google-контурами без ручного переключения.
