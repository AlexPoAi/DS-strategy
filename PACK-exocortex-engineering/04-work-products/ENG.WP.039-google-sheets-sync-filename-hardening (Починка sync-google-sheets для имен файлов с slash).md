---
id: ENG.WP.039
title: Починка sync-google-sheets для имен файлов с slash
status: in_progress
created: 2026-04-15
updated: 2026-04-15
owner: Environment Engineer
---

# ENG.WP.039 — Google Sheets Sync Filename Hardening

## Контекст
- Жанна передаёт актуальные данные в Google Drive папку для бота.
- Локальный sync падал на `FileNotFoundError`, когда имя таблицы/листа содержало `/`.
- Из-за этого новые данные не материализовывались в `VK-offee/knowledge-base`, и анализ работал по устаревшему срезу.

## Что сделано
1. В `VK-offee/.github/scripts/sync-google-sheets.py` добавлен `sanitize_filename()` для table/sheet имён.
2. Перезапущен sync через `venv`:
   - команда: `./venv/bin/python sync-google-sheets.py`
   - результат: script завершился успешно, прочитано 144 листа, обработано 34 таблицы.
3. Подтверждена материализация свежих CSV в `VK-offee/knowledge-base` (таймстемпы `2026-04-15 19:49..19:52`).

## Truthful ограничения
- Остался quota-limit Google Sheets API (`Read requests per minute per user`), поэтому часть листов не выгрузилась в этом прогоне.
- Это уже не failure по filename/path, а rate-limit ограничение внешнего API.

## Следующий шаг
1. Добавить rate-limit-safe чтение (retry + backoff + пауза между листами).
2. Повторить sync и добрать недочитанные листы.
3. Закрыть WP после стабильного прогона без `429` в критичных складских таблицах.
