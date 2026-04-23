---
type: work-product
id: WP-97
status: open
priority: high
created: 2026-04-20
updated: 2026-04-21
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

## Slice 2026-04-21 — ABC + PDF hardening

### Согласованный исполнитель

Основной агент:
`Warehouse Demand Analyst`

Инженер в этом РП:
- не подменяет доменного агента;
- не нанимает новый постоянный агентный контур;
- усиливает skill, метод и pipeline вокруг кладовщика.

### Согласованный scope

1. Стабилизировать weekly intake для `ABC`:
- находить актуальный `ABC`-файл;
- извлекать правильный лист/таблицу;
- нормализовать SKU;
- жёстко логировать unmatched/ambiguous позиции;
- использовать `A/B/C` в manager-facing приоритете закупки.

2. Создать production-minded каскад для `PDF`-накладных:
- сначала определять `text PDF` vs `scanned PDF`;
- для text PDF использовать table/text extraction;
- для scanned PDF использовать OCR + confidence;
- собирать line-item ledger, а не preview text;
- выводить спорные строки только в `manual review`.

### Целевой результат slice

- `ABC` перестаёт быть случайным входом и становится регулярным приоритетным сигналом.
- `PDF`-накладные становятся пригодным источником для price delta и supplier evidence.
- Кладовщик получает новый capability-слой, а не временный обходной костыль.

### Truthful критерий завершения

Этот РП не считается завершённым, пока не появятся оба признака:
- хотя бы один стабильный прогон `ABC` -> decision layer;
- хотя бы один качественный `PDF invoice` parse -> line items / supplier / date / price / confidence.

## Прогресс 2026-04-21 — post-refactor verdict

### Что уже materialized

- Кладовщик переведён на supplier-card формат в верхнем слое:
  - `WH.REPORT.002`
  - `WH.SESSION.001`
  - Telegram digest
- Контакт и канал поставщика больше не дублируются на каждой строке SKU.
- `ABC`-парсер усилен:
  - `xlsx` читается по листам;
  - выбирается лучший лист по quality signal;
  - сохраняются `sheet / status / matched / unmatched`.

### Что truthful ещё не готово

- `ABC` ещё не проходит как живой factual input через intake и поэтому не влияет на manager-report в production-цикле.
- `PDF`-накладные всё ещё остаются на уровне text extraction / header metrics, а не line-item extraction.
- Price delta по накладным ещё не опирается на invoice ledger.

### Следующие bounded улучшения

1. Довести `ABC` до реального intake-path в pipeline.
2. Привязать `ABC` evidence к `manual review`, если matched/unmatched плохого качества.
3. Реализовать `PDF invoice cascade` до строк накладной.
4. После этого пересобрать кладовщика и заново оценить manager-layer уже на обогащённом входе.

## Прогресс 2026-04-21 — corrected finding по ABC intake

### Что подтверждено live-check'ом

- Файлы `ABC анализ1.xlsx` и `ABC анализ2.xlsx` физически найдены в рабочем Google Drive контуре склада.
- Они были ошибочно сложены в `Обработано`, а не в `Новые документы`, поэтому старый intake их не подхватывал.
- Intake-path починен:
  - `ABC` возвращён в `Новые документы`;
  - warehouse sync теперь читает весь warehouse root, а не только intake-подпапку;
  - `.xlsx` и `pdf` гарантированно материализуются локально в warehouse knowledge-base.

### Correction

- Предыдущий вывод про `header-only ABC` был ошибочным.
- Root-cause оказался в нашем `xlsx -> csv` слое: `openpyxl` в режиме `read_only=True` у этих файлов видел только первые `10` строк и обрезал всю табличную часть.
- После переключения на normal mode таблица читается корректно:
  - `ABC анализ1.xlsx` -> `70` строк;
  - `ABC анализ2.xlsx` -> `314` строк.
- После live sync `ABC` снова вошёл в warehouse decision-layer, и production summary показал `320` SKU с `ABC`-категорией.

### Следующий правильный шаг

