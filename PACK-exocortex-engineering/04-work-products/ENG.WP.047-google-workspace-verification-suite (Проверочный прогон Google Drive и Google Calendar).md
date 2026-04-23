---
type: work-product
pack: PACK-exocortex-engineering
id: ENG.WP.047
title: Проверочный прогон Google Drive и Google Calendar
created: 2026-04-23
status: active
---

# ENG.WP.047 — Проверочный прогон Google Drive и Google Calendar

## Задача

Подтвердить не на уровне архитектуры, а на уровне реальных операций,
что Google-контур экзосистемы действительно работает.

## Google Drive verification

Контур:

- локальный `VK-offee` Google Drive API token
- рабочая папка `Парк` `12GgllpEOiRnGviQhivVm_bcAzX53E2wK`

Прогон:

1. Созданы тестовые папки:
   - `_TEST_Codex_GoogleOps_A`
   - `_TEST_Codex_GoogleOps_B`
2. Создан тестовый Google Doc:
   - `TEST Google Drive verification doc`
3. Документ обновлён.
4. Документ перемещён из папки `A` в папку `B`.
5. Документ удалён.
6. Обе тестовые папки удалены.

## Google Calendar verification

Контур:

- `Google Calendar connector`
- профиль `alexpoaiagent@gmail.com`

Прогон:

1. Создано тестовое событие:
   - `TEST Codex Calendar on alexpoaiagent`
2. Событие прочитано по `event_id`.
3. Событие обновлено:
   - новый title
   - новое описание
4. Событие удалено.

## Truthful verdict

`Google Drive` и `Google Calendar` прошли end-to-end verification.

Это не закрывает весь `Google account drift`, но подтверждает:

- локальный Drive API контур реально рабочий;
- Calendar connector реально рабочий на `alexpoaiagent@gmail.com`;
- acceptance по этим двум контурам пройдена не на словах, а на реальном lifecycle.
