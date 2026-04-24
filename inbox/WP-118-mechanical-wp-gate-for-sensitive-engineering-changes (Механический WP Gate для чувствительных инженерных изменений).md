---
type: work-product
id: WP-118
status: in_progress
priority: critical
created: 2026-04-24
updated: 2026-04-24
owner: Engineer
domain: exocortex
approved: true
---

# WP-118 — Механический WP Gate для чувствительных инженерных изменений

## Почему открыто

Инцидент 2026-04-24: агент выполнил инженерное упрощение root-helper'ов без предварительного открытия и согласования РП.

Вывод: текстовые правила, skills и CLAUDE.md недостаточны как предохранитель. Нужен механический gate в close-flow, который не позволит закрыть чувствительные изменения без активного одобренного РП.

## Согласованный scope

Разрешено:
- создать `DS-strategy/current/ACTIVE-WP.md`;
- добавить `WP-118` в контекстные слои `DS-strategy`;
- добавить проверку активного РП в `FMT-exocortex-template/scripts/close-task.sh`;
- обновить установленную копию `~/Github/close-task.sh`;
- проверить shell-синтаксис и close-flow.

Не входит:
- перенос `.claude`;
- миграция агентства;
- изменение launchd;
- массовая чистка репозиториев;
- откат предыдущих коммитов без отдельного решения.

## Acceptance criteria

- Если есть изменения в чувствительных зонах, `close-task.sh` требует `DS-strategy/current/ACTIVE-WP.md`.
- `ACTIVE-WP.md` должен содержать `approved: true`.
- Scope активного РП должен покрывать изменённые repo/path.
- Root-helper drift проверяется сравнением установленной копии с template source-of-truth.
- Без выполнения gate задача не считается закрытой.

## Чувствительные зоны v1

- `DS-strategy`
- `FMT-exocortex-template`
- root-helper'ы workspace:
  - `close-task.sh`
  - `open-codex-github.sh`
  - `strategist-wrapper.sh`
  - `Codex-Github.code-workspace`

## Ритуальное подтверждение

Пользователь подтвердил внедрение: `да` после предложения открыть РП на механический WP Gate.

## Engineering ritual check — correction pass 2026-04-24

### 1. Upstream Церена

Проверено после замечания пользователя: `git fetch upstream`, затем релевантные файлы `upstream/main`.

Факт:
- в `upstream/main` нет `scripts/close-task.sh`;
- upstream close-flow описан через `memory/protocol-close.md` как Quick Close: commit/push, WP context, KE, MEMORY.md;
- upstream даёт extension points (`extensions/protocol-close.checks.md`, `extensions/protocol-close.after.md`), но не содержит механического workspace-wide gate.

Вывод: наш `close-task.sh` — локальный операционный слой поверх upstream, а не upstream-канон. Любые изменения в нём должны быть минимальным guardrail, а не расширением экосистемы в отдельную подсистему.

### 2. Наш идеал

Из `DS-strategy/exocortex/ritual-first.md`:
- сначала РП и согласование;
- для engineering-задач — сверка с эталоном;
- затем работа;
- переход от исследования к изменению = новый проход через WP Gate.

Идеал для `WP-118`: один простой стоп-кран в `close-task.sh`, без новых агентов, без нового реестра, без сложной permission-системы.

### 3. Наш факт

Факт до `WP-118`:
- текстовые правила уже были, но агент их обошёл;
- `close-task.sh` закрывал broad scope и мог случайно закоммитить unrelated dirty repo;
- `VK-offee` стал реальным примером: локальные изменения `telegram-bot/bot.py` и `telegram-bot/tests/` не относились к `WP-118`.

Факт после correction:
- `ACTIVE-WP.md` — один файл, approval одноразовый;
- broad-close блокируется, если есть dirty paths вне active WP scope;
- scoped-close остаётся минимальным маршрутом для bounded фикса.

### 4. Gap

Главный gap был не в отсутствии ещё одного правила, а в отсутствии mechanical stop перед commit/push.

Второй gap: сам `WP-118` был начат без полной upstream/ideal/fact/gap последовательности. Этот раздел фиксирует correction-pass и оставляет явное правило: для дальнейших правок экосистемы сначала сверка с Цереном и нашим идеалом, потом код.

### 5. Решение по текущему фиксу

Оставить текущий gate как локальный minimal extension:
- он не меняет upstream-протокол;
- не добавляет новых сервисов;
- не требует новых каталогов;
- использует существующий `close-task.sh`;
- предотвращает конкретно воспроизведённый failure mode.

Не расширять `WP-118` дальше без отдельного подтверждения пользователя.

## Минимальная поправка после проверки active-context

Факт: `ACTIVE-WP.md` сам по себе является чувствительным указателем, но его обычное переключение между РП не является ремонтом экосистемы.

Решение: оставить `ACTIVE-WP.md` под Sensitive WP Gate, но не требовать для каждого переключения полного `Церен / идеал / факт / gap` ritual. Этот ritual обязателен для ремонта `FMT-exocortex-template`, `DS-strategy/exocortex` и root-helper drift.
