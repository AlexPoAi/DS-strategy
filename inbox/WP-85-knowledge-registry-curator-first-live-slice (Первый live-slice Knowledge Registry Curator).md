---
id: WP-85
title: "Knowledge Registry Curator first live slice"
status: done
priority: high
owner: "Strategist + Knowledge Registry Curator"
created: 2026-04-19
updated: 2026-04-19
---

# Контекст

После создания агента `Knowledge Registry Curator` и его skill `notes-registry-and-domain-mapping` нужен был первый truthful прогон на реальном наборе данных.

Задача этого slice:
- не собрать полный реестр всего мира;
- а доказать, что новый слой между `Extractor` и `Strategist` уже может давать полезный bounded output.

# Цель

Провести первый live rollout skill на реальном notes/backlog слое и получить три артефакта:
- `Notes Registry Update`
- `Domain Map`
- `Strategist Handoff`

# Scope

1. Взять текущий стратегический срез:
   - `SESSION-CONTEXT`
   - `INBOX-TASKS`
   - `WeekPlan W17`
   - `WP-79`
   - `UNPROCESSED-NOTES-REPORT`
2. Собрать representative cut по ключевым WP и доменам.
3. Проверить, даёт ли новый skill более чистую картину для Стратега.
4. Зафиксировать, что остаётся следующим обязательным шагом.

# Notes Registry Update

Representative cut:

| Entry | State | Domain | Значение |
|---|---:|---|---|
| `WP-73` Парк: статус канализационной трубы + верификация | pending | Park | Главный фактический blocker по Парку. |
| `WP-79` Notes registry capability roadmap | done | Registry / agency infra | Зафиксировал сам capability-gap и целевой контур. |
| `WP-80` Knowledge Registry Curator creation | done | Registry / agency infra | Создан внутренний агент между `Extractor` и `Strategist`. |
| `WP-83` Primary naming cleanup | done | Registry / agency infra | Выровнял primary naming на английский. |
| `WP-84` Skill for Knowledge Registry Curator | done | Registry / agency infra | Создан repeatable skill `notes-registry-and-domain-mapping`. |
| `WP-56` Pack audit and clean carry-over backlog | partial | Strategy / backlog hygiene | Держит truthful backlog и weekly hygiene. |
| `WP-59` VK-offee bot: manager role + report buttons | partial | VK-offee product / management | Главный продуктовый хвост W17. |
| `WP-77` VK-offee automation opportunity map | in progress | VK-offee operations | Карта автоматизаций по ROI и сложности. |
| `WP-78` Investment advisor agent for VK-offee | in progress | VK-offee finance | Слой агентных инвест-решений по прибыли. |
| `WP-75` Warehouse demand analyst + skill protocol | in progress | Warehouse | Профильный складской агент спроса. |
| `WP-76` Exocortex planner bootstrap recovery | critical | Engineering / runtime | Системный runtime-risk. |
| `WP-82` Separate PACK for agent skills | in progress | Agency platform | Будущий source-of-truth для skills. |

Truthful note:
- это первый representative cut, а не полный реестр всех 110 единиц;
- доменные метки частично выведены из названий задач и weekly portfolio.

# Domain Map

| Domain | Current active WP | Queue / gaps |
|---|---|---|
| Park | `WP-73` | Нет официального статуса трубы; нужен verdict source и decision tree. |
| VK-offee product / management | `WP-59` | Рядом стоят `WP-77` и `WP-78`, но они должны жить как очередь соседних slices, а не один монолит. |
| Strategy / backlog hygiene | `WP-56`, `WP-74` | Нужна карта `110` задач и удержание правила `1 домен = 1 главный активный РП`. |
| Warehouse | `WP-75`, `WP-81` | Домен уже разложен на агентный и методический слой, но ещё не собран в один устойчивый 24/7 контур. |
| Registry / agency infra | `WP-79`, `WP-80`, `WP-84` | Capability уже материализован, но ещё требует live expansion и runtime-слоя. |
| Engineering / runtime | `WP-76`, `WP-72`, `WP-70` | Главный риск здесь в стабильности runtime, ritual gate и агентного UX. |

# Strategist Handoff

1. Не смешивать `Extractor` и registry capability:
   - `WP-79` уже зафиксировал, что это отдельный слой, а не просто upstream enhancement.

2. По W17 главный луч всё ещё такой:
   - `WP-73`
   - `WP-59`
   - `WP-56`
   - `WP-74`
   - остальное лучше считать очередью домена.

3. `UNPROCESSED-NOTES-REPORT` остаётся зелёным:
   - `107/110` уже обработано;
   - красной маршрутизации нет;
   - остаются только 3 queued notes.

4. Новый skill уже полезен:
   - он дал bounded domain view;
   - уменьшил ручную пересборку контекста у Стратега;
   - но пока это ещё не полный production registry.

# Acceptance

1. Первый live rollout выполнен на реальном слое.
2. Есть `Notes Registry Update`, `Domain Map` и `Strategist Handoff`.
3. Подтверждено, что capability полезен и не дублирует `Extractor`.
4. Видно, какой следующий slice нужен после proof run.

# Следующий шаг

1. Открыть более глубокий registry-slice на 10-20 реальных notes/backlog entries.
2. Отдельно открыть инженерный slice:
   - `Knowledge Registry Curator 24/7 VPS runtime`
3. Позже мигрировать skill в `PACK-agent-skills` через `WP-82`.
