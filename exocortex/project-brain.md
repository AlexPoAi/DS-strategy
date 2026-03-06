# Project Brain — Экзокортекс Александра

> Единый мозг проекта. Читается при каждом Открытии сессии.
> Обновляется автоматически через close-task.sh.
> Последнее обновление: 2026-02-26

---

## Что это за система и зачем

Персональный экзокортекс — система, которая автоматически:
- Собирает мысли из Obsidian
- Обрабатывает их через агентов
- Формализует знания в базу (VK-offee)
- Планирует день/неделю через стратега
- Всё синхронизирует в GitHub

Цель: не терять ни одну мысль, видеть картину целиком, принимать решения на основе актуальных данных.

---

## Архитектурные решения (почему так)

**Почему wrapper для strategist:**
`strategist.sh` хардкодит `CLAUDE_PATH=/usr/local/bin/claude`. Менять шаблон FMT нежелательно (он платформенный). Решение: `strategist-wrapper.sh` переопределяет `CLAUDE_PATH` перед вызовом. Симлинк `/usr/local/bin/claude → /opt/homebrew/bin/claude` создан для совместимости.

**Почему scheduler — центральный диспетчер:**
Без него каждый агент работал независимо по своему расписанию. Риск: конфликты, дублирование, нет координации. Scheduler читает маркеры в `~/.local/state/exocortex/` и запускает агентов только когда нужно.

**Почему .nocloud не пушится:**
Obsidian vault содержит сырые мысли, личные заметки, черновики. Они не должны быть в публичном GitHub. После обработки через `strategy_session.py` — очищенные версии попадают в `creativ-convector` (GitHub).

**Почему Pack = source-of-truth:**
VK-offee — единственное место где знания формализованы и проверены. Все агенты читают оттуда. Downstream (creativ-convector) следует за Pack, не наоборот.

---

## Статус агентов (актуально)

| Агент | Статус | Расписание | Известные особенности |
|-------|--------|-----------|----------------------|
| `com.exocortex.scheduler` | ✅ exit 0 | 10 раз/день | Развёрнут 2026-02-26. Центральный диспетчер |
| `com.strategist.morning` | ✅ exit 0 | 4:00 ежедн. | Требует OAuth. Использует wrapper |
| `com.strategist.weekreview` | ✅ exit 0 | Пн 00:00 | Использует wrapper |
| `com.extractor.inbox-check` | ✅ exit 0 | каждые 3ч | До 2026-02-26 падал: Not logged in |
| `com.extractor.session-watcher` | ✅ exit 0 | каждые 5 мин | Снимает CLAUDECODE перед запуском |

**Критично:** Все агенты требуют активной OAuth сессии Claude. При сбросе авторизации — запустить `claude /login`.

---

## Ключевые пути

```
~/Github/DS-strategy/current/SESSION-CONTEXT.md  — живой контекст сессии
~/Github/DS-strategy/current/WeekPlan*.md         — план недели
~/Github/DS-strategy/inbox/captures.md            — pending captures для экстрактора
~/Github/DS-strategy/inbox/pending-sessions/      — очередь session-watcher
~/Documents/creativ-convector.nocloud/            — Obsidian vault (только локально)
~/.local/state/exocortex/                         — маркеры состояния scheduler
~/.config/aist/env                                — Telegram токены, API ключи
~/Github/close-task.sh                            — обязательный финиш задачи
~/Github/strategist-wrapper.sh                    — wrapper для CLAUDE_PATH
```

---

## Интеграции

| Интеграция | Статус | Как работает |
|-----------|--------|-------------|
| Obsidian → GitHub | ✅ | strategy_session.py копирует обработанные заметки |
| creativ-convector → DS-strategy | ✅ | run_session_import() кладёт в pending-sessions |
| DS-strategy → VK-offee | ✅ | extractor inbox-check формализует captures |
| Telegram уведомления | ⚠️ частично | notify.sh работает, но требует .config/aist/env |
| WakaTime | ⚠️ опционально | fetch-wakatime.sh в strategist, если не настроен — пропускает |

