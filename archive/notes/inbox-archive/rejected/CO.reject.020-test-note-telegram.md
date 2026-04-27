---
type: rejected-capture
date: 2026-04-04
source: captures.md
verdict: reject
reason: test-message
tags: [test, telegram, pipeline]
---

# CO.reject.020 — Пробная заметка (тестовое сообщение)

## Сырой capture

**Источник:** `### Пробная заметка [source: Telegram 2026-04-04]`  
**Контент:** «Пробная заметка»

## Причина отклонения

Тестовое сообщение без доменного содержания. Аналогично CO.reject.015 (тестовое сообщение проверки связи pipeline Telegram → captures). Нет знания для записи в Pack.

## Паттерн

Тестовые сообщения из Telegram без доменного содержания → reject. Они подтверждают работоспособность pipeline, но не несут знания.
