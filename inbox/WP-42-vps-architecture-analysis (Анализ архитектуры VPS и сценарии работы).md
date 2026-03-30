---
type: work-product
id: WP-42
status: in_progress
created: 2026-03-30
domain: infrastructure
budget: 2h
---

# WP-42: Архитектура VPS и сценарии работы

## Контекст

VPS сервер 72.56.4.61 (Timeweb Moscow) уже развёрнут:
- ✅ Telegram бот VK-offee работает
- ✅ RAG API запущен
- ⚠️ ChromaDB пустая (OpenAI embeddings блокируются)
- ⚠️ Нет базы данных
- ⚠️ Нет агентов на сервере

## Цель

Спроектировать полную архитектуру использования VPS для:
1. Постоянная работа Telegram бота (24/7)
2. RAG API с рабочей индексацией
3. База данных для хранения данных
4. Возможность запуска агентов на сервере

---

## Часть 1: Текущее состояние

### Что работает

| Компонент | Статус | Порт | Процесс |
|-----------|--------|------|---------|
| Telegram бот | ✅ Работает | — | systemd service |
| RAG API | ✅ Работает | 8000 | systemd service |
| ChromaDB | ⚠️ Пустая | — | Встроена в RAG API |

### Что НЕ работает

1. **OpenAI embeddings блокируются** — 403 Forbidden с российского IP
2. **Нет базы данных** — негде хранить структурированные данные
3. **Нет агентов** — Claude Code работает только локально

---

## Часть 2: Архитектура решения

### 2.1 Embeddings (решение блокировки OpenAI)

**Проблема:** OpenAI API блокирует запросы с российских IP.

**Решение 1: Прокси для OpenAI (рекомендую)**
```bash
# В .env на VPS
OPENAI_BASE_URL=https://dev.aiprime.store/v1
OPENAI_API_KEY=<твой ключ>
```

**Плюсы:**
- Быстро (5 мин настройки)
- Работает как на Mac
- Качественные embeddings

**Минусы:**
- Зависимость от прокси

**Решение 2: Локальные embeddings (sentence-transformers)**
```python
from sentence_transformers import SentenceTransformer
model = SentenceTransformer('paraphrase-multilingual-MiniLM-L12-v2')
embeddings = model.encode(texts)
```

**Плюсы:**
- Без API, работает везде
- Бесплатно

**Минусы:**
- Медленнее
- Требует больше RAM (512MB+)
- Качество хуже чем OpenAI

**Рекомендация:** Начать с прокси (Решение 1), если не работает → локальные embeddings.

---

### 2.2 База данных

**Рекомендация: PostgreSQL на VPS**

```bash
# Установка
sudo apt install postgresql postgresql-contrib
sudo -u postgres createdb vkoffee
sudo -u postgres createuser vkoffee_user -P
```

**Схема:**
- menu_items (меню из Saby)
- sales (продажи)
- employees (сотрудники из PACK-hr)

---

### 2.3 Агенты на VPS

**Что МОЖНО:**
- Cron jobs (переиндексация RAG, sync с Saby)
- API endpoints (/api/search, /api/menu)
- Webhook handlers (GitHub → переиндексация)

**Что НЕЛЬЗЯ:**
- Claude Code агенты (требуют локальную FS + OAuth)

**Гибридная архитектура:**
```
Mac (Local)          VPS (Remote)
├─ Claude Code  ←──► ├─ Telegram Bot
├─ Strategist        ├─ RAG API
├─ Extractor         ├─ PostgreSQL
└─ Git repos         └─ Cron jobs
```

---

## Часть 3: Сценарии работы

### Сценарий 1: Telegram бот отвечает на вопросы

**Поток:**
1. Пользователь → Telegram бот (VPS)
2. Бот → RAG API (VPS)
3. RAG → ChromaDB поиск → Claude API
4. Ответ → пользователю

**Что нужно:**
- ✅ Бот работает
- ⚠️ Починить embeddings (прокси OpenAI)
- ⚠️ Переиндексировать ChromaDB

---

### Сценарий 2: Обновление меню из Saby

**Поток:**
1. Cron job (VPS) → Saby API
2. Получить меню/цены
3. Записать в PostgreSQL
4. Обновить RAG индекс

**Что нужно:**
- [ ] Установить PostgreSQL
- [ ] Создать скрипт sync_saby.py
- [ ] Настроить cron (каждые 6ч)

---

### Сценарий 3: Локальная разработка → деплой на VPS

**Поток:**
1. Разработка на Mac (Claude Code)
2. Commit → GitHub
3. GitHub webhook → VPS
4. VPS: git pull + restart services

**Что нужно:**
- [ ] Настроить GitHub webhook
- [ ] Создать deploy.sh на VPS
- [ ] Автоматический restart systemd

---

## Часть 4: План действий (приоритеты)

### Неделя 1 (критично)
1. **Починить embeddings** — добавить прокси OpenAI в .env
2. **Переиндексировать ChromaDB** — запустить indexer.py на VPS
3. **Протестировать бота** — проверить ответы на вопросы

### Неделя 2
4. **Установить PostgreSQL** — создать схему БД
5. **Интеграция с Saby API** — скрипт sync_saby.py
6. **Cron jobs** — автоматическая синхронизация

### Неделя 3
7. **GitHub webhook** — автодеплой при push
8. **Мониторинг** — логи, алерты, uptime

---

## Итого

**Готово:**
- Telegram бот (24/7)
- RAG API (работает)

**Нужно сделать:**
1. Прокси OpenAI → переиндексация (2h)
2. PostgreSQL + схема (1h)
3. Saby sync (2h)
4. GitHub webhook (1h)

**Итого:** ~6h работы для полной архитектуры.
