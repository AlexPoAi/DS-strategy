---
type: extraction-report
source: inbox-check
date: 2026-05-06
status: pending-review
processed: 5
remaining: 1
---

# Extraction Report (Inbox-Check)

**Дата:** 2026-05-06
**Источник:** DS-strategy/inbox/captures.md
**Обработано captures:** 5 из 6
**Осталось:** 1

---

## Кандидат #1

**Источник capture:** role::assistant<span style="font-size: small;"> (openai@gpt-4.1-mini)</span>
**Сырой текст:** «Понял задачу! Вот примерный план действий для организации работы с Кристиной по ведению Instagram и созданию продвижения в интернете:»
**Классификация:** wp

**Куда записать:**
- **Репо:** n/a
- **Файл:** n/a
- **Действие:** не создавать артефакт

**Совместимость:**
- **Результат:** противоречит
- **Проверено:** FMT-exocortex-template/roles/extractor/config/routing.md; FMT-exocortex-template/roles/extractor/config/feedback-log.md; DS-strategy/inbox/INBOX-TASKS.md

**Готовый текст (ready-to-commit):**

~~~markdown
N/A — это не первичный capture, а импортированный заголовок ответа ассистента. Он не задаёт самостоятельный knowledge artifact и нарушает truthful boundary между source capture и machine-generated decomposition.
~~~

**Вердикт:** reject
**Обоснование:** Заголовок `role::assistant` является шумом импорта из Obsidian/ChatGPT-plugin блока, а не пользовательским знанием. Формализовывать его как Pack или DS artifact нельзя.

---

## Кандидат #2

**Источник capture:** 1. Уточнение условий сотрудничества с Кристиной
**Сырой текст:** «Определить формат работы: какой объем работы включает ведение Instagram (количество постов, сторис, видео). Обсудить варианты оплаты: фиксированная цена за месяц, за пост, по результату. Согласовать обязанности: создание контента, взаимодействие с аудиторией, подготовка аналитики и отчетов.»
**Классификация:** wp

**Куда записать:**
- **Репо:** n/a
- **Файл:** n/a
- **Действие:** не создавать отдельный артефакт

**Совместимость:**
- **Результат:** уточняет
- **Проверено:** FMT-exocortex-template/roles/extractor/config/routing.md; FMT-exocortex-template/roles/extractor/config/feedback-log.md; DS-strategy/inbox/INBOX-TASKS.md

**Готовый текст (ready-to-commit):**

~~~markdown
N/A — пункт является производной декомпозицией из импортированного assistant-response, а не отдельным capture. Если этот operational follow-up нужен, его следует заводить вручную как backlog-task рядом с Instagram contour, а не как extraction candidate из inbox.
~~~

**Вердикт:** reject
**Обоснование:** Пункт не является исходным знанием: он сгенерирован ассистентом поверх capture про Кристину и Instagram. Headless inbox-check не должен превращать машинную декомпозицию в новый knowledge artifact.

---

## Кандидат #3

**Источник capture:** 2. Создание и регистрация нового домена
**Сырой текст:** «Подобрать и зарегистрировать доменное имя, связанное с направлением продвижения. Обеспечить базовую структуру сайта. Настроить интеграцию сайта с соцсетями и инструментами аналитики.»
**Классификация:** wp

**Куда записать:**
- **Репо:** n/a
- **Файл:** n/a
- **Действие:** не создавать артефакт

**Совместимость:**
- **Результат:** противоречит
- **Проверено:** FMT-exocortex-template/roles/extractor/config/routing.md; DS-strategy/inbox/captures.md (строки исходного Obsidian capture); DS-strategy/inbox/INBOX-TASKS.md

**Готовый текст (ready-to-commit):**

~~~markdown
N/A — assistant subheading добавляет DNS/site-registration трактовку, которой нет в исходном capture. Это не truthful extraction, а расширительная интерпретация.
~~~

**Вердикт:** reject
**Обоснование:** Исходный capture говорил о домене продвижения/контуре работы, а не о регистрации доменного имени и сайта. Пункт добавляет новую трактовку, поэтому не может быть честно предложен как extraction candidate.

---

## Кандидат #4

**Источник capture:** 3. Организация команды агентов под домен
**Сырой текст:** «Определить роли и зоны ответственности агентов. Создать каналы коммуникации для совместной работы. Сформулировать цели агентов: генерация идей для контента, написание описаний к заданиям для съемок.»
**Классификация:** wp

**Куда записать:**
- **Репо:** n/a
- **Файл:** n/a
- **Действие:** не создавать артефакт

**Совместимость:**
- **Результат:** дубликат
- **Проверено:** FMT-exocortex-template/roles/extractor/config/feedback-log.md; DS-agent-workspace/agency/REGISTRY-EXTENDED.md; DS-strategy/inbox/INBOX-TASKS.md

**Готовый текст (ready-to-commit):**

~~~markdown
N/A — пункт попадает в уже известный governance/agent-layer pattern: предложение создать агентный контур без нового bounded contract. В feedback-log уже есть reject по похожему паттерну про предметных агентов/skill-layer.
~~~

**Вердикт:** reject
**Обоснование:** Это governance/agent-design декомпозиция без нового контракта. Паттерн уже отклонялся в feedback-log, а сами marketing-agent роли уже существуют в `DS-agent-workspace`.

---

## Кандидат #5

**Источник capture:** 4. Создание контент-плана
**Сырой текст:** «Продумать тематику постов: образовательный, развлекательный, промо-контент. Распределить частоту публикаций и формат материалов. Внести ключевые даты для планирования спецматериалов. Учитывать обратную связь и аналитику для корректировки плана.»
**Классификация:** wp

**Куда записать:**
- **Репо:** n/a
- **Файл:** n/a
- **Действие:** не создавать второй артефакт

**Совместимость:**
- **Результат:** дубликат
- **Проверено:** DS-strategy/inbox/INBOX-TASKS.md; FMT-exocortex-template/roles/extractor/config/routing.md; FMT-exocortex-template/roles/extractor/config/feedback-log.md

**Готовый текст (ready-to-commit):**

~~~markdown
N/A — тема контент-плана уже входит в существующий Instagram backlog (`Проработать решение ведения Instagram с помощью AI`, `Проработать вопрос с Instagram для точек`). Этот assistant-generated пункт не добавляет нового bounded delta.
~~~

**Вердикт:** reject
**Обоснование:** Пункт дублирует уже зафиксированный backlog по Instagram и одновременно является машинной декомпозицией из импортированного ответа. Новый knowledge artifact из него не следует.

---

## Сводка

| Метрика | Значение |
|---------|----------|
| Captures обработано | 5 |
| Всего кандидатов | 5 |
| Accept | 0 |
| Reject | 5 |
| Defer | 0 |
| Осталось в inbox | 1 |
