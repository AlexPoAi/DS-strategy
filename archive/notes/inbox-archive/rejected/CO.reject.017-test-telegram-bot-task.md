---
id: CO.reject.017
type: capture
status: rejected
reason: "test + task — тестовое сообщение + задача по настройке Telegram бота"
date: 2026-04-03
source: Telegram 2026-03-31
tags:
  - test
  - task
  - telegram
  - bot
---

# Тестовое сообщение + задача: настройка Telegram бота

**Сырой текст:**
> Привет это первая заметка которая должна попасть в Catches для экстрактора нам необходимо завтра сделать работу по настройке Telegram бота вот так

**Причина отклонения:** Комбинация тестового сообщения (проверка pipeline) и реализационной задачи (настройка Telegram бота). Аналог CO.reject.013 (telegram-bot-upgrade).

**Паттерн:** Технические задачи → DS-репо или INBOX-TASKS, не Pack.
