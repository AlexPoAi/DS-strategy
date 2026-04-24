---
wp: 48
title: Полное тестирование Telegram-бота VK-offee
status: in_progress
created: 2026-04-03
budget: 1h
repo: VK-offee (telegram-bot на VPS 72.56.4.61)
---

# WP-48: Полное тестирование Telegram-бота VK-offee (Тестирование Telegram-бота)

## Контекст
После серии исправлений (убран дубль на Маке, исправлен порядок git в note_command, 
добавлен fallback) нужно полное end-to-end тестирование всех функций бота.

## Чеклист тестирования

### /note (заметки)
- [x] /note тестовая заметка → ✅ ответ без ошибки
- [x] Кнопка «📝 Заметка» → ввод текста → ✅ ответ без ошибки
- [x] Проверить captures.md на VPS — запись появилась
- [ ] Проверить git log — коммит создался
- [x] 2026-04-24: regression guard — `📝 Заметка` и `/note` выставляют `waiting_for_note` до отправки prompt, поэтому `telegram.error.TimedOut` не ломает state-machine

### RAG (база знаний)
- [ ] Кнопка «☕ Напитки» → ответ из базы знаний
- [ ] Кнопка «📊 Статус» → 🟢 RAG API работает
- [ ] Свободный вопрос: «Как приготовить капучино?»

### Стабильность
- [ ] Бот не падает после 10 минут работы
- [ ] Нет ошибок Conflict в логах

## Артефакт
Отчёт о тестировании (в этом файле) + фиксы если найдены баги.

## Отчёт 2026-04-23
- Восстановлен baseline `telegram-bot` до состояния до внедрения `Codex`-слоя.
- На VPS `72.56.4.61` подтверждён рабочий сценарий note-flow: `📝 Заметка` → ввод текста → `✅ Заметка сохранена`.
- Подтверждено по `DS-strategy/inbox/captures.md`, что заметки реально доходят в captures.
- Явные тестовые мусорные заметки за `2026-04-23` выявлены отдельно и не считаются продуктовой записью.
- Контур `RAG / база знаний` остаётся отдельной незакрытой проблемой: `vk-rag-api` отвечает на `/health`, но бот уже возвращал `500` на `POST /query`, поэтому note-flow и RAG-flow нужно учитывать как два разных acceptance-gate.

## Отчёт 2026-04-24
- Пользователь сообщил повторный сбой: нажал `📝 Заметка`, но prompt `Напишите текст заметки` не пришёл.
- VPS log подтвердил `telegram.error.TimedOut` на update с текстом `📝 Заметка`.
- Root-cause в note-flow: состояние `waiting_for_note` выставлялось после `reply_text`, поэтому timeout Telegram API ломал переход в режим заметки.
- Fix в `VK-offee/telegram-bot/bot.py`:
  - добавлен `safe_reply()` с 3 попытками;
  - `waiting_for_note=True` ставится до отправки prompt для кнопки и `/note`;
  - `run_polling` получил `bootstrap_retries=-1` и `timeout=30`.
- Добавлен тест `telegram-bot/tests/test_note_flow.py`, который имитирует `TimedOut` и проверяет, что состояние ожидания заметки сохраняется.
- VPS status после деплоя: `vk-telegram-bot.service active`, `Application started`.
- Transport caveat: `curl -4/-6 -m 10 https://api.telegram.org` с VPS таймаутится, поэтому внешняя связность Telegram остаётся отдельным runtime-risk.
