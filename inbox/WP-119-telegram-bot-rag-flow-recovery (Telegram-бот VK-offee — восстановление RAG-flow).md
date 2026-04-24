---
id: WP-119
title: "Telegram-бот VK-offee — восстановление RAG-flow"
status: in_progress
created: 2026-04-24
priority: high
domain: VK Coffee / product engineering
repo:
  - VK-offee/telegram-bot
  - VK-offee-rag
related_wp:
  - WP-36
  - WP-38
  - WP-46
  - WP-48
  - WP-59
---

# Контекст

Продолжаем работу с Telegram-ботом VK-offee после серии предыдущих РП:

- `WP-36` — исходная большая идея RAG-бота для базы знаний VK-offee.
- `WP-38` — перенос бота и RAG API на VPS 24/7.
- `WP-46` — продуктовый рефакторинг меню, ролей и сценариев.
- `WP-48` — тестовый контур Telegram-бота.
- `WP-59` — будущий управленческий сценарий с дневными/недельными отчётами.

Фактический последний важный статус из `WP-48`:

- note-flow работает: `📝 Заметка` сохраняет сообщения в `DS-strategy/inbox/captures.md`;
- RAG API `/health` отвечал;
- RAG-flow не закрыт: бот уже возвращал ошибку на `POST /query`;
- therefore: note-flow и RAG-flow должны считаться двумя разными acceptance-gate.

## Инцидент 2026-04-24: `📝 Заметка` молчит

Пользователь нажал кнопку `📝 Заметка`, но ответ `Напишите текст заметки` не пришёл.

Факты из VPS `72.56.4.61`:

- `journalctl -u vk-telegram-bot` показал `telegram.error.TimedOut` на update с текстом `📝 Заметка`;
- старый порядок был опасный: сначала `await reply_text("Напишите текст заметки")`, потом `waiting_for_note=True`;
- если Telegram API timeout-ил reply, handler падал до установки состояния, поэтому контур заметки реально ломался;
- отдельно подтверждён transport-level сбой: `curl -4/-6 -m 10 https://api.telegram.org` с VPS завершался timeout.

Применённый bounded fix:

- `waiting_for_note=True` ставится до отправки prompt;
- все ответы переведены на `safe_reply()` с 3 попытками и без падения handler-state;
- `run_polling(..., bootstrap_retries=-1, timeout=30)` добавлен, чтобы startup timeout не валил сервис в restart-loop;
- добавлен регрессионный тест `telegram-bot/tests/test_note_flow.py`: даже если Telegram reply timeout-ит трижды, состояние ожидания заметки остаётся выставленным.

# Цель

Вернуть Telegram-боту надёжный RAG-flow:

1. кнопки меню (`☕ Напитки`, `🍽️ Еда`, `📋 Стандарты`, `💰 Цены`, `👤 Персонал`) дают ответ из базы знаний;
2. свободный вопрос вроде `Как приготовить капучино?` возвращает содержательный ответ;
3. `📊 Статус` честно показывает состояние RAG API и индекса;
4. если RAG API падает, пользователь получает понятный fallback без ложного успеха.

# Scope

Входит:

- локальная диагностика `VK-offee/telegram-bot` и `VK-offee-rag`;
- проверка контрактов `/health` и `/query`;
- исправление RAG API или `rag_client.py`, если ошибка воспроизводится;
- smoke-test локально;
- при необходимости деплой на VPS `72.56.4.61`;
- обновление `WP-48` тестовым результатом.

Не входит:

- полный role-based redesign из `WP-46`;
- рабочий чат realtime analytics из `WP-86`;
- управленческие отчёты из `WP-59`;
- новая архитектура MCP сверх существующего FastAPI RAG.

# Acceptance

1. Локальный RAG API отвечает:
   - `GET /health` -> `status=healthy`;
   - `POST /query` -> HTTP 200 и ответ с `answer`, `routing`, `sources`.
2. Telegram bot RAG-клиент корректно обрабатывает успешный и ошибочный ответ API.
3. Note-flow устойчив к Telegram timeout:
   - `📝 Заметка` ставит `waiting_for_note` до отправки prompt;
   - `/note` без аргументов ставит `waiting_for_note` до отправки prompt;
   - timeout Telegram API не ломает состояние handler-а.
4. `WP-48` получает обновлённый чеклист по RAG:
   - кнопка `☕ Напитки`;
   - кнопка `📊 Статус`;
   - свободный вопрос `Как приготовить капучино?`.
5. Если вносятся изменения в VPS-контур, есть evidence:
   - systemd status;
   - проверка `/health`;
   - проверка `/query`;
   - при возможности живой Telegram smoke.

# Рабочий метод

1. Сначала прочитать факты и воспроизвести ошибку.
2. Не трогать продуктовый UX шире RAG-flow.
3. Исправлять минимальным bounded patch.
4. После исправления закрыть через scoped `close-task.sh`.

# Текущий verdict перед стартом

Лучший следующий шаг: после стабилизации note-flow проверить transport-route Telegram с VPS и затем вернуться к RAG `/query` acceptance.
