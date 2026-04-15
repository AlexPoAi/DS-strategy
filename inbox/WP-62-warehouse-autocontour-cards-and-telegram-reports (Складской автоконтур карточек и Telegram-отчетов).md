---
type: wp-context
status: active
owner: code-engineer
created: 2026-04-15
updated: 2026-04-15
tags: [warehouse, automation, telegram, vk-offee]
---

# WP-62: Складской автоконтур карточек и Telegram-отчетов

## Роль и найм агента
- Нанят профильный агент: **Code Engineer** (реализация pipeline/скриптов).
- Доменная поддержка/верификация: **VK Coffee Analyst** (смысловая проверка складских выжимек).

## Контекст
- Жанна загружает данные в Google Drive папку для бота.
- Нужно, чтобы склад работал как отдельный контур в `VK-offee`, а не как разрозненные CSV:
  1. auto-sync из Drive,
  2. карточка на каждый отчет,
  3. доступность карточек в Telegram-боте (через RAG),
  4. автоотчет в Telegram при новых данных.

## Что сделано
1. Починен sync filename handling (`ENG.WP.039`) — выгрузка больше не падает на `/` в именах.
2. Добавлен pipeline `PACK-warehouse/tools/warehouse_reports_pipeline.py`:
   - создаёт карточки `PACK-warehouse/02-domain-entities/report-cards/WH.CARD.*.md`;
   - создаёт зеркальные карточки в `knowledge-base/Отчёты для бота/Склад/WH.BOT.*.md`;
   - собирает сводный отчет `PACK-warehouse/04-work-products/WH.REPORT.002-warehouse-sync-summary-latest.md`;
   - пытается отправить Telegram summary.
3. `sync-google-sheets.py` теперь автоматически запускает складской pipeline после sync.

## Открытые хвосты
1. Telegram отправка пока даёт `chat not found` — нужно зафиксировать правильный `WAREHOUSE_REPORT_CHAT_ID`.
2. Часть листов получает `429 quota` — нужен backoff/retry для полного прогона.
3. Нужно зафиксировать регулярный cron/launchd запуск этого full-loop (sync + cards + telegram).

## Acceptance
- Каждый новый складской CSV формирует отдельную карточку.
- Карточки доступны боту через `knowledge-base/Отчёты для бота/Склад`.
- После синка уходит Telegram summary с ссылочной выжимкой.
- Хронология изменений зафиксирована в DS инженерном контуре.