1. Удержать новый `xlsx`-reader как production-default для warehouse intake.
2. Проверить, какие SKU из low-stock всё ещё не получают `ABC`-категорию и почему.
3. Параллельно продолжать `PDF invoice -> line items` слой.

## Iteration 2026-04-23 - Low-stock coverage and ABC fallback

### Что truthfully сделано

- Найден главный дефект decision-layer: кладовщик сам обрезал low-stock слой до первых `3` SKU ещё на уровне `insight["top_low_items"]`, из-за чего заявка поставщикам была искусственно узкой.
- Убран этот clipping в `warehouse_reports_pipeline.py`, а order-loop больше не режется на первых `12` позициях до расчёта решения.
- Добавлен `family-level ABC fallback`: для drip SKU и похожих позиций `ABC` теперь может подтягиваться по семейству товара, а не только по полному строковому совпадению.
- `xlsx`-reader дополнительно выровнен на normal mode (`read_only=False`) как production-default для складского intake.

### Ручная проверка

- Выполнен manual-run:
  - `python3 PACK-warehouse/tools/warehouse_reports_pipeline.py --hours 720 --manual`
- Итог manual-check:
  - `SKU с остатками в анализе` выросли с `3` до `55`;
  - `Тэйсти Кофе` теперь получает широкую готовую заявку, а не только `3` drip-позиции;
  - в отчёте больше нет артефакта `капельница`, текущий manager-layer использует `дрип`/`Drip`-формат.

### Truthful verdict по состоянию после итерации

- Прогресс реальный: кладовщик перестал терять основную массу low-stock SKU.
- Но контур ещё не идеален:
  - supplier-routing для части SKU всё ещё падает в `Уточнить у Жанны`;
  - `UNICAVA` и `Субмарина` пока без подтверждённого канала заказа;
  - `PDF -> price delta ledger` всё ещё не доведён до production-ready слоя.

### Следующий bounded step

1. Дожать supplier mapping для `Уточнить у Жанны`, `UNICAVA`, `Субмарина`.
2. Продолжить `PDF invoice -> line items -> price delta`.
3. Потом ещё раз перепроверить, не перегружен ли supplier-order block лишними позициями и нужен ли category-aware compression.

## End-of-day 2026-04-23

### Что truthfully закрыто сегодня

- Исправлен главный дефект decision-layer: low-stock покрытие выросло с `3` до `55` SKU.
- `Тэйсти Кофе` теперь получает materially wider supplier-order block, а не урезанную заявку на несколько позиций.
- Добавлен `family-level ABC fallback`, поэтому часть drip SKU перестала выпадать из decision-layer при несовпадении полного названия.
- Выполнен manual-check:
  - `python3 PACK-warehouse/tools/warehouse_reports_pipeline.py --hours 720 --manual`
  - текущий manager-report и decision-queue пересобраны на живых данных.

### Что не закрыто и уходит в carry-over

- supplier-routing для части SKU всё ещё падает в `Уточнить у Жанны`;
- нет подтверждённых каналов заказа для `UNICAVA` и `Субмарина`;
- `PDF -> line items -> price delta ledger` остаётся главным незавершённым bounded slice;
- `WP-97` не закрыт, а честно остаётся открытым carry-over РП.

### Старт следующей итерации

1. Дожать supplier mapping для `UNICAVA`, `Субмарина` и `Уточнить у Жанны`.
2. После этого перейти в `PDF invoice -> price delta ledger`.

## Iteration 2026-04-23 - Supplier routing refinement

### Что truthfully сделано

- Усилен supplier-routing слой кладовщика:
  - часть зерновых SKU (`Бэрри 250`, `Фрутти 250`, `Коста Рика Сан Хосе 1 Кг`, `Эфиопия Мукера 120 Часов 250 Гр` и др.) теперь автоматически уходит в `Тэйсти Кофе`, а не в `Уточнить у Жанны`;
  - часть шоколадных SKU (`плитки`, `какао классический`) теперь уходит в `UNICAVA`.
