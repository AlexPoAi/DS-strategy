---
type: work-product-context
rp: 30
title: Агентство ИИ-агентов — реестр + механизм найма + интеграция 179 агентов
status: in_progress
created: 2026-03-26
next-session: 2026-03-27
repo: DS-agent-workspace
---

# РП#30: Агентство ИИ-агентов

## Что уже сделано (2026-03-26)

### Механизм найма (HIRING-PROTOCOL.md) ✅
- Алгоритм 4 шага: задача → модель → проверить реестр → нанять / по умолчанию
- Правило расширения: 3+ записи одной роли в GAPS.md → создать агента
- Встроен в `memory/protocol-open.md` шаг 1б
- Ключевой вопрос: «Какой ИИ-агент из агентства может выполнить эту задачу?»

### Реестр (REGISTRY.md) ✅
- 6 агентов DS-агентства с карточками
- Матрица выбора агент/задача

### Карточки агентов ✅
- `vk-coffee-analyst.md` v2.0 — по новому формату (базовый слой + DS-слой)
- `environment-engineer.md` v1.0
- `park-architect.md` v1.0
- `hr-specialist.md` v1.0
- `strategist.md` v1.0
- `code-engineer.md` v1.0

### Шаблон карточки (AGENT-TEMPLATE.md) ✅
Двухслойная архитектура:
- **Базовый слой** (формат agency-agents): identity, mission, rules, workflow, deliverable, communication, success metrics
- **DS-слой** (наш): Pack-контекст, инструменты экосистемы, контракт найма, связанные агенты

### GAPS.md ✅
- Трекер пробелов — куда записывать роли без агентов

---

## Что осталось сделать (следующая сессия)

### 1. Пересоздать 5 карточек по новому формату v2.0
Сейчас только `vk-coffee-analyst.md` обновлён до v2.0. Остальные 5 — в старом кратком формате.

- `environment-engineer.md` → v2.0
- `park-architect.md` → v2.0
- `hr-specialist.md` → v2.0
- `strategist.md` → v2.0
- `code-engineer.md` → v2.0

### 2. Интеграция 179 агентов из agency-agents
Репо: `~/Github/agency-agents`
Структура: 14 категорий, 179 агентов .md

**Задача:** создать единый реестр всех агентов (6 наших + 179 из agency-agents) с возможностью поиска при найме.

**Варианты реализации (обсудить):**
- A: Добавить все 179 в REGISTRY.md (большая таблица с категориями)
- B: Хранить agency-agents как отдельный источник, при найме искать по нему
- C: Скрипт hire.sh — адаптировать их `hire.sh` для нашей системы

Категории agency-agents:
- engineering (frontend, backend, DevOps, testing)
- design (UX, UI, Brand, Visual)
- marketing (content, SEO, social)
- sales (coach, pipeline, discovery)
- strategy (business, product)
- product (PM, analytics)
- support (customer success)
- specialized
- academic
- paid-media
- project-management
- spatial-computing
- game-development
- integrations

### 3. Верховный HR-агент
Идея пользователя: единый агент, который знает весь реестр (6 + 179) и нанимает нужного агента при согласовании.

Алгоритм верховного HR:
1. Получает описание задачи
2. Ищет по всему реестру (наши + agency-agents)
3. Рекомендует 1-3 подходящих агента с обоснованием
4. Пользователь выбирает → агент нанят

---

## Структура артефактов

```
DS-agent-workspace/agency/
├── REGISTRY.md              ✅ реестр 6 агентов
├── HIRING-PROTOCOL.md       ✅ механизм найма
├── GAPS.md                  ✅ трекер пробелов
├── AGENT-TEMPLATE.md        ✅ шаблон карточки (двухслойный)
└── agents/
    ├── vk-coffee-analyst.md ✅ v2.0
    ├── environment-engineer.md (нужен v2.0)
    ├── park-architect.md       (нужен v2.0)
    ├── hr-specialist.md        (нужен v2.0)
    ├── strategist.md           (нужен v2.0)
    └── code-engineer.md        (нужен v2.0)

~/Github/agency-agents/      ← 179 агентов (форк, локально)
├── engineering/
├── design/
├── marketing/
├── sales/
├── strategy/
└── ... (14 категорий)
```

---

## Связанные файлы

- `DS-agent-workspace/agency/HIRING-PROTOCOL.md`
- `DS-agent-workspace/agency/REGISTRY.md`
- `DS-agent-workspace/agency/AGENT-TEMPLATE.md`
- `memory/protocol-open.md` (шаг 1б — найм агента)
- `~/Github/agency-agents/` (источник 179 агентов)
- `~/Github/agency-agents/hire.sh` (их механизм найма — изучить)

---

## Бюджет оставшейся работы

| Задача | ~Время |
|--------|--------|
| Пересоздать 5 карточек v2.0 | 1.5h |
| Интеграция 179 агентов | 2h |
| Верховный HR-агент | 1h |
| **Итого** | **~4.5h** |
