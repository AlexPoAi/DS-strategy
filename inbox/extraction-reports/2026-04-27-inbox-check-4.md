---
type: extraction-report
source: inbox-check
date: 2026-04-27
status: pending-review
processed: 5
remaining: 0
---

# Extraction Report (Inbox-Check)

**Дата:** 2026-04-27
**Источник:** DS-strategy/inbox/captures.md
**Обработано captures:** 5 из 5
**Осталось:** 0

---

## Кандидат #1

**Источник capture:** по проекту самио нужно открыть новый репо, определить как... [source: Telegram 2026-04-26]
**Сырой текст:** «по проекту самио нужно открыть новый репо, определить какие нужны агенты, возможно развернуть там новый иве, и можно уже сгружать тг чат наш простор.»
**Классификация:** wp

**Outcome:** rejected

**Куда направить:**
- **Репо/контур:** archive
- **Файл:** DS-strategy/inbox/archive/rejected/CO.reject.004-samir-repo-duplicate.md
- **Действие:** архивировать как duplicate reject

**Совместимость:**
- **Результат:** дубликат
- **Проверено:** DS-strategy/inbox/INBOX-TASKS.md

**Готовый текст (ready-to-commit):**

~~~markdown
---
id: CO.reject.004
type: capture
status: rejected
reason: duplicate of active backlog task for opening Samir repo and system contour
date: 2026-04-27
source: по проекту самио нужно открыть новый репо, определить как... [source: Telegram 2026-04-26]
tags:
  - capture
  - rejected
  - duplicate
  - samir
---

# Rejected Capture

Capture повторяет уже открытый backlog-route по запуску нового repo `Самир` и не добавляет нового маршрутизируемого содержания.
~~~

**Вердикт:** rejected
**Обоснование:** Route по открытию нового repo `Самир`, выбору агентов и стартового системного контура уже открыт в backlog. Новый capture не добавляет нового bounded route.

---

## Кандидат #2

**Источник capture:** Проработка стекляшки как ее использовать пока нет денег е... [source: Telegram 2026-04-26]
**Сырой текст:** «Проработка стекляшки как ее использовать пока нет денег ей заниматься»
**Классификация:** wp

**Outcome:** rejected

**Куда направить:**
- **Репо/контур:** archive
- **Файл:** DS-strategy/inbox/archive/rejected/CO.reject.005-steklyashka-duplicate.md
- **Действие:** архивировать как duplicate reject

**Совместимость:**
- **Результат:** дубликат
- **Проверено:** DS-strategy/inbox/INBOX-TASKS.md

**Готовый текст (ready-to-commit):**

~~~markdown
---
id: CO.reject.005
type: capture
status: rejected
reason: duplicate of active backlog task for temporary use of `стекляшка`
date: 2026-04-27
source: Проработка стекляшки как ее использовать пока нет денег е... [source: Telegram 2026-04-26]
tags:
  - capture
  - rejected
  - duplicate
  - park
  - terra
---

# Rejected Capture

Capture повторяет уже открытый backlog-route по временной доходной эксплуатации `стекляшка` до основного запуска `Парка`.
~~~

**Вердикт:** rejected
**Обоснование:** В backlog уже есть route на legal feasibility, модели использования и cash-support роль `стекляшка`. Этот capture сжимает ту же мысль и не создаёт новый маршрут.

---

## Кандидат #3

**Источник capture:** Поиск онлайн заработка или проекта который может заработа... [source: Telegram 2026-04-26]
**Сырой текст:** «Поиск онлайн заработка или проекта который может заработать 300 т и более»
**Классификация:** wp

**Outcome:** backlog_task

**Куда направить:**
- **Репо/контур:** DS-strategy
- **Файл:** DS-strategy/inbox/INBOX-TASKS.md
- **Действие:** создать backlog task

**Совместимость:**
- **Результат:** совместим
- **Проверено:** DS-strategy/inbox/INBOX-TASKS.md; DS-strategy/inbox/RECOVERY-CATALOG-LOST-INPUTS-2026-04-27.md

**Готовый текст (ready-to-commit):**

