---
type: work-product
pack: PACK-exocortex-engineering
id: ENG.WP.046
title: Единый operating contract Google Workspace для экзосистемы
created: 2026-04-23
status: active
---

# ENG.WP.046 — Единый operating contract Google Workspace для экзосистемы

## Задача

Собрать в один human-readable и agent-readable контракт работу с:

- `Google Drive`
- `Gmail`
- `Google Calendar`

Чтобы агент мог понимать:

- через какой контур он работает;
- какой аккаунт за что отвечает;
- где канонический путь для записи;
- когда нельзя писать через `connector`, а нужно идти через локальный `API token`.

## Verified state на 2026-04-23

### 1. Google Calendar connector

- Профиль подтверждён live-tool вызовом:
  - `Александр Подгаевский`
  - `alexpoipad@gmail.com`
- Значение:
  - это текущий канонический connector для calendar reminders, deadlines и follow-up.

### 2. Gmail connector

- По Park-контуру подтверждено:
  - письмо в `Воду Крыма` успешно отправлено с `oooterrasimf@gmail.com`
  - connector имеет `send`-scope после переподключения
- Значение:
  - для внешней официальной переписки Park primary mail contour сейчас — `ООО ТЕРРА`.

### 3. Google Drive app connector

- Connector видит:
  - старый `PARK.DOC.036`
  - папку `Парк`
- Но именно через этот контур документ был создан в другом Drive-контейнере, а не в канонической папке документов.

### 4. Локальный VK-offee Google Drive API token

- Контур:
  - `VK-offee/.github/scripts/token_upload.pickle`
  - `VK-offee/.github/scripts/credentials.json`
- Он видит папку:
  - `Парк` → `12GgllpEOiRnGviQhivVm_bcAzX53E2wK`
- Через него уже созданы корректные документы в нужной папке:
  - `PARK.DOC.036`
  - `PARK.DOC.037`

## Root-cause drift

У нас не один Google-контур, а минимум три:

1. `Google Calendar connector` → `alexpoipad@gmail.com`
2. `Gmail connector` → `oooterrasimf@gmail.com`
3. `Google Drive`:
   - app-connector
   - локальный `VK-offee` OAuth-token

Именно этот split и породил дефект:

- документ был создан одним контуром;
- локальный API-контур его не видел (`404 File not found`);
- user видел папку `Парк`, но не видел созданный документ.

## Park-specific contract

### Иерархия папок

- root project folder:
  - `1-E-pWBQni6Bv2TFAgLOOl3lWMXU9l9lk`
- documents folder:
  - `1F-ghGf9AXrA1ULLRx5VXKaeHDVicz0pI`
- visible working folder `Парк`:
  - `12GgllpEOiRnGviQhivVm_bcAzX53E2wK`

### Практическое правило

Для Google Docs по Парку канонический write target сейчас:

- `Парк` → `12GgllpEOiRnGviQhivVm_bcAzX53E2wK`

Не root-папка проекта, а именно видимая рабочая папка с документами.

## Operating rules

1. Если агенту нужно:
   - поставить напоминание;
   - найти follow-up;
   - работать с дедлайнами,
   использовать `Google Calendar connector`.

2. Если агенту нужно:
   - отправить официальное письмо по Парку,
   использовать `Gmail connector` на `oooterrasimf@gmail.com`.

3. Если агенту нужно:
   - искать документы;
   - читать Google Docs;
   - быстро проверять наличие документа,
   можно использовать `Google Drive app connector`.

4. Если агенту нужно:
   - гарантированно создать Park-документ в правильной папке;
   - переиспользовать канонический write-path;
   использовать локальный `VK-offee` Google Drive API token.

5. Если `connector-created` документ не виден локальному token-контурy,
   это считается `account drift`, а не просто “неудачной загрузкой”.

## Что ещё не утверждено

- Явно не подтверждено, к какому аккаунту привязан текущий `Google Drive app connector`.
- Не закрыт вопрос, нужно ли сводить все Google-контуры к одному аккаунту или оставлять role-based split.
- Не вычищены старые дубликаты документов, созданные в другом Drive-контуре.
