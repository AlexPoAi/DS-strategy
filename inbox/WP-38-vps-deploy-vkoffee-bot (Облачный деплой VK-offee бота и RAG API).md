---
type: work-product-context
wp_id: 38
title: Облачный деплой VK-offee бота + RAG API
created: 2026-03-27
status: pending
priority: high
---

# WP-38: Облачный деплой VK-offee бота + RAG API

## Цель

Перенести Telegram-бот и RAG API с локального Mac на облачный VPS чтобы бот работал автономно 24/7.

## Что уже готово (сделано сегодня)

- ✅ `telegram-bot/bot.py` v3.1 — полный рефакторинг, меню для сотрудников, RAG интеграция
- ✅ `telegram-bot/rag_client.py` — клиент с retry x3
- ✅ `VK-offee-rag/src/api.py` — FastAPI RAG сервер
- ✅ `VK-offee-rag/src/indexer.py` — 7 Pack, 126 файлов, 394 чанка
- ✅ ChromaDB локально заполнена (`VK-offee-rag/data/chroma/`)
- ✅ Всё запушено в GitHub (VK-offee: b822c41)

## Что нужно сделать (следующий шаг)

1. **Выбрать и купить VPS** — пользователь идёт регистрироваться
2. Получить IP сервера + root доступ (SSH)
3. Написать `deploy.sh`:
   - apt update, install Python 3.11, git, pip
   - clone VK-offee + VK-offee-rag
   - pip install -r requirements.txt
   - скопировать `.env` файлы (токены)
   - запустить переиндексацию
   - systemd-юниты для auto-restart
4. Протестировать бота в Telegram

## Выбор сервера

**Минимальные требования:**
```
RAM: 4GB (ChromaDB + RAG API + бот ≈ 1.5GB в работе)
SSD: 20GB+
CPU: 2 vCPU
OS:  Ubuntu 22.04 LTS
```

**Сравнение провайдеров (обновлено 2026-03-28, данные ~2025):**

| # | Провайдер | Локация | 4GB/2vCPU/40GB | Оплата ₽ | Риск санкций | Для нас |
|---|-----------|---------|----------------|----------|--------------|---------|
| 🥇 | **Timeweb Cloud** | 🇷🇺 Россия | ~500–600 ₽/мес | ✅ | ✅ нет | **Лучший выбор** — дёшево, надёжно, РФ-ЦОД |
| 🥈 | **RuVDS** | 🇷🇺 Москва | ~450–600 ₽/мес | ✅ | ✅ нет | Хорошая альтернатива |
| 🥉 | **Selectel** | 🇷🇺 Мск/СПб | ~900–1500 ₽/мес | ✅ | ✅ нет | Дороже, но enterprise-надёжность |
| 4 | **Aeza** | 🇳🇱🇫🇮🇩🇪 EU | ~$7–10/мес | ✅/крипта | ⚠️ частично | EU-серверы, риск блокировок РКН |
| 5 | **Hetzner** | 🇩🇪🇫🇮 EU | ~€3.79/мес | ❌ только €/$ | 🔴 высокий | **Не рекомендуется** — не регистрирует РФ |

**Итог:** Для бота кофейни — **Timeweb Cloud** или **RuVDS**. Российский ЦОД, рублёвая оплата, нет риска блокировки. Selectel если нужна гарантированная надёжность.

Сайты: [timeweb.cloud](https://timeweb.cloud) · [ruvds.com](https://ruvds.com) · [selectel.ru](https://selectel.ru)

## Архитектура на VPS

```
VPS (Ubuntu 22.04)
├── /opt/vk-offee/
│   ├── telegram-bot/        ← git clone VK-offee
│   │   ├── bot.py
│   │   ├── rag_client.py
│   │   └── .env             ← TELEGRAM_BOT_TOKEN
│   └── VK-offee-rag/        ← git clone VK-offee-rag
│       ├── src/api.py
│       ├── src/indexer.py
│       ├── data/chroma/     ← ChromaDB (persistent)
│       └── .env             ← ANTHROPIC_API_KEY, OPENAI_API_KEY
│
├── systemd/
│   ├── vk-rag-api.service   ← FastAPI на :8000 (localhost)
│   └── vk-telegram-bot.service
│
└── (опционально) MCP server для Claude Code
```

## Токены которые нужны на сервере

- `TELEGRAM_BOT_TOKEN` — из BotFather
- `ANTHROPIC_API_KEY` — для Claude (генерация ответов)
- `OPENAI_API_KEY` — для embeddings (text-embedding-3-small)
- `ANTHROPIC_BASE_URL` — https://dev.aiprime.store/api (если нужен прокси)

## Триггер продолжения

Когда пользователь скажет **«продолжи WP-38»** или **«деплой бота»** — показать эту карточку и начать с написания `deploy.sh`.

---
Агент: Code Engineer
Дата: 2026-03-27
Репо: VK-offee (telegram-bot), VK-offee-rag
Бюджет: ~2h
