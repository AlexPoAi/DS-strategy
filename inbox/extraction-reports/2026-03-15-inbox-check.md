---
type: extraction-report
source: inbox-check
date: 2026-03-15
status: pending-review
processed: 1
remaining: 0
---

# Extraction Report (Inbox-Check)

**Дата:** 2026-03-15
**Источник:** DS-strategy/inbox/captures.md
**Обработано captures:** 1 из 1
**Осталось:** 0

---

## Кандидат #1

**Источник capture:** РП: Русификация структуры Pack-репозиториев [source: сессия 2026-03-10]
**Сырой текст:** «Проблема: Структура Pack (PACK-kitchen, PACK-bar и др.) нечитаема для русскоязычных сотрудников. Папки названы на английском (01-domain-contract, 04-work-products), файлы с префиксами (KITCHEN.WP.001), нет логической группировки документов в 04-work-products. Требуется: русские названия папок, логическая группировка внутри 04-work-products, русские описания в названиях файлов, проверка всех 7 Pack.»
**Классификация:** wp

**Куда записать:**
- **Репо:** N/A — governance задача, не доменное знание Pack
- **Файл:** N/A
- **Действие:** defer — оформить как РП в DS-strategy/inbox/INBOX-TASKS.md

**Совместимость:**
- **Результат:** не входит в scope ни одного Pack
- **Проверено:** PACK-management/00-pack-manifest.md, PACK-cafe-operations/00-pack-manifest.md

**Вердикт:** defer
**Обоснование:** Это инфраструктурная/governance задача — изменение структуры именования всех Pack-репозиториев. Не является доменным знанием ни одного Pack. Аналогичен паттерну из feedback-log: «Стратегические приоритеты, решения о распределении ресурсов → DS-strategy, не Pack». Правильное место: DS-strategy как РП (рабочий план).

---

## Сводка

| Метрика | Значение |
|---------|----------|
| Captures обработано | 1 |
| Всего кандидатов | 1 |
| Accept | 0 |
| Reject | 0 |
| Defer | 1 |
| Осталось в inbox | 0 |
