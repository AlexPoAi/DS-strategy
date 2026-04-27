---
type: extraction-report
source: inbox-check
date: 2026-04-27
status: pending-review
processed: 5
remaining: 5
---

# Extraction Report (Inbox-Check)

**Дата:** 2026-04-27
**Источник:** DS-strategy/inbox/captures.md
**Обработано captures:** 5 из 10
**Осталось:** 5

---

## Кандидат #1

**Источник capture:** Стратегическая сессия 26 апреля: найти нового операционного менеджера как обязательный переходный ход
**Сырой текст:** «По роли операционного менеджера уже чувствуется риск ухода `Жанны`, поэтому поиск и подготовка нового менеджера становятся обязательным контуром устойчивости, а не факультативной задачей.»
**Классификация:** task

**Outcome:** rejected

**Куда направить:**
- **Репо/контур:** archive
- **Файл:** DS-strategy/inbox/archive/rejected/CO.reject.001-new-operational-manager-duplicate.md
- **Действие:** архивировать как duplicate reject

**Совместимость:**
- **Результат:** дубликат
- **Проверено:** DS-strategy/inbox/INBOX-TASKS.md; DS-strategy/inbox/WP-95-administrator-transition-and-role-materialization (Аккуратная замена Жанны и материализация роли администратора).md

**Готовый текст (ready-to-commit):**

~~~markdown
---
id: CO.reject.001
type: capture
status: rejected
reason: duplicate of active `WP-95` transition contour and in-progress backlog task
date: 2026-04-27
source: Стратегическая сессия 26 апреля: найти нового операционного менеджера как обязательный переходный ход
tags:
  - capture
  - rejected
  - duplicate
  - management
---

# Rejected Capture

Capture повторяет уже materialized transition-контур по замене `Жанны` и не добавляет нового маршрутизируемого содержания.
~~~

**Вердикт:** rejected
**Обоснование:** Новый менеджер уже является активным transition-контуром через `WP-95` и in-progress backlog. Этот capture не добавляет нового knowledge slice или следующего маршрута, поэтому корректнее archive reject, а не второй backlog item.

---

## Кандидат #2

**Источник capture:** Стратегическая сессия 26 апреля: идея онлайн-продукта Telegram-бот для бариста
**Сырой текст:** «Есть идея онлайн-продукта: `Telegram-бот для бариста` с базой знаний по настройке оборудования, помолу, практическим вопросам бариста-работы. Возможная модель монетизации: подписка около `59 руб./мес` + реклама. Это рассматривается как отдельный цифровой доходный луч.»
**Классификация:** wp

**Outcome:** backlog_task

**Куда направить:**
- **Репо/контур:** DS-strategy
- **Файл:** DS-strategy/inbox/INBOX-TASKS.md
- **Действие:** создать backlog task

**Совместимость:**
- **Результат:** совместим
- **Проверено:** DS-strategy/inbox/INBOX-TASKS.md

**Готовый текст (ready-to-commit):**

~~~markdown
- [pending] 2026-04-27: Оценить цифровой доходный луч `Telegram-бот для бариста`
  - Контекст: extracted from inbox-check 2026-04-27, кандидат #2
  - Источник: Стратегическая сессия 26 апреля: идея онлайн-продукта Telegram-бот для бариста
  - Outcome: backlog_task
  - Почему не Pack: это гипотеза нового цифрового продукта и канала монетизации, а не готовое Pack-knowledge
  - Следующий шаг: определить целевого пользователя, MVP-состав бота, реалистичную модель монетизации и критерий, по которому идея считается worth pursuing
  - Приоритет: medium
  - Бюджет: 30-60 мин
~~~

**Вердикт:** backlog_task
**Обоснование:** Capture задаёт новый цифровой доходный луч и требует проверки продукта, рынка и MVP. Это управленческая backlog-задача, а не Pack-знание.

---

## Кандидат #3

**Источник capture:** Стратегическая сессия 26 апреля: долгосрочная цель свободы переезда в Азию
**Сырой текст:** «Долгосрочная цель — подготовить почву для возможности уехать в Азию на полгода, работать без привязки к месту и VPN-ограничениям, и научиться зарабатывать так, чтобы не зависеть только от кофеен и локального присутствия.»
**Классификация:** entity

**Outcome:** recovery_item

**Куда направить:**
- **Репо/контур:** recovery-catalog
- **Файл:** DS-strategy/inbox/RECOVERY-CATALOG-LOST-INPUTS-2026-04-27.md
- **Действие:** добавить recovery entry

**Совместимость:**
- **Результат:** совместим
- **Проверено:** DS-strategy/inbox/WP-121-personal-ds-self-development-and-energy-contour (Личный DS саморазвития и контур энергии).md

