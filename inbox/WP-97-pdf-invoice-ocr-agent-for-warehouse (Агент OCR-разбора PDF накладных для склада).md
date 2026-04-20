---
type: work-product
id: WP-97
status: open
priority: high
created: 2026-04-20
updated: 2026-04-20
owner: Engineer
domain: warehouse
---

# WP-97 — Агент OCR-разбора PDF накладных для склада

## Зачем

Складской контур VK Coffee получает накладные в `PDF`.
Пока нет качественного OCR/SKU-разбора, кладовщик видит только часть управленческой картины:
- не умеет надёжно сравнивать цену поставки к поставке,
- не вытаскивает SKU-level историю закупки,
- не может автоматически собирать рост/снижение цены по поставщикам,
- не может уверенно формировать закупочный контур по PDF как по первичному источнику.

## Что нужно создать

Отдельный качественный инструмент / агент:
`Warehouse PDF Invoice OCR Analyst`

## Его вход

- PDF-накладные из папки склада
- архив прошлых накладных
- supplier directory
- словарь SKU / alias / supplier matches

## Его выход

1. Нормализованная таблица строк накладной:
- дата
- номер накладной
- поставщик
- SKU
- сырой текст позиции
- нормализованное название
- количество
- единица измерения
- цена за единицу
- сумма
- confidence

2. Управленческие артефакты:
- рост/снижение цены по поставщику
- динамика цены по SKU
- новые SKU / исчезнувшие SKU
- missing invoice data / ambiguous OCR

3. Поддержка кладовщика:
- feed для сравнения поставка-к-поставке
- feed для supplier cards
- feed для менеджерского warehouse-report

## Quality bar

- не просто text extraction, а line-item extraction
- OCR должен уметь переживать плохой PDF
- должна быть confidence-модель
- всё спорное обязано идти в `manual review`
- выход должен быть пригоден для price delta анализа

## Этапы реализации

1. OCR extraction layer
2. line segmentation layer
3. supplier / date / invoice number extraction
4. SKU normalization layer
5. price history ledger
6. manager-facing price delta digest

## Truthful status

Пока это ещё не реализованный production-agent.
Сейчас открывается отдельным рабочим продуктом как high-priority next layer для склада.