~~~markdown
- [pending] 2026-04-27: Исследовать онлайн-доходный проект с потенциалом `300k+`
  - Контекст: extracted from inbox-check 2026-04-27, кандидат #3
  - Источник: Поиск онлайн заработка или проекта который может заработа...
  - Outcome: backlog_task
  - Почему не Pack: это growth/strategy exploration по новому доходному лучу, а не устойчивое Pack-knowledge
  - Следующий шаг: собрать 3-5 реалистичных online-income направлений или проектов, оценить их по time-to-cash, требуемым ресурсам и вероятности выйти на `300k+`
  - Приоритет: medium
  - Бюджет: 30-60 мин
~~~

**Вердикт:** backlog_task
**Обоснование:** Capture задаёт новый стратегический поиск доходного луча и требует управленческой проработки. Это backlog-задача, не Pack и не recovery.

---

## Кандидат #4

**Источник capture:** Возможно так будет виднее по устройству экзокортекса это ... [source: Telegram 2026-04-26]
**Сырой текст:** «Возможно так будет виднее по устройству экзокортекса это возможность увидеть не только в голове но и визуально, как раз в голове картинка не сложилось»
**Классификация:** wp

**Outcome:** rejected

**Куда направить:**
- **Репо/контур:** archive
- **Файл:** DS-strategy/inbox/archive/rejected/CO.reject.006-exocortex-visual-map-duplicate.md
- **Действие:** архивировать как duplicate reject

**Совместимость:**
- **Результат:** дубликат
- **Проверено:** DS-strategy/inbox/INBOX-TASKS.md; DS-strategy/inbox/WP-23-end-to-end-control-map (Карта сквозного контроля экзокортекса).md; DS-strategy/inbox/WP-99-obsidian-human-brain-layer-and-strategist-human-interface (Obsidian как мозг: человеческий слой для Extractor и Strategist).md

**Готовый текст (ready-to-commit):**

~~~markdown
---
id: CO.reject.006
type: capture
status: rejected
reason: duplicate of active backlog task for exocortex visual map
date: 2026-04-27
source: Возможно так будет виднее по устройству экзокортекса это ... [source: Telegram 2026-04-26]
tags:
  - capture
  - rejected
  - duplicate
  - exocortex
  - visual-map
---

# Rejected Capture

Capture повторяет уже открытый backlog-route на визуальную карту экзокортекса и не добавляет нового next route.
~~~

**Вердикт:** rejected
**Обоснование:** Visual-map route уже открыт отдельной backlog-задачей. Этот capture лишь повторяет мотивацию, но не добавляет новый deliverable или другой маршрут.

---

## Кандидат #5

**Источник capture:** Нарисовать графическую карту по уровням системы, сделать ... [source: Telegram 2026-04-26]
**Сырой текст:** «Нарисовать графическую карту по уровням системы, сделать визуализацию уровней. На каком уровне какие агенты работают»
**Классификация:** wp

**Outcome:** rejected

**Куда направить:**
- **Репо/контур:** archive
- **Файл:** DS-strategy/inbox/archive/rejected/CO.reject.007-system-levels-visual-map-duplicate.md
- **Действие:** архивировать как duplicate reject

**Совместимость:**
- **Результат:** дубликат
- **Проверено:** DS-strategy/inbox/INBOX-TASKS.md; DS-strategy/inbox/WP-23-end-to-end-control-map (Карта сквозного контроля экзокортекса).md; DS-strategy/inbox/WP-99-obsidian-human-brain-layer-and-strategist-human-interface (Obsidian как мозг: человеческий слой для Extractor и Strategist).md

**Готовый текст (ready-to-commit):**

~~~markdown
---
id: CO.reject.007
type: capture
status: rejected
reason: duplicate of active backlog task for system-level exocortex visualization
date: 2026-04-27
source: Нарисовать графическую карту по уровням системы, сделать ... [source: Telegram 2026-04-26]
tags:
  - capture
  - rejected
  - duplicate
  - exocortex
  - visual-map
  - agents
---

# Rejected Capture

Capture конкретизирует тот же уже открытый visual-map route по уровням системы и агентам, но нового самостоятельного маршрута не создаёт.
~~~

**Вердикт:** rejected
**Обоснование:** Это уточнение уже открытого visual-map route, а не новый route. В текущем headless cycle правильнее archive reject, чтобы не плодить дубли в backlog.

---

## Сводка

| Метрика | Значение |
|---------|----------|
| Captures обработано | 5 |
| Всего кандидатов | 5 |
| Pack candidate | 0 |
| Backlog task | 1 |
| Recovery item | 0 |
| Rejected | 4 |
| Deferred | 0 |
| Осталось в inbox | 0 |
