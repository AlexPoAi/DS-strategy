---
id: WP-79
title: "Notes registry capability roadmap"
status: done
priority: high
owner: "Strategist + Supreme HR"
created: 2026-04-19
updated: 2026-04-19
---

# Контекст

По итогам стратегической сессии стало видно, что текущий контур заметок разделён неполно:
- `Extractor` умеет ingestion и первичную обработку;
- `Strategist` вручную дособирает картину недели и backlog;
- между ними не хватает устойчивого слоя, который ведёт реестр заметок, раскладывает их по доменам и показывает gaps.

Из этого возник новый capability-gap:
- нужен отдельный агент под `notes registry / domain mapping / pack coverage`;
- нужен skill-протокол этого агента;
- нужен пошаговый план, как ввести capability без перегруза `Extractor` и `Strategist`.

# Цель

Собрать дорожную карту внедрения capability `Notes Registry`, где заранее определены:
- этапы работ;
- какие агенты нужны на каждом этапе;
- какой новый агент создаётся;
- какие артефакты должны появиться в `DS-strategy` и `DS-agent-workspace`.

# Архитектурный принцип

Целевой контур:

1. `Extractor`
   - читает заметки и делает первичную обработку;
2. `Notes Portfolio Curator` (новый агент)
   - ведёт реестр заметок;
   - классифицирует по доменам и Pack;
   - показывает missing domains / orphan notes / очередь домена;
3. `Strategist`
   - строит weekly portfolio и выбирает один главный РП на домен.

Важно: capability не встраивается целиком в `Extractor`; `Extractor` получает только вспомогательное улучшение по первичной разметке.

# Пошаговая карта работ

## Итерация 1 — Roadmap и выбор агентного состава

Цель:
- зафиксировать операционный план и выбрать профильных исполнителей.

Что делаем:
1. собрать этот roadmap;
2. проверить реестр агентства и подобрать агентов по этапам;
3. зафиксировать, где текущий реестр не покрывает задачу.

Основные агенты:
- `Strategist` — владелец РП и оркестратор;
- `Supreme HR` — подбор агентов по этапам.

Артефакт:
- этот `WP-79`.

## Итерация 2 — Создание нового агента

Цель:
- создать агента `Notes Portfolio Curator`.

Что делаем:
1. описать контракт агента;
2. определить его границы ответственности;
3. добавить карточку агента в `DS-agent-workspace/agency/agents/`;
4. добавить запись в `agency/REGISTRY.md`.

Основные агенты:
- `Strategist` — формулирует задачу и принимает контракт;
- `Supreme HR` — проводит найм и проверяет fit;
- при необходимости `agents-orchestrator` или `specialized-workflow-architect` — если понадобится отдельный дизайн многоагентного контура.

Ожидаемый результат:
- в агентстве появился отдельный агент под реестр заметок.

## Итерация 3 — Skill нового агента

Цель:
- дать новому агенту повторяемый workflow.

Что делаем:
1. создать skill `notes-registry-and-domain-mapping`;
2. зафиксировать обязательные поля реестра:
   - `note_id`
   - `source`
   - `status`
   - `note_type`
   - `domain`
   - `subdomain`
   - `pack`
   - `wp_link`
   - `priority`
   - `next_action`
3. зафиксировать 4 режима работы:
   - `ingest week notes`
   - `classify backlog slice`
   - `find missing domains`
   - `prepare strategist handoff`

Основные агенты:
- `Code Engineer` — если skill оформляется как исполняемый tooling/prompt/protocol;
- `Notes Portfolio Curator` — основной потребитель skill;
- `FPF Consultant` — опционально, если потребуется help по таксономии и различениям.

Ожидаемый результат:
- новый агент умеет работать не ad hoc, а по устойчивому протоколу.

## Итерация 4 — Улучшение upstream для Extractor

Цель:
- сделать так, чтобы следующий агент получал более чистое сырьё.

Что делаем:
1. добавить Extractor минимальную первичную разметку;
2. ввести поля:
   - `suggested_domain`
   - `suggested_pack`
   - `note_type`
   - `confidence`
3. не переносить в `Extractor` portfolio review и weekly decisions.

Основные агенты:
- `Code Engineer`
- `Environment Engineer` — если нужны runtime/script changes.

Ожидаемый результат:
- `Extractor` лучше готовит входящий поток, но не превращается в перегруженного оркестратора.

## Итерация 5 — Первый truthful rollout

Цель:
- на реальных данных запустить capability и проверить, что он полезен Стратегу.

Что делаем:
1. взять реальный slice заметок / backlog;
2. заполнить первый `Notes Registry`;
3. собрать `Domain Map`;
4. показать:
   - orphan notes;
   - missing domains;
   - один главный активный РП на домен;
5. на основе результата пересобрать weekly portfolio.

Основные агенты:
- `Notes Portfolio Curator`
- `Strategist`

Ожидаемый результат:
- capability доказан на реальном наборе данных, а не только на схеме.

# Acceptance

1. Есть поэтапная карта внедрения capability.
2. Для каждого этапа понятен основной агент.
3. Зафиксировано, что нужен новый агент, а не только skill для `Strategist`.
4. Понятно, какие артефакты должны появиться до первого rollout.

# Hiring verdict

## Кто собирает roadmap

Рекомендация `Supreme HR`:
- основной владелец roadmap — `Strategist`;
- если roadmap упирается в матрицу ролей, дополнительно подключается `Supreme HR`;
- если roadmap упирается в строгую доменную модель, точечно подключается `FPF Consultant`.

Вывод:
- roadmap capability остаётся задачей `Strategist`, а не `Extractor`.

## Нужен ли отдельный агент для архитектуры workflow

Рекомендация `Supreme HR`:
- да, отдельный workflow-слой полезен;
- в качестве внешнего специализированного подзаказа подходит `specialized-workflow-architect`.

Вывод:
- если следующий slice будет именно про проектирование agent pipeline, можно нанять внешний `Workflow Architect`;
- если следующий slice узкий и DS-native, можно сначала создать внутреннего агента без отдельного внешнего архитектурного шага.

## Кто главный исполнитель реестра заметок

Рекомендация `Supreme HR`:
- сильный внешний исполнитель — `ZK Steward`;
- для DS-native контура нужен свой внутренний агент.

Рекомендованный DS-native gap closure:
- новый агент `Knowledge Registry Curator`.

Роль:
- вести `Notes Registry`;
- собирать `domain map`;
- держать `pack coverage`;
- делать `orphan-note sweep`;
- связывать `domain map -> index -> work product`.

# Следующий шаг

1. Открыть следующий bounded slice на создание внутреннего агента `Knowledge Registry Curator`.
2. Отдельным slice решить, нужен ли сразу внешний `Workflow Architect`.
3. После создания агента открыть отдельный slice на skill `notes-registry-and-domain-mapping`.