**Готовый текст (ready-to-commit):**

~~~markdown
## Item 1

- Элемент: Долгосрочная цель свободы переезда в Азию на полгода с удалённой работой и меньшей зависимостью от локального кофейного контура
- Источник: `DS-strategy/inbox/captures.md` → `Стратегическая сессия 26 апреля: долгосрочная цель свободы переезда в Азию`
- Статус recovery: сохранено до materialization личного DS-контура
- Что нужно для возврата в контур: после запуска личного `DS` на базе `WP-121` решить, это north-star личной стратегии, backlog migration-plan или отдельный mobility/online-income work product
~~~

**Вердикт:** recovery_item
**Обоснование:** Capture нельзя терять, но у него пока нет устойчивого home-route в Pack или текущем backlog. До запуска личного DS-контурa его корректно удерживать в recovery-каталоге.

---

## Кандидат #4

**Источник capture:** Стратегическая сессия 26 апреля: нет слота саморазвития и падает энергия
**Сырой текст:** «Во время стратегической сессии зафиксирован важный личный сигнал: нет устойчивого слота саморазвития, есть неудовлетворённость этим, есть проблемы по питанию, мало энергии и падает продуктивность. Это не просто настроение, а контур, который влияет на всю исполнительную способность недели.»
**Классификация:** entity

**Outcome:** rejected

**Куда направить:**
- **Репо/контур:** archive
- **Файл:** DS-strategy/inbox/archive/rejected/CO.reject.002-self-development-energy-duplicate.md
- **Действие:** архивировать как duplicate reject

**Совместимость:**
- **Результат:** дубликат
- **Проверено:** DS-strategy/inbox/WP-121-personal-ds-self-development-and-energy-contour (Личный DS саморазвития и контур энергии).md

**Готовый текст (ready-to-commit):**

~~~markdown
---
id: CO.reject.002
type: capture
status: rejected
reason: duplicate support signal already captured in `WP-121`
date: 2026-04-27
source: Стратегическая сессия 26 апреля: нет слота саморазвития и падает энергия
tags:
  - capture
  - rejected
  - duplicate
  - personal
  - energy
---

# Rejected Capture

Сигнал уже вошёл в основание `WP-121` и не требует отдельного route поверх существующего личного DS-контура.
~~~

**Вердикт:** rejected
**Обоснование:** Этот сигнал уже дословно materialized внутри `WP-121` как причина открытия личного DS-контура. Отдельный повторный маршрут не нужен.

---

## Кандидат #5

**Источник capture:** Стратегическая сессия 26 апреля: нужен отдельный DS для саморазвития, личности и саморефлексии
**Сырой текст:** «Нужно создать отдельный `DS`, который будет касаться конкретно личности, саморазвития, переживаний, саморефлексии, энергии и питания. Этот контур должен иметь собственный дом в Obsidian-мозге и не теряться среди рабочих проектных контуров.»
**Классификация:** wp

**Outcome:** rejected

**Куда направить:**
- **Репо/контур:** archive
- **Файл:** DS-strategy/inbox/archive/rejected/CO.reject.003-personal-ds-duplicate.md
- **Действие:** архивировать как duplicate reject

**Совместимость:**
- **Результат:** дубликат
- **Проверено:** DS-strategy/inbox/INBOX-TASKS.md; DS-strategy/inbox/WP-121-personal-ds-self-development-and-energy-contour (Личный DS саморазвития и контур энергии).md; DS-strategy/inbox/extraction-reports/2026-04-27-inbox-check-2.md

**Готовый текст (ready-to-commit):**

~~~markdown
---
id: CO.reject.003
type: capture
status: rejected
reason: duplicate of personal DS route already opened via `WP-121`
date: 2026-04-27
source: Стратегическая сессия 26 апреля: нужен отдельный DS для саморазвития, личности и саморефлексии
tags:
  - capture
  - rejected
  - duplicate
  - personal
  - ds
---

# Rejected Capture

Capture дублирует уже проанализированный маршрут создания личного `DS` и не добавляет нового next route.
~~~

**Вердикт:** rejected
**Обоснование:** Route на личный DS уже был открыт предыдущим capture и переведён в backlog/WP-слой. Повторная формулировка не добавляет нового маршрутизируемого содержания.

---

## Сводка

| Метрика | Значение |
|---------|----------|
| Captures обработано | 5 |
| Всего кандидатов | 5 |
| Pack candidate | 0 |
| Backlog task | 1 |
| Recovery item | 1 |
| Rejected | 3 |
| Deferred | 0 |
| Осталось в inbox | 5 |
