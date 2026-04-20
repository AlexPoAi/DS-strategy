---
id: WP-88
title: "Park deep registry slice with 15 live entries"
status: done
priority: high
owner: "Strategist + Knowledge Registry Curator"
created: 2026-04-19
updated: 2026-04-19
---

# Контекст

После `WP-87` стало ясно, что пилотная модель `Park` как набора поддоменов работает на верхнем уровне.

Следующий шаг — проверить её на более плотном наборе живых единиц:
- документы,
- коммуникации,
- рабочие продукты,
- активные блокеры.

# Цель

Собрать первый глубокий registry slice по `Park` на `15` живых entries и проверить, что модель:
- выдерживает уровень конкретных артефактов;
- помогает видеть `coverage_state`;
- даёт осмысленный strategist handoff.

# Park Registry Slice

| Entry | Type | Subdomain | Coverage state | Status | Primary source | Next action |
|---|---|---|---|---|---|---|
| `PARK.DOC.020` Оригинальный договор П240 | document | `Legal / contract` | strong but disputed | ok | `DOCUMENT-REGISTRY`, `PROJECT-STATUS` | юрист + определить юридический статус ДС при неподписанном оригинале |
| `PARK.DOC.019` ДС1 расчёт конструкций | document | `Legal / contract` | strong but disputed | ok | `DOCUMENT-REGISTRY`, `COMM.012`, `PROJECT-STATUS` | запросить письменное разграничение ДС1 vs ДС3 |
| `PARK.DOC.023` ДС3 пакет РНС финальный | document | `Legal / contract` | strong | ok | `DOCUMENT-REGISTRY` | удерживать как текущую подписанную версию |
| `PARK.DOC.017` АВР №1 к ДС2 | document | `Legal / contract` | strong | ok | `DOCUMENT-REGISTRY` | оставить как подтверждённый финансово-юридический артефакт |
| `PARK.DOC.033` Заявление на АГО финальное | document | `Administrative / permit` | strong | submitted | `DOCUMENT-REGISTRY`, `PROJECT-STATUS` | ждать входящий номер и исполнителя |
| `PARK.DOC.034` Сопроводительное письмо АГО финальное | document | `Administrative / permit` | strong | submitted | `DOCUMENT-REGISTRY` | держать как активный поданный пакет |
| `PARK.COMM.024` Подача документов АГО 17.04 | communication | `Administrative / permit` | strong | waiting | `COMMUNICATION-REGISTRY`, `PROJECT-STATUS` | дождаться регистрации и входящего номера |
| `PARK.DOC.022` График РНС с АГО 09.04 | document | `Administrative / permit` | good | ok | `DOCUMENT-REGISTRY`, `CONTEXT` | использовать как reference, не как главный текущий blocker |
| `PARK.DOC.007` Архитектурный проект | document | `Architecture / project package` | strong | ok | `DOCUMENT-REGISTRY` | оставить как базовый anchor архитектурного слоя |
| `PARK.DOC.008` ГПЗУ участок | document | `Architecture / project package` | strong | ok | `DOCUMENT-REGISTRY` | использовать как supporting evidence для архитектурных и разрешительных задач |
| `PARK.WP.027` Подсчёт площадей 1 этаж | work product | `Architecture / project package` | good | ok | `DOCUMENT-REGISTRY` | reference для площади первой очереди |
| `PARK.WP.041` Канализационная труба | blocker-card | `Engineering / utilities` | partial | active | `PARK.WP.041`, `CONTEXT` | собрать evidence pack и выйти на официальный verdict |
| `PARK.DOC.005` Геологические изыскания | document | `Engineering / utilities` | good | ok | `DOCUMENT-REGISTRY` | reference для техслоя, не главный blocker |
| `PARK.COMM.015` Условное принятие ДС3 и позиция по ДС1 | communication | `Comms / negotiation` | good | next-action | `COMMUNICATION-REGISTRY` | держать как активную опорную точку переговорной позиции |
| `PARK.COMM.023` Встреча 15.04 — задержка пакета АГО | communication | `Comms / negotiation` | good | confirmed | `COMMUNICATION-REGISTRY`, `PROJECT-STATUS` | использовать как evidence задержки и основания для письменной фиксации от ЛУКС |

# Deep-Slice Verdict

## Что подтвердилось

1. Модель `subdomain -> coverage_state -> next_action` выдерживает уровень конкретных entries.
2. Самые устойчивые поддомены сейчас:
   - `Legal / contract`
   - `Administrative / permit`
   - `Architecture / project package`
3. Самый слабый и рискованный поддомен:
   - `Engineering / utilities`

## Что стало видно лучше

1. `Legal / contract` уже очень насыщен артефактами, но остаётся спорным по двум точкам:
   - `П240`
   - `ДС1 vs ДС3`
2. `Administrative / permit` сейчас самый operationally live слой:
   - документы поданы;
   - дальше важно не создавать новый шум, а ждать входящий номер и исполнителя.
3. `Comms / negotiation` полезен не как архив, а как evidentiary chain для решений по контрактам и задержкам.

# Existing Registry Logic

На этом deep-slice видно, что каждый текущий реестр отвечает за свой слой:

- `DOCUMENT-REGISTRY`
  - физические артефакты и их статус
- `COMMUNICATION-REGISTRY`
  - живая переговорная цепочка и next-action коммуникации
- `PROJECT-STATUS`
  - операционный управленческий срез
- `WP / blocker cards`
  - отдельные активные проблемные узлы

Вывод:
- `Knowledge Registry Curator` не должен заменять эти реестры;
- он должен собирать над ними слой:
  - `subdomain`
  - `coverage_state`
  - `open_question`
  - `primary_sources`
  - `next_action`

# Strategist Handoff

1. `Park` уже можно вести как зрелый pilot-domain для экзокортекса.
2. На сегодня live priority внутри `Park` не должна расползаться:
   - `WP-73` / `PARK.WP.041` остаётся главным blocker-slice.
3. `Administrative / permit` лучше удерживать как waiting/monitoring layer, а не как новый массив работ.
4. Для дальнейшего развития `Knowledge Registry Curator` нужен следующий шаг:
   - добавить в его skill поле/слой `srt_slot`, но не превращать `SRT` в source-of-truth.

# Acceptance

1. Есть `15` живых entries, а не только общий domain sketch.
2. Для каждой единицы видны:
   - `subdomain`
   - `coverage_state`
   - `status`
   - `primary_source`
   - `next_action`
3. Видно, какие реестры уже работают, а какие надстройки действительно нужны.

# Следующий шаг

1. Расширить skill `Knowledge Registry Curator` до `SRT-aware` слоя.
2. После этого решить, переносим ли такую же модель на `Warehouse` и другие домены.
