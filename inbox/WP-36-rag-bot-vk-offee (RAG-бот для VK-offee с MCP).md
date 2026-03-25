---
type: work-package-context
id: WP-36
created: 2026-03-25
status: pending
budget: 8h
---

# РП#36: RAG-бот для VK-offee с MCP-сервером

## Цель

Создать умного Telegram-бота с RAG (Retrieval-Augmented Generation) для доступа к базе знаний VK-offee. Бот работает через MCP-сервер, независимо от ноутбука.

## Нанятые агенты

1. **MCP Builder** (`specialized/specialized-mcp-builder.md`) — разработка MCP-сервера
2. **AI Engineer** (`engineering/engineering-ai-engineer.md`) — RAG-архитектура
3. **Backend Architect** (`engineering/engineering-backend-architect.md`) — инфраструктура

## Архитектура

```
Telegram Bot → MCP Server → Vector DB (embeddings) → VK-offee Pack
                    ↓
              Claude API (RAG)
```

### Компоненты

1. **MCP Server** — инструменты для поиска в базе знаний
2. **Vector DB** — embeddings карточек из Pack
3. **Telegram Bot** — интерфейс для сотрудников
4. **Role-based меню** — разные роли видят разную информацию

## Что нужно сделать

### 1. MCP Server для VK-offee

Инструменты:
- `search_knowledge` — поиск по базе знаний (RAG)
- `get_card` — получить карточку по ID
- `search_by_role` — поиск по роли (бариста/официант/повар/менеджер)
- `get_invoice` — найти накладную
- `get_recipe` — найти рецепт/ТТК
- `calculate_cost` — себестоимость блюда
- `check_exocortex` — мониторинг экзокортекса (читает SESSION-OPEN.md)

### 2. Vector Database

- Embeddings всех карточек из Pack (concepts, entities, methods, work-products)
- Индексация по ролям
- Обновление при изменении Pack

### 3. Telegram Bot с меню

Роли:
- **Бариста** → рецепты напитков, работа с эспрессо, касса
- **Официант** → обслуживание гостей, воронка продаж, скрипты
- **Повар** → ТТК, заготовки, себестоимость
- **Менеджер** → смена, планирование, контроль, отчёты
- **Раннер** → доставка, координация

Команды:
- `/menu` — меню по роли
- `/search <запрос>` — поиск в базе знаний
- `/recipe <название>` — найти рецепт
- `/invoice <дата>` — найти накладную
- `/cost <блюдо>` — себестоимость
- `/exocortex` — полный мониторинг экзокортекса (стартовый экран на русском)

**Мониторинг экзокортекса:**
- Читает `DS-strategy/current/SESSION-OPEN (Экран открытия сессии).md`
- Показывает статус мозга (🟢/🟡/🔴)
- Статус всех агентов (strategist, extractor, synchronizer)
- Проблемы и действия
- Полный отчёт на русском языке

### 4. Деплой (независимо от ноутбука)

Варианты:
- Railway / Render / Fly.io (бесплатный tier)
- VPS (если нужна стабильность)
- Docker-контейнер

## Технологии

- **MCP SDK** — TypeScript/Python
- **Vector DB** — Qdrant / Chroma / Pinecone
- **Embeddings** — OpenAI / Anthropic
- **Telegram** — python-telegram-bot
- **Деплой** — Railway / Docker

## Границы

### Входит
- MCP-сервер с инструментами поиска
- Vector DB с embeddings Pack
- Telegram-бот с role-based меню
- Деплой на внешний сервер

### Не входит
- Аналитика выручки (отдельный РП)
- Интеграция с 1С/Saby (отдельный РП)
- Веб-интерфейс

## Критерий завершения

- MCP-сервер работает локально и на сервере
- Vector DB проиндексирована (все Pack)
- Telegram-бот отвечает на вопросы по базе знаний
- Role-based меню работает
- Деплой на внешний сервер (работает без ноутбука)

## Этапы

1. **Прототип MCP-сервера** (2h) — базовые инструменты
2. **Vector DB + embeddings** (2h) — индексация Pack
3. **Telegram-бот + меню** (2h) — интерфейс
4. **Деплой** (2h) — Railway/Docker
