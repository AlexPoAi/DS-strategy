---
type: wp-context
status: active
owner: code-engineer
created: 2026-04-17
tags: [warehouse, drive, sync, vk-offee]
---

# WP-65: Синк папки склада Жанны в пайплайн

## Контекст

Жанна загружает складские отчёты (ABC-анализ, снятие остатков, заявки) в отдельную папку Google Drive:
- **ID:** `1oo1j86l7hGZ-E1HIbAApc3PdCA3o80GX`
- **Ссылка:** https://drive.google.com/drive/u/0/folders/1oo1j86l7hGZ-E1HIbAApc3PdCA3o80GX

Общая папка кофейни (БАР, КУХНЯ, документы):
- **ID:** `120x7kqYeV0Vb4TLbdCC0esv0WkF5JROC`

Сейчас `warehouse_full_loop.sh` вызывает `sync-google-sheets.py`, который читает только **общую папку**. Папка Жанны не подключена — ABC-анализ и остатки не попадают в пайплайн.

## Задача

1. Добавить в `warehouse_full_loop.sh` отдельный шаг синка из папки Жанны (`1oo1j86l7hGZ-E1HIbAApc3PdCA3o80GX`) перед запуском warehouse pipeline.
2. Добавить `WAREHOUSE_DRIVE_FOLDER_ID` как отдельную переменную в `.env` / конфиг (не смешивать с `GOOGLE_DRIVE_FOLDER_ID`).
3. Убедиться, что скачанные файлы попадают в правильную категорию для pipeline (склад).

## Acceptance

- [ ] `warehouse_full_loop.sh` синкает папку Жанны перед pipeline
- [ ] Новые файлы (ABC-анализ 1 и 2) появляются в `knowledge-base/` и обрабатываются pipeline
- [ ] Переменная `WAREHOUSE_DRIVE_FOLDER_ID` зафиксирована отдельно
- [ ] Проверен локальный прогон
