---
type: recovery-catalog
date: 2026-04-08
status: active
owner: Environment Engineer
scope: lost-inputs
---

# Recovery Catalog — Lost Inputs (2026-04-08)

## Назначение

Этот каталог возвращает в управляемый контур:
- потерянные задачи из сессий стратегирования;
- идеи и рабочие продукты, которые зависли между `captures`, extraction-report'ами и `INBOX`;
- красные хвосты из `UNPROCESSED-NOTES-REPORT.md`.

## Источники проверки

1. `DS-strategy/inbox/captures.md`
2. `DS-strategy/inbox/extraction-reports/*.md`
3. `DS-strategy/inbox/processed-sessions/*.md`
4. `DS-strategy/current/UNPROCESSED-NOTES-REPORT.md`
5. `DS-strategy/current/WeekPlan W15 2026-04-06.md`
6. `legacy downstream / 1. Исчезающие заметки/*.md`
7. `DS-strategy/inbox/archive/rejected/*.md`

## Краткий вывод

- Красные необработанные заметки по состоянию на `2026-04-08`: `3`
- Реально уже отслеживаемые хвосты из сессий 24.03: `8+`
- Новые recovery-элементы, которые не были заведены в `INBOX`: `2`
- Элементы, требующие отдельного восстановления источника: `1`

## Реестр recovery

| # | Элемент | Источник | Статус recovery | Что сделано |
|---|---|---|---|---|
| 1 | Переезд на Кипр/Таиланд как долгосрочная стратегия | `UNPROCESSED-NOTES-REPORT`, `CO.reject.012`, legacy downstream | `new` | возвращён в `INBOX` как отдельная стратегическая задача |
| 2 | Сайт по продаже кофе в Симферополе + доставка/оплата/TG | `UNPROCESSED-NOTES-REPORT`, `CO.reject.011`, legacy downstream | `new` | возвращён в `INBOX` как growth-задача |
| 3 | ИИ ассистенты для проработки | `UNPROCESSED-NOTES-REPORT`, legacy downstream | `needs source recovery` | файл-источник найден, но пустой; требуется восстановление контекста из исходных заметок/чата |
| 4 | Разработки ПО для руководителя кофейни | `processed-sessions 2026-03-24 22:34` | `already tracked` | уже разложено в `INBOX` на задачи по ролям проекта и агенту оценки знаний сотрудников |
| 5 | Система лояльности в Saby | `processed-sessions 2026-03-24 22:34` | `already tracked` | уже есть pending-задача в `INBOX` |
| 6 | Замена мебели на Тургенева | `processed-sessions 2026-03-24 22:34` | `already tracked` | уже есть pending-задача и отдельный WP-след |
| 7 | Вывеска Самокиша / договор / проектная организация | `processed-sessions 2026-03-24 22:34` | `already tracked` | уже в активном контуре Самокиша и Park/VK-offee |
| 8 | Список оборудования и инженерных требований для новой кухни | `processed-sessions 2026-03-24 22:34` | `already tracked` | already in `INBOX` |
| 9 | Электрическая нагрузка новой кухни | `processed-sessions 2026-03-24 22:34` | `already tracked` | already in `INBOX` |
| 10 | Аналитика кухни и бара по накладным, продажам и прайсам | `processed-sessions 2026-03-24 22:34` | `already tracked` | already reflected in kitchen/Saby analytical backlog |
| 11 | Carry-over W15: WP-47 Extractor redesign | `WeekPlan W15` | `already tracked` | уже есть в WeekPlan и `INBOX` |
| 12 | Carry-over W15: WP-48 Telegram bot QA | `WeekPlan W15` | `already tracked` | уже есть в WeekPlan и `INBOX` |
| 13 | Carry-over W15: WP-44 kitchen FM level | `WeekPlan W15` | `already tracked` | уже есть в WeekPlan и `INBOX` |
| 14 | Carry-over W15: ENG.007 security | `WeekPlan W15` | `already tracked` | уже есть в инженерном контуре |

## Новые элементы, возвращённые в INBOX

### 1. Переезд на Кипр/Таиланд

**Почему это recovery, а не новый придуманный пункт:**
- заметка есть в legacy downstream `1. Исчезающие заметки/Переезд на кипр или тайланд.md`;
- extraction уже признал, что это не Pack-knowledge, а governance/personal strategy;
- при этом задача так и не была поднята в `INBOX`.

**Правильный статус:**
- не Pack knowledge;
- не rejection “в мусор”;
- а стратегический backlog владельца.

### 2. Сайт по продаже кофе в Симферополе

**Почему это recovery, а не новый придуманный пункт:**
- заметка есть в legacy downstream `1. Исчезающие заметки/Сайт по продаже кофе в Симферополе..md`;
- rejected-архив прямо указывает: это должно было попасть в `DS-strategy/inbox/INBOX-TASKS.md как новый рабочий продукт`;
- этого не произошло.

**Правильный статус:**
- governance/growth backlog;
- нужен отдельный discovery по каналу продаж, доставке, оплате и продвижению.

## Требует отдельного восстановления источника

### ИИ ассистенты для проработки

Что известно:
- есть красный хвост в `UNPROCESSED-NOTES-REPORT.md`;
- исходный файл найден в legacy downstream `1. Исчезающие заметки/Ии ассистенты для проработки.md`;
- содержимое файла пустое.

Вывод:
- это не обычный pending task, а broken source recovery case;
- нужно искать контекст в Telegram/Obsidian history/соседних заметках, иначе задача останется только названием.

## Итоговый truthful verdict

- Recovery-контур подтвердил ощущение пользователя: часть входов действительно потерялась между extraction и backlog.
- Но значительная часть материалов не исчезла, а уже лежала в `INBOX` или `WeekPlan` без единого каталога.
- Главная новая ценность этого шага: отделены `реально потерянные`, `уже отслеживаемые` и `требующие восстановления источника` элементы.

## Ограничение текущего прохода

Этот recovery-catalog не означает, что уже гарантированно найдены вообще все исторические потери по всей экосистеме.

Truthful scope текущего прохода:
- проверены основные operational источники потерь;
- возвращены явные recovery-cases, которые уже были подтверждены файлами и артефактами;
- зафиксированы следующие шаги для deeper recovery.

Что ещё не гарантировано:
- полная выборка по всем старым Telegram-экспортам;
- все возможные хвосты из внешних Obsidian/NoCloud источников;
- все исторические governance-идеи, если они никогда не попали в проверенные today источники.
