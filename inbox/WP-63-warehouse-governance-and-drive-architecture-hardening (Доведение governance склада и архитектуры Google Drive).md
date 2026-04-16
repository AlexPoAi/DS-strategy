---
type: wp-context
status: active
owner: code-engineer
created: 2026-04-15
updated: 2026-04-16 20:47
tags: [warehouse, governance, drive, telegram, vk-offee]
---

# WP-63: Доведение governance склада и архитектуры Google Drive

## Роль и найм агента
- Нанят профильный агент: **Code Engineer** (реализация storage-governance, DLQ, idempotency, health-loop).
- Доменная поддержка/верификация: **VK Coffee Analyst** (контроль полезности карточек и складских сигналов).

## Связь с текущим контуром
- Этот WP — следующий slice после `WP-62`.
- `WP-62` закрыл базовый pipeline (`sync -> cards -> bot -> telegram`).
- `WP-63` доводит контур до устойчивой production-эксплуатации без ручного хаоса.

## Контекст (почему открываем)
- По складу уже есть рабочий поток, но остаются операционные риски:
  1. нет формального реестра входящих/обработанных документов;
  2. нет явного quarantine/DLQ для битых отчётов;
  3. нет жёсткой идемпотентности (риск повторной обработки);
  4. архитектура Google Drive не закреплена как контракт;
  5. нет компактного ежедневного health-сигнала для владельца.

## План работ (итерациями)
1. **Контракт и реестр документов (`WH.REGISTRY`)**
   - Материализовать единый реестр по каждому входящему файлу:
     `source_file`, `mtime`, `file_hash`, `report_type`, `status`, `card_path`, `error`.
   - Ввести статусы: `new`, `processed`, `duplicate`, `error`.

2. **DLQ / Quarantine контур**
   - Добавить отдельную папку и отчет для проблемных файлов.
   - Если парсинг неуспешен/формат сломан — файл не теряется, а попадает в `DLQ` с причиной.

3. **Идемпотентность pipeline**
   - Ввести защиту от повторной обработки по `file_hash + mtime`.
   - Гарантировать, что один и тот же источник не плодит дубли карточек и ложные алерты.

4. **Google Drive архитектура (мягкая миграция)**
   - Зафиксировать 3-зонную структуру:
     - `00_INBOX_RAW` (входящие),
     - `10_READY_FOR_BOT` (валидированные для контура),
     - `90_ARCHIVE` (история).
   - Добавить naming-contract для файлов (шаблон имени + дата + тип отчета).

5. **Operational health-report в Telegram**
   - Добавить ежедневный компактный digest:
     `received / processed / duplicate / error / dlq`.
   - Вынести критические сигналы (например, пустой цикл или всплеск ошибок).

6. **Production закрепление 24/7**
   - Подтвердить целевой `WAREHOUSE_REPORT_CHAT_ID` на VPS.
   - Подтвердить минимум 2-3 стабильных цикла подряд.

## Прогресс на 2026-04-15 21:20
- Итерация 1 (реестр) выполнена:
  1. В `warehouse_reports_pipeline.py` добавлен постоянный реестр `WH.REGISTRY.001-documents.csv`.
  2. Для каждого входящего CSV фиксируются: `source_file`, `mtime`, `size`, `hash`, `report_type`, `status`, `card_path`, `error`.
  3. Реализованы статусы: `new`, `processed`, `duplicate`, `error`.
  4. Повторный прогон показывает idempotent-поведение по реестру (`duplicate` вместо повторной генерации карточек).
  5. Сводка `WH.REPORT.002` теперь содержит операционные счётчики `received/processed/duplicate/error`.

## Прогресс на 2026-04-16 19:55
- Итерация 2 (DLQ / quarantine) выполнена:
  1. В pipeline добавлен quarantine-контур `PACK-warehouse/03-quarantine/dlq-files/`.
  2. Для проблемных файлов формируется отчёт `WH.DLQ.001-quarantine-report.md`.
  3. В реестр документов добавлено поле `dlq_path`.
  4. Сводка `WH.REPORT.002` теперь показывает отдельный счётчик `DLQ`.
  5. Поведение проверено smoke-test'ом на пустом CSV: файл ушёл в quarantine с причиной `empty csv`, после проверки тестовые артефакты удалены.

## Прогресс на 2026-04-16 20:47
- На VPS (`72.56.4.61`) зафиксирован явный `WAREHOUSE_REPORT_CHAT_ID` (в `/root/.config/aist/env` и `telegram-bot/.env`).
- Поднят `systemd` timer `vk-warehouse-full-loop.timer` для запуска каждые 30 минут.
- Выявлен production-blocker: отсутствует `/opt/vk-offee/VK-offee/.github/scripts/credentials.json` для Google Sheets OAuth.
- Сервис переведён в безопасный режим `exec-condition` (graceful skip без ложного crash-loop), пока не доставлен `credentials.json`.

## Acceptance
- Есть рабочий `WH.REGISTRY` по входящим и обработанным документам.
- Ошибочные/непарсабельные документы фиксируются в DLQ и не теряются.
- Повторные прогоны не создают дубли карточек и ложные отчеты.
- Структура Google Drive закреплена как контракт и понятна для Жанны.
- В Telegram приходит стабильный операционный health-report.
- Хронология изменений отражена в DS инженерном контуре.

## Первые deliverables этого WP
- Новый рабочий продукт по контракту хранения и маршрутизации документов склада.
- Обновление `PACK-warehouse` манифеста и runbook по Google Drive.
- Отдельная карточка с финальным operational verdict (`ready/partial`).
