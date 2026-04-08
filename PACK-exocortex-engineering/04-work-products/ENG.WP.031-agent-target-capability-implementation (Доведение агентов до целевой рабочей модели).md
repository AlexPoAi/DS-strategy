---
id: ENG.WP.031
name: Доведение агентов до целевой рабочей модели
status: active
created: 2026-04-08
last_updated: 2026-04-08
owner: Environment Engineer
---

# ENG.WP.031 — Доведение агентов до целевой рабочей модели

## Контекст

После `ENG.WP.030` у нас появилась truthful картина:
- часть агентного слоя реально работает;
- acceptance/runbook и live-verdict уже собраны;
- но идеальная модель экосистемы всё ещё реализована только частично.

Главный подтверждённый gap:
- `Extractor` пока не закрывает надёжно весь цикл `input -> классификация -> Pack/WP/INBOX -> artefact -> возврат в рабочий контур`;
- `Strategist` не доказал full chaos-structuring и recovery-management слой;
- governance/backlog элементы могут распознаваться, но не всегда доходят до `INBOX` как рабочие сущности.

## Целевая модель

Агентный слой должен уметь следующее end-to-end:

1. Входящий input попадает в единый intake-layer.
2. Агент определяет тип: `Pack knowledge / WP / backlog / reject / defer`.
3. Агент определяет целевой контур:
   - какой `Pack`
   - какой `WP`
   - или что это governance / strategic backlog
4. Создаётся не просто отчёт, а управляемый артефакт:
   - candidate card
   - backlog task
   - recovery-catalog entry
   - work-product draft
5. Элемент не теряется между extraction, rejected-архивом, `INBOX` и WeekPlan.
6. Повторный запуск не создаёт хаос, дубли и ложный success.

## Главные gaps

### 1. Extractor full recovery loop

Нужно довести `Extractor` до режима, где он:
- умеет не только писать extraction-report;
- но и truthfully определяет, куда должен идти элемент:
  - в `Pack`
  - в `INBOX`
  - в recovery-catalog
  - в reject/defer
- не теряет governance/growth/personal-strategy inputs.

### 2. Strategist chaos-structuring layer

Нужно довести `Strategist` до режима, где он:
- не только удерживает ритуалы;
- но и может работать как recovery/prioritization owner для размазанных входов;
- умеет помогать превращать recovered items в управляемый weekly/backlog контур.

### 3. Cross-agent return loop

Нужно закрыть разрыв между:
- `Extractor` как intake/classification агентом,
- `Strategist` как prioritization/governance агентом,
- `Environment Engineer` как verification/hardening агентом.

Без этого агентная архитектура остаётся частично рабочей, но не замыкает обещанный цикл.

## Что сделать

1. Спроектировать canonical flow `input -> classification -> target route -> artifact -> status`.
2. Для `Extractor` ввести явные outcome-статусы:
   - `pack_candidate`
   - `backlog_task`
   - `recovery_item`
   - `rejected`
   - `deferred`
3. Добавить правило: governance/growth/personal inputs не отвергаются в пустоту, а переводятся в `INBOX` или recovery-catalog.
4. Спроектировать dedup/anti-loss contract между `captures`, extraction-reports, rejected archive и `INBOX`.
5. Подтвердить живым сценарием как минимум один настоящий full-loop recovery path.
6. После этого обновить truthful verdict по агентам.

## Acceptance

- `Extractor` хотя бы в одном живом сценарии выполняет полный loop без потери элемента;
- governance/growth inputs больше не “исчезают” между rejected и backlog;
- recovered item получает явный статус и артефакт;
- `Strategist` может взять recovered item и вернуть его в управляемый приоритетный контур;
- есть один end-to-end пример `input -> target route -> artifact -> tracked status`.

## Связанные контуры

- `ENG.WP.030` — truthful capability hardening и первая verification-wave
- `[RECOVERY]` — каталог потерянных входов
- `[STRUCTURE]` — point-level knowledge layer
- `WP-47` / Extractor redesign

## Truthful статус

Этот РП не утверждает, что идеальная модель уже существует.
Его задача — именно довести агентный слой до того состояния, которое раньше было в основном архитектурной задумкой.
