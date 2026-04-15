---
type: wp-context
status: active
owner: code-engineer
created: 2026-04-15
updated: 2026-04-15 20:50
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
4. Добавлен retry/backoff для Google API в `sync-google-sheets.py` (устойчивость к `429 quota`).
5. В `warehouse_reports_pipeline.py` добавлен Telegram env fallback:
   - `WAREHOUSE_REPORT_CHAT_ID` / `TELEGRAM_CHAT_ID`,
   - `telegram-bot/.env`,
   - `~/.config/aist/env`,
   - `~/.config/exocortex/telegram-chat-id` + `telegram-token`.
6. Добавлен регулярный full-loop entrypoint и launchd-шаблон:
   - `PACK-warehouse/tools/warehouse_full_loop.sh`
   - `PACK-warehouse/tools/com.vkoffee.warehouse-full-loop.plist` (каждые 30 минут).
7. Проведена безопасная зачистка `telegram-bot` от legacy/debug мусора:
   - удалены небоевые скрипты с хардкод `CHAT_ID` (`fetch_invoices.py`, `find_topics.py`, `test_chat_access.py`);
   - `start.sh` возвращен в рабочий режим запуска `bot.py`;
   - в `.env.example`/`deploy.sh` добавлен явный env-контракт для `WAREHOUSE_REPORT_CHAT_ID`/`TELEGRAM_CHAT_ID`.

## Открытые хвосты
1. Подтвердить целевой Telegram chat назначения (оставить текущий `TELEGRAM_CHAT_ID` или зафиксировать отдельный `WAREHOUSE_REPORT_CHAT_ID`).
2. Прогнать 1-2 полных цикла в фоне и убедиться, что Telegram summary стабильно доходит после sync.

## Acceptance
- Каждый новый складской CSV формирует отдельную карточку.
- Карточки доступны боту через `knowledge-base/Отчёты для бота/Склад`.
- После синка уходит Telegram summary с ссылочной выжимкой.
- Хронология изменений зафиксирована в DS инженерном контуре.
