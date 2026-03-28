---
type: work-product
pack: PACK-exocortex-engineering
id: ENG.WP.003
title: Карточка VPS сервера VK-offee
created: 2026-03-28
status: active
---

# ENG.WP.003 — VPS Сервер VK-offee

## Основная информация

| Параметр | Значение |
|----------|---------|
| **Провайдер** | Timeweb Cloud |
| **Панель управления** | https://timeweb.cloud/my/servers/7150663 |
| **IP адрес** | 72.56.4.61 |
| **Тариф** | Cloud MSK 30 |
| **ОС** | Ubuntu 24.04.3 LTS |
| **CPU** | 1 × 3.3 GHz |
| **RAM** | 2 GB |
| **Диск** | 30 GB NVMe |
| **Цена** | 657 ₽/мес |
| **Оплата** | Пополнен на год (март 2026 — март 2027) |
| **Локация** | Москва (MSK) |

## Доступ

| Способ | Команда |
|--------|---------|
| **SSH** | `ssh root@72.56.4.61` |
| **SSH ключ** | `~/.ssh/id_ed25519` (claude-code@vk-offee) |
| **Пользователь** | root |

## Что запущено

| Сервис | Статус | Порт | Описание |
|--------|--------|------|---------|
| `vk-rag-api.service` | ✅ active | :8000 (localhost) | FastAPI RAG сервер |
| `vk-telegram-bot.service` | ✅ active | — | Telegram бот VK-offee v3.1 |

## Пути на сервере

```
/opt/vk-offee/
├── VK-offee/           ← git clone (Pack + бот)
│   └── telegram-bot/
│       ├── bot.py
│       └── .env        ← TELEGRAM_BOT_TOKEN
└── VK-offee-rag/       ← git clone (RAG API)
    ├── src/api.py
    ├── src/indexer.py
    ├── data/chroma/    ← ChromaDB
    └── .env            ← ANTHROPIC_API_KEY, OPENAI_API_KEY
```

## Полезные команды

```bash
# Статус сервисов
systemctl status vk-rag-api vk-telegram-bot

# Логи в реальном времени
journalctl -u vk-rag-api -f
journalctl -u vk-telegram-bot -f

# Перезапуск
systemctl restart vk-rag-api
systemctl restart vk-telegram-bot

# Обновление кода
cd /opt/vk-offee/VK-offee && git pull
cd /opt/vk-offee/VK-offee-rag && git pull
systemctl restart vk-rag-api vk-telegram-bot
```

## Известные проблемы

- OpenAI embeddings блокируются с российского IP (403 unsupported_country_region_territory)
  - Решение: настроить прокси для OpenAI или заменить на Anthropic embeddings
  - ChromaDB сейчас пустая — RAG поиск не работает, бот отвечает через Claude напрямую

## История

- **2026-03-28** — Сервер куплен и настроен. Деплой через deploy.sh. Оба сервиса запущены.
