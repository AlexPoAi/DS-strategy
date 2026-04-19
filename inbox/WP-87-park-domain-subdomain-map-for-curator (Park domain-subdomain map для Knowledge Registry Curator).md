---
id: WP-87
title: "Park domain-subdomain map for Knowledge Registry Curator"
status: done
priority: high
owner: "Strategist + Knowledge Registry Curator"
created: 2026-04-19
updated: 2026-04-19
---

# Контекст

После методологической цепочки `FPF -> SRT -> SPF` появился достаточный каркас, чтобы сделать первый предметный pilot map по домену `Park`.

Этот slice нужен не для полного переписывания Pack, а для проверки:
- как `Knowledge Registry Curator` должен вести `Park` как набор поддоменов;
- как связать это с уже существующими реестрами;
- не конфликтует ли новый слой с другими агентами и эталоном экзокортекса.

# Цель

Собрать первый `Park domain-subdomain map` для `Knowledge Registry Curator`, где видны:
- поддомены;
- coverage state;
- существующие реестры;
- missing layers;
- action model для дальнейшей работы куратора.

# Park Domain Map

## Поддомены

- `Legal / contract`
  - П240, ДС1, ДС2, ДС3, АВР1, оплаты, разграничение двойной оплаты
- `Administrative / permit`
  - АГО, графики РНС, подача, регистрация, входящий номер, исполнитель
- `Architecture / project package`
  - АР, ГПЗУ, планы, площади, эскизы, пакет для РНС
- `Engineering / utilities`
  - канализационная труба как blocker, геология, сети, техусловия
- `Comms / negotiation`
  - Telegram-цепочка, встречи, переговоры с ЛУКС и внешними участниками
- `Governance / registry`
  - context, status, timeline, registries, WP, source map

# Coverage State

| Subdomain | Coverage state | Truthful note |
|---|---|---|
| `Legal / contract` | strong but disputed | реестр и карточки сильные, но П240 не подписан, а ДС1 требует письменного разграничения с ДС3 |
| `Administrative / permit` | strong | пакет АГО подготовлен и подан `17.04.2026`, сейчас контур `ago-submitted` |
| `Architecture / project package` | strong | архитектурный слой и документные карточки уже хорошо оформлены |
| `Engineering / utilities` | partial | по трубе есть отдельный active blocker, но официального verdict ещё нет |
| `Comms / negotiation` | good | цепочка переговоров размечена по датам, ролям и next-action |
| `Governance / registry` | good, not complete | верхний реестровый слой уже есть, но не хватает coverage/decision registry по блокерам |

# Existing Registries

- `DOCUMENT-REGISTRY.md`
  - основной реестр документов по юридическому, архитектурному, административному и техническому слоям
- `COMMUNICATION-REGISTRY.md`
  - цепочка переписок и живой линии ЛУКС
- `PROJECT-STATUS.md`
  - операционный статус и ближайшие блокеры
- `CONTEXT.md`
  - быстрый truthful вход в проект
- `PROJECT-TIMELINE.md`
  - хронология как backbone для доменной привязки
- `PARK.WP.041`
  - blocker-card по трубе с decision frame

# Missing Layers

1. Нет отдельного registry слоя `subdomain -> coverage -> blocker -> next action`.
2. Нет evidence/verdict registry по инженерным блокерам (`utilities`).
3. Нет явной разметки `active / superseded / source / decision-ready` на всех реестрах.
4. Нет bounded deep-slice шаблона на `10-20` живых entries как постоянной работы куратора.
5. Нет runtime-слоя `Knowledge Registry Curator 24/7`, но его пока не активируем до завершения предметного пилота.

# Curator Action Model

1. Не смешивать extraction и registry:
   - сначала факты;
   - потом классификация;
   - потом strategist handoff.
2. На уровне subdomain держать минимальный стандарт:
   - `subdomain`
   - `coverage_state`
   - `open_question`
   - `primary_sources`
   - `next_action`
3. Для blockers собирать evidence-first пакет, а не просто ссылку на заметку.
4. На каждом обновлении обновлять не только карту, но и статус покрытия поддомена.
5. Отдавать Стратегу сжатую truth-картину:
   - что покрыто;
   - что спорно;
   - что требует verdict;
   - что готово к следующему WP.

# Interference Check

## Не перебивает ли это других агентов

- `Extractor` не заменяется:
  - он остаётся upstream ingestion слоем.
- `Knowledge Registry Curator` не становится `Strategist`:
  - он классифицирует и собирает карту, но не принимает weekly priorities.
- `Park Architect` не заменяется:
  - доменная интерпретация и письма/документы по Парку остаются за ним.

Вывод:
- новый слой не перебивает текущих агентов, если держать его как registry/handoff слой.

# Etalon Check

Пилот соответствует эталону экзокортекса, если удерживать:
- отдельные роли;
- один source-of-truth на слой;
- truthful handoff;
- отсутствие монстр-агента;
- `FPF` как различение, `SRT` как раскладка, `SPF` как formalization, `Curator` как registry-оператор.

Вывод:
- текущая модель приближает нас к эталону, а не уводит от него.

# Acceptance

1. Первый `Park domain-subdomain map` собран.
2. Видны `coverage_state`, `existing registries`, `missing layers`.
3. Проведён `interference check`.
4. Проведён `etalon check`.
5. Понятно, что именно дальше должен делать `Knowledge Registry Curator`.

# Следующий шаг

1. Открыть bounded deep-slice по `Park` на `10-20` живых entries.
2. Отдельно держать в `INBOX` future engineering task:
   - создать агентный слой и skills для `SRT` и `SPF`, когда предметный pilot будет признан полезным.