- Убран шум `TBD TBD` из supplier-channel layer: если контакта нет, канал теперь честно отображается как `TBD`, а не как сдвоенный мусор.
- Выполнен manual-run:
  - `python3 PACK-warehouse/tools/warehouse_reports_pipeline.py --hours 720 --manual`

### Результат ручной проверки

- В manager-report больше нет supplier-блока `Уточнить у Жанны`.
- В decision queue остались только реальные supplier buckets:
  - `UNICAVA`
  - `Субмарина`
  - `Тэйсти Кофе`
- `UNICAVA` и `Субмарина` всё ещё без подтверждённых каналов заказа, но это уже factual gap, а не routing noise.

### Truthful verdict

- Прогресс реальный: supplier mapping стал заметно лучше и чище.
- Но `WP-97` всё ещё не закрыт:
  - `UNICAVA` и `Субмарина` требуют подтверждённых каналов;
  - supplier-order block `Тэйсти Кофе` уже просит следующего category-aware compression;
  - `PDF -> price delta ledger` остаётся главным незакрытым bounded slice.

## Iteration 2026-04-23 - PDF invoice line-items into manager report

### Что truthfully сделано

- В `кладовщика` встроен line-item слой по PDF-накладным:
  - разбор invoice blocks;
  - извлечение строк товара, цены, количества и даты накладной;
  - dedupe PDF по canonical key;
  - построение `price delta` по двум последним найденным ценам на один и тот же SKU у поставщика.
- `Изменение цен` в manager-report теперь строится не только по каталогам, а в первую очередь по реальным PDF-накладным.
- Выполнен manual-run:
  - `python3 PACK-warehouse/tools/warehouse_reports_pipeline.py --hours 720 --manual`

### Результат ручной проверки

- В актуальном `WH.REPORT.002` появился живой блок `Изменение цен`.
- Примеры сигналов из PDF:
  - `МФУД: Соба / Удон с курицей Мфуд (180.00 -> 215.00) (+19.4%)`
  - `Барсервис: Сироп (Закуп), на розлив (840.00 -> 930.00) (+10.7%)`
  - `Тэйсти Кофе: Tasty Coffee, моносорт эспрессо (322.38 -> 349.02) (+8.3%)`
- Это уже подтверждает, что PDF-контур перестал быть только текстовым превью и начал давать управленческий сигнал по ценам.

### Truthful verdict

- Да, PDF-слой стал materially полезнее.
- Но `WP-97` ещё не закрыт:
  - price delta пока строится по простому last-two comparison и ещё требует фильтрации аномалий;
  - не все extracted price changes одинаково manager-ready;
  - supplier channels для `UNICAVA` и `Субмарина` всё ещё не подтверждены.

## End-of-day 2026-04-21

### Что truthfully закрыто сегодня

- `ABC intake` доведён до production-уровня:
  - найден и исправлен root-cause в `xlsx`-reader;
  - live sync подтверждён;
  - `ABC` снова вошёл в manager report (`320` SKU с ABC-категорией).
- `PDF invoice` слой улучшен:
  - убран header-noise из item names;
  - снят duplicate effect по одинаковым PDF из разных папок;
  - supplier cards и `WH.WP.007` пересобраны на более честной базе.
- Агент `Warehouse Demand Analyst` усилен отдельными skill-слоями:
  - spreadsheet ingestion excellence;
  - ABC intake and matching;
  - PDF line-item intelligence.

### Что не закрыто и идёт carry-over на завтра

- Не все `low-stock` позиции уже получили корректный `ABC`-match.
- `PDF` всё ещё не доведён до полноценного `price delta ledger`.
- Нужен следующий рефактор кладовщика уже на новом skill-stack, а не только точечные фиксы парсинга.

### Старт завтра

1. Проверить, почему часть `low-stock` SKU (`drip` и часть других позиций) всё ещё без `ABC`-категории.
2. Довести `ABC matching` до более полного покрытия между остатками, продажами и weekly ABC.
3. Перейти к следующему bounded slice: `PDF -> price delta / supplier price change`.