---

## История ключевых изменений
- **2026-03-06 19:54** — РП#6: Обработка ГПХ документов — формализованы HR.WP.001-004 (Бариста, Официант, Раннер, Повар), обновлена ставка стажировки Раннера (90→150 руб/час), создан ГПХ ПОВАР по аналогии с Бариста
- **2026-03-06 19:32** — session-tasks pipeline: создан промпт + обновлён extractor.sh + ГПХ оформлен как РП#6 в WeekPlan + анализ системных изменений в INBOX-TASKS
- **2026-03-05 22:31** — Сессия 05.03: РП#5 завершён (RAG-бот работает), Telegram бот запущен но не подключен к RAG. Записана срочная задача на завтра: интеграция RAG + Telegram (~30-60 мин). Безопасность ключей проверена и исправлена (права 600).
- **2026-03-05 22:22** — РП#5 завершён: RAG-бот для VK-offee создан и работает. Индексация 27 файлов (5 Pack), поиск через ChromaDB + OpenAI embeddings, генерация ответов через Claude API. Безопасность ключей проверена. 4 задачи развития записаны в inbox (MCP-сервер, Telegram бот, автообновление, API docs).
- **2026-03-04 19:58** — RAG-бот: найдено решение у наставника (DS-Knowledge-Index-Tseren). Текущее состояние: структурированный индекс Git+Markdown+YAML, RAG в планах развития. Обновлена задача в inbox с деталями и планом действий.
- **2026-03-04 19:56** — Проверка inbox задач: добавлены 2 новые задачи (архитектура Obsidian→Экстрактор, обработка архива). Проверено наличие готового RAG-бота у наставника - не найдено, требуется разработка с нуля. РП#4 перенесён на 07-08.03.
- **2026-03-04 19:50** — Сессия стратегирования: обновлены WeekPlan W09 и SESSION-CONTEXT с итогами 04.03. Проверена связка Obsidian → GitHub → Экстрактор: синхронизация работает, исчезающие заметки в GitHub, экстрактор активен. Добавлена задача в inbox: полная проверка цепочки стратегирования end-to-end.
- **2026-03-04 19:39** — Задача #5: Приведение названий файлов к стандарту ID-slug (Русское описание). Переименовано 17 файлов в PACK-kitchen (2 entities, 6 methods, 6 WP, 3 FM) и PACK-bar (1 entity). Теперь все файлы имеют английский slug для AI агентов и русское описание в скобках для сотрудников.
- **2026-03-04 19:34** — Задачи #2 и #3 из inbox: (1) Создан архив для необработанных материалов - скопированы БАР, Персонал, ДЛЯ ШЕФА в VK-offee/archive/ с README. (2) Модель оплаты труда поваров добавлена как KITCHEN.WP.006 и привязана к KITCHEN.METHOD.003. Добавлена задача конвертации CSV→MD в inbox.
- **2026-03-04 19:05** — РП#3: Развитие архитектуры VK-offee (5 Pack). Создана структура 5 Pack. PACK-kitchen полностью готов: 2 entities, 6 methods, 5 work products, 3 failure modes. PACK-bar, PACK-service, PACK-hr, PACK-management - созданы манифесты и структура папок. Добавлено правило #8 в CLAUDE.md о внеплановых задачах. Создан INBOX-TASKS.md для фиксации задач. 3 задачи записаны в inbox для последующей обработки.
- **2026-03-04 14:30** — РП#1: Оптимизация токенов — добавлено правило выбора модели в CLAUDE.md §2.6
- **2026-03-02 22:25** — РП#2: Проверка и валидация инфраструктуры экзокортекса - мердж upstream (25 коммитов), исправлены плейсхолдеры и права, агенты работают, добавлена таблица оптимизации токенов в MEMORY.md
- **2026-02-28 12:27** — Обновлена документация VK-offee: CLAUDE.md v3.0 с архитектурой 5 BC, создан ARCHITECTURE.md с полным обзором системы
- **2026-02-28 12:23** — Протестирована интеграция с экстрактором: routing.md содержит 5 Pack с ключевыми словами, маршрутизация работает корректно (тест: capture про капучино → PACK-bar, capture про график поваров → PACK-hr). Агенты inbox-check, session-watcher, scheduler работают (launchctl list). Добавлены 2 тестовых captures в inbox.
- **2026-02-28 12:18** — Мигрированы 4 файла из PACK-cafe-operations в PACK-kitchen: KITCHEN.METHOD.001 (изменение ингредиентов), KITCHEN.METHOD.002 (списание/переработка), KITCHEN.ENTITY.001 (концепция кухни), KITCHEN.WP.001 (производственная система STA). Все файлы с обновлёнными префиксами и меткой migrated_from.
- **2026-02-28 12:17** — Обновлён routing.md для 5 Pack: добавлены PACK-bar (бар, напитки, бариста), PACK-kitchen (кухня, блюда, повар), PACK-service (обслуживание, официант), PACK-management (управление сменой), PACK-hr (персонал, найм). Каждый Pack с ключевыми словами для автоматической маршрутизации экстрактором.
- **2026-02-28 12:15** — Создана структура 5 Pack для VK-offee: PACK-bar, PACK-kitchen, PACK-service, PACK-management, PACK-hr. Для каждого Pack созданы: директории (01-domain-contract, 02-domain-entities, 03-methods, 04-work-products, 05-failure-modes, 06-sota, 07-map) и 00-pack-manifest.md с границами домена, ролями и связями между BC.
- **2026-02-28 12:09** — Архитектурное проектирование VK-offee: создан ARCHITECTURE-DESIGN.md с 5 BC (bar, kitchen, service, management, hr), определены 3 системы (Suprasystem/SoI/Constructor), выделены ключевые сущности (8 ролей, 11 объектов, 8 методов), спроектирован Context Map, определена интеграция с экзокортексом и творческим конвейером
- **2026-02-26 20:20** — Протокол Close: SESSION-CONTEXT обновлён, WeekPlan W08 дополнен итогами 26.02, сессия закрыта
- **2026-02-26 20:12** — Создан DS-strategy/docs/ARCHITECTURE.md — человекочитаемая документация архитектуры экзокортекса
- **2026-02-26 19:58** — Системная проверка: исправлен sed→awk в close-task.sh, добавлен backup memory/ в DS-strategy/exocortex, добавлено правило для продолжения из summary в protocol-open.md
- **2026-02-26 19:54** — Создан project-brain.md (единый мозг проекта), обновлён close-task.sh (автозапись в brain), обновлён protocol-open.md (чтение brain при старте сессии)
- **2026-02-26** — Развёрнут `com.exocortex.scheduler`. Исправлены `{{WORKSPACE_DIR}}` плейсхолдеры в `strategist.sh` (строки 38, 151) и `scheduler.sh` (строка 19). Исправлен баг копирования сессий в Obsidian (`strategy_session.py`). OAuth login для launchd агентов.
- **2026-02-25** — Добавлен `strategist-wrapper.sh`. Исправлены plist для strategist (неверный путь DS-strategist). Добавлен шаг синхронизации контекста в protocol-open.md. Добавлен шаг обновления SESSION-CONTEXT в protocol-close.md.
- **2026-02-22** — Интеграция экзокортекса с VK-offee и creativ-convector.

---

## Незакрытые вопросы

- [ ] Synchronizer: `daily-report.sh` и `code-scan.sh` не тестировались
- [ ] Telegram уведомления: проверить работу notify.sh с реальными токенами
- [ ] Агенты strategist: `evening`, `note-review`, `day-close` — не развёрнуты как отдельные launchd (работают через scheduler)
- [ ] РП#5 — План РП по парку (дедлайн 27 фев)
