# ENG.WP.043 — Obsidian как human layer для Extractor и Strategist

**Статус:** draft planning
**Дата:** 2026-04-21
**Связанный WP:** `WP-99`

## Зачем

Нужен не ещё один pipeline, а слой, через который человек действительно понимает:

- что у него накопилось в мыслях;
- что уже дошло до `captures`;
- что из этого превращается в работу;
- что считает главным `Strategist`.

Сейчас machine-layer живёт, но human-layer слаб:

- `captures.md` — queue для машины;
- `DayPlan/WeekPlan` — полезные, но file-centric;
- в `Obsidian` нет ясного обзорного стратегического интерфейса.

## Целевой архитектурный принцип

Не переносить source-of-truth, а развести слои:

- `Obsidian` = human-facing мозг;
- `captures` = intake queue;
- `DS-strategy` = governance/task layer;
- `Pack` = knowledge source-of-truth.

## Work products этого контура

1. `WP-99` — управленческий контекст большого контура
2. `Extractor Bank` — human-readable библиотека мыслей по доменам
3. `Selection Board` — слой ручного выбора
4. `Strategist Board` — explain-layer для ежедневных и недельных verdict
5. `Safety Beacon Spec` — contract наблюдаемости
6. `Strategist skill plan` — human-facing skill-upgrade

## Агентная схема реализации

### 1. `Strategist`

**Роль в проекте:**
- главный агент архитектуры и human-facing логики.

**Что умеет:**
- weekly planning;
- daily planning;
- backlog triage;
- выбор bounded next step;
- human-readable объяснение приоритетов.

**Где primary:**
- contract matrix;
- `Selection Board`;
- `Strategist Board`.

### 2. `Knowledge Registry Curator`

**Роль в проекте:**
- главный агент по доменной укладке мыслей.

**Что умеет:**
- domain mapping;
- thematic clustering;
- registry summaries;
- human-readable библиотека мыслей.

**Где primary:**
- `Extractor Bank`.

### 3. `Environment Engineer`

**Роль в проекте:**
- главный агент по safety и truthful contracts.

**Что умеет:**
- observability design;
- drift/stale semantics;
- acceptance gates;
- beacon architecture.

**Где primary:**
- `Safety Beacon Spec`;
- safety checks нового контура.

### 4. `Code Engineer`

**Роль в проекте:**
- агент минимальной автоматики.

**Что умеет:**
- frontmatter parsing;
- markdown tooling;
- summary scripts;
- safe file-level automation.

**Где primary не нужен на старте, но обязателен как support:**
- `Selection Board`;
- safety scripts;
- lightweight sync/check tooling.

## Риски

1. Слишком много слоёв — мозг превратится в бюрократию.
2. Дублирование source-of-truth — человек перестанет понимать, где “истина”.
3. Слишком ранняя автоматизация — fragile sync начнёт ломать доверие к системе.

## Guardrails

1. `manual-first` до подтверждённой пользы.
2. Не делать двустороннюю автоматику в первом цикле.
3. Каждый новый слой обязан отвечать на конкретный human pain.
4. Любая автоматика должна иметь beacon: сработало / не сработало / stale.

## Этапы инженерной реализации

### Slice 1. Contract Matrix

Материализовать:

- роли слоёв;
- allowed transitions;
- кто где source-of-truth.

### Slice 2. Selection Board v1

Материализовать:

- русскоязычный слой выбора в Obsidian;
- frontmatter-статусы;
- 3-5 реальных карточек на живых мыслях.

### Slice 3. Strategist Board v1

Материализовать:

- человеческий daily/weekly verdict;
- skill-contract для Strategist.

Статус:

- `done`
- связанный bounded WP: `WP-99-S1`

### Slice 4. Safety Beacons

Материализовать:

- freshness;
- drift;
- stale;
- waiting-for-manual-decision.

Статус:

- `done`
- связанный bounded WP: `WP-99-S2`

### Slice 5. Strategist Skill Plan v1

Материализовать:

- human-facing skill-contract для `Strategist`;
- rules explain-layer на русском;
- input matrix для strategist verdict;
- integration contract нового human-layer в общий `health-check`.

Статус:

- `done`
- связанный bounded WP: `WP-99-S3`

### Slice 6. Human-Layer Health-Check Integration

Материализовать:

- checks для `Доски выбора` и `Доски стратега` в `health-check.sh`;
- отражение human-layer в `AGENTS-STATUS.md`;
- отражение human-layer в `SESSION-OPEN`;
- truthful semantics общего verdict.

Статус:

- `done`
- связанный bounded WP: `WP-99-S4`

## Engineering acceptance

1. Человек может работать с банком мыслей без чтения GitHub queue-файлов.
2. Стратег выдаёт human-readable verdict, а не только file-output.
3. Есть хотя бы один проверяемый beacon на каждый новый слой.
4. Первый цикл работает руками даже без сложной автоматики.
