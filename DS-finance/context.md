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

Используем `v0.5 assets integrated + contours`.

`v0.3` не использовать.

`v0.4` остаётся вычислительной базой: `cash + assets +
transformation-layer`.

`v0.5` добавляет разделение контуров:

- `business-finance` (финансы бизнеса);
- `personal-finance` (личные финансы).

## Целевая переменная

`cash` (фактические деньги).

## Текущий фокус

Сначала добить `business-finance core`.

`Personal-finance` пока не разворачивать. Он зафиксирован как отдельный контур,
но следующий рабочий ход должен укрепить бизнес-ядро.

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

## Decision cards

- `FIN.DECISION.001` — `cash` как целевая переменная.
- `FIN.DECISION.002` — `v0.3` не использовать.
- `FIN.DECISION.003` — `v0.4 assets integrated`.
- `FIN.DECISION.004` — `v0.5 business / personal contours`.
- `FIN.DECISION.005` — следующий фокус: `business-finance core`.

## Канонические файлы

- `00-domain-manifest (Манифест домена финансов).md`
- `01-concepts/FIN.CONCEPT.001-finance-of-creation-system (Финансы системы создания).md`
- `01-concepts/FIN.CONCEPT.002-finance-contours-and-business-core (Финансовые контуры и бизнес-ядро).md`
- `PACK-finance-views/01-views/FIN.VIEW.001-business-finance-core (Бизнес-ядро финансов).md`

## Ограничения текущего этапа

- не добавлять слой решений;
- не добавлять финансовые рекомендации без данных;
- не смешивать `cash` и `profit`;
- не смешивать бизнес и личные финансы;
- не разворачивать `personal-finance` до стабилизации бизнес-ядра.
