---
type: work-plan
wp_id: 110
title: Проверочный прогон Google Workspace и acceptance-gate инженера
created: 2026-04-23
status: done
owner: Environment Engineer
support:
  - Strategist
domain: exocortex-engineering
mode: verification-suite
---

# WP-110 — Проверочный прогон Google Workspace и acceptance-gate инженера

## Зачем открыт

Пользователь поставил жёсткий критерий приёмки:

- архитектурный контракт по Google не считается принятым;
- пока не пройден реальный end-to-end прогон операций.

Дополнительно нужно закрепить это как правило инженерного поведения:

- РП нельзя закрывать без многосторонней проверки там, где она возможна и критична.

## Acceptance для этого slice

### Google Drive

Нужно реально проверить:

1. создание тестового документа;
2. изменение тестового документа;
3. перенос тестового документа в другую тестовую папку;
4. удаление тестового документа.

### Google Calendar

Нужно реально проверить:

1. создание тестового события;
2. чтение тестового события;
3. изменение тестового события;
4. удаление тестового события.

### Skill layer

Нужно дописать в инженерный skill:

- нельзя закрывать РП как done, если критичный внешний контур не прошёл проверочный прогон.

## Truthful boundary

В этот slice не входит:

- полная унификация всех Google-аккаунтов;
- починка `connector parity` между всеми сервисами;
- верификация Gmail send/delete слоя.

## Что materialized

- `ENG.WP.047`
- acceptance-gate добавлен в `AGENT.SKILL.003`
- проведён реальный verification suite:
  - `Google Drive`: create/update/move/delete
  - `Google Calendar`: create/read/update/delete

## Truthful verdict

Slice закрыт как verified acceptance layer.

Что реально подтверждено:

- `Google Drive` через локальный `VK-offee` token работает end-to-end.
- `Google Calendar` connector работает end-to-end.
- инженерный ритуал теперь прямо запрещает закрывать интеграционный `WP`
  без такого проверочного прогона.

Что ещё не подтверждено этим slice:

- полная parity по `Google Drive app connector`
- cleanup старых чужих дубликатов
- единый canonical owner для всех Google-сервисов.
