---
type: domain-context
domain: DS-finance
title: Контекст DS-finance
status: active
updated: 2026-04-27
source_wp: 120
---

# DS-finance — Context

## Текущая рабочая версия

Используем `v1.0 business cash integrated`.

`v0.3` не использовать.

`v0.4` остаётся вычислительной базой: `cash + assets +
transformation-layer`.

`v0.5` добавило разделение контуров:

- `business-finance` (финансы бизнеса);
- `personal-finance` (личные финансы).

`v0.6` расширило карту контуров до всей финансовой системы:

- `business-finance` (финансы бизнеса);
- `personal-finance` (личные финансы);
- `investment-finance` (инвестиционные финансы);
- `reserve-safety` (резерв и безопасность);
- `debt-finance` (долги и обязательства).

`v0.7-v1.0` детализируют первый рабочий контур: `business-finance`.

## Целевая переменная

`cash` (фактические деньги).

## Текущий фокус

Сначала добить `business-finance core`.

`Personal-finance` пока не разворачивать. Он зафиксирован как отдельный контур,
но следующий рабочий ход должен укрепить бизнес-ядро.

Текущий готовый блок бизнес-ядра:

- `v0.7` — `business-finance core`;
- `v0.8` — `business-finance / incomes`;
- `v0.9` — `business-finance / expenses`;
- `v1.0` — `business-finance / cash`.

## Что уже решено

1. Финансовый консультант строится не как бухгалтер, а как аналитик системы
   создания.
2. Без слоя преобразования финансовый агент будет давать решения на
   неполной модели.
3. Главная переменная — `cash`, а не абстрактные финансы.
4. Доходы не равны деньгам: `incomes` и `cash` нельзя смешивать.
5. Активы должны участвовать в расчётах, иначе модель не видит, где деньги
   работают или застряли.
6. Бизнес и личный контур не смешиваются. Связь только через `transfer_in` и
   `transfer_out`.
7. Финансовая система состоит из автономных контуров, связанных только через
   явные transfer.
8. Доходы бизнеса разделяются на операционные и неоперационные.
9. Расходы бизнеса классифицируются по функции и не смешиваются с личными.
10. Cash бизнеса хранится не как общая сумма, а как структура мест хранения:
    `operating_cash`, `reserve_cash`, `investment_cash`.

## Decision cards

- `FIN.DECISION.001` — `cash` как целевая переменная.
- `FIN.DECISION.002` — `v0.3` не использовать.
- `FIN.DECISION.003` — `v0.4 assets integrated`.
- `FIN.DECISION.004` — `v0.5 business / personal contours`.
- `FIN.DECISION.005` — следующий фокус: `business-finance core`.
- `FIN.DECISION.006` — `v0.6 finance contour map`.
- `FIN.DECISION.007` — `business-finance v0.7`.
- `FIN.DECISION.008` — `business incomes v0.8`.
- `FIN.DECISION.009` — `business expenses v0.9`.
- `FIN.DECISION.010` — `business cash v1.0`.

## Канонические файлы

- `00-domain-manifest (Манифест домена финансов).md`
- `01-concepts/FIN.CONCEPT.001-finance-of-creation-system (Финансы системы создания).md`
- `01-concepts/FIN.CONCEPT.002-finance-contours-and-business-core (Финансовые контуры и бизнес-ядро).md`
- `PACK-finance-views/01-views/FIN.VIEW.001-business-finance-core (Бизнес-ядро финансов).md`
- `PACK-finance-views/01-views/FIN.VIEW.002-business-finance-operating-model (Операционная модель финансов бизнеса).md`
- `PACK-finance-views/01-views/FIN.VIEW.003-business-incomes-sources (Источники доходов бизнеса).md`
- `PACK-finance-views/01-views/FIN.VIEW.004-business-expenses-structure (Структура расходов бизнеса).md`
- `PACK-finance-views/01-views/FIN.VIEW.005-business-cash-structure (Структура денег бизнеса).md`

## Ограничения текущего этапа

- не добавлять слой решений;
- не добавлять финансовые рекомендации без данных;
- не смешивать `cash` и `profit`;
- не смешивать бизнес и личные финансы;
- не разворачивать `personal-finance` до стабилизации бизнес-ядра;
- не объединять точки в один доходный поток;
- не хранить деньги без категории;
- не смешивать операционные деньги, резерв и инвестиционные деньги.
