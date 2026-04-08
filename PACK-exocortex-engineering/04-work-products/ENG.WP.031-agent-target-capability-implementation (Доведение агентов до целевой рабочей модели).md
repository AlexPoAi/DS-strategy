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

## Ритуал согласования

- Роль владельца implementation-цикла: `Environment Engineer`
- Нанятые роли на этот slice:
  - `Extractor` — intake, classification, outcome-routing
  - `Strategist` — следующий prioritization/return loop
  - `Environment Engineer` — verification, anti-loss gates, runtime hardening
- Текущий implementation focus: сначала довести `Extractor` до materialized outcome-loop, потом замкнуть `Strategist` return path

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

## Таблица разрыва: идеальная модель vs реальность

| Слой цикла | Идеальная модель | Как сейчас по факту | Разрыв | Что нужно сделать |
|---|---|---|---|---|
| `1. Intake` | Все входы попадают в единый intake-layer и не теряются | Основные входы попадают в `captures`, extraction-reports, processed-sessions, но часть живёт параллельно в `creativ-convector`, Telegram и внешних заметках | intake не полностью централизован | закрепить canonical intake map и правила, что считается источником истины |
| `2. Classification` | Агент определяет тип элемента: `Pack / WP / backlog / reject / defer` | `Extractor` умеет частичную классификацию, но governance/growth/personal inputs может распознать и всё равно не вернуть в backlog | классификация есть, но outcome не всегда приводит к сохранению элемента | ввести outcome-статусы и обязательный route для каждого типа |
| `3. Pack routing` | Для Pack-knowledge агент сразу определяет целевой Pack и создаёт candidate card | routing частично работает, но full-loop на реальных recovery-cases не доказан | нет гарантии, что кандидат дойдёт до устойчивого Pack/WP контура | дотянуть `Extractor` до полного routing loop с артефактом |
| `4. Governance routing` | Если это не Pack-knowledge, агент переводит элемент в `INBOX`/strategic backlog/recovery | именно тут был подтверждённый провал: `rejected` capture мог содержательно распознаться, но в `INBOX` не попасть | governance/growth inputs частично “исчезают” | правило: governance/growth/personal inputs нельзя терять в reject-пустоту |
| `5. Artifact creation` | На выходе всегда есть управляемый артефакт: task, recovery item, candidate card, WP draft | чаще всего есть report, но не всегда есть следующий управляемый объект | report ≠ завершённый loop | сделать артефакт обязательной частью outcome semantics |
| `6. Dedup / anti-loss` | Повторный запуск не создаёт дублей и не стирает след элемента | уже есть частичные safeguards, но полного anti-loss contract между `captures`, rejected, `INBOX`, recovery нет | возможны повторные трактовки и ручные провалы | спроектировать dedup/anti-loss contract между слоями |
| `7. Strategist return loop` | `Strategist` берёт recovered items и превращает их в weekly/backlog priorities | `Strategist` хорошо держит ритуалы, но full chaos-structuring/recovery-return loop не доказан | recovered inputs ещё не всегда доходят до управляемого приоритета автоматически | добавить strategist-side contract на работу с recovery items |
| `8. Verification` | Система сама доказывает, что цикл прошёл end-to-end без потери | есть первая verification-wave и truthful acceptance, но не полный orchestrated loop | verification пока частично ручная | добить один живой end-to-end сценарий и закрепить его как acceptance example |

## Truthful snapshot на сегодня

- **Идеальная модель описана**: да
- **Truthful current-state зафиксирован**: да
- **Первый recovery-pass сделан**: да
- **Полный цикл от входа до правильного Pack/WP/backlog работает надёжно**: ещё нет
- **Следующий ключевой implementation owner**: `Extractor + Strategist` в рамках `ENG.WP.031`

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

## Slice 1 — Extractor outcome contract

Что сделано:
- `Extractor` больше не описывается как бинарный `Pack / reject` контур;
- в его docs и `inbox-check` prompt введены явные outcome-статусы:
  - `pack_candidate`
  - `backlog_task`
  - `recovery_item`
  - `rejected`
  - `deferred`
- прямо закреплено правило: governance/growth/personal inputs нельзя терять в пустой `reject`, если для них есть осмысленный DS/backlog route.

Артефакты:
- [roles/extractor/README.md](/Users/alexander/Github/FMT-exocortex-template/roles/extractor/README.md)
- [ACCEPTANCE.md](/Users/alexander/Github/FMT-exocortex-template/roles/extractor/ACCEPTANCE.md)
- [prompts/inbox-check.md](/Users/alexander/Github/FMT-exocortex-template/roles/extractor/prompts/inbox-check.md)

Что это пока НЕ подтверждает:
- это ещё не live end-to-end proof;
- это implementation contract layer, который теперь можно проверять на реальном сценарии.

## Slice 2 — Extractor materialized outcome loop

Что сделано:
- в `roles/extractor/scripts/extractor.sh` добавлен post-check для `inbox-check`;
- `Extractor` теперь не должен считать success достаточным, если report не породил materialized след:
  - `pack_candidate` / `backlog_task` -> след в `INBOX-TASKS.md`
  - `recovery_item` -> recovery-catalog за текущую дату
  - `rejected` -> archive entry
  - processed captures -> `[analyzed YYYY-MM-DD]`
- staging/commit coverage расширена: в git теперь входят не только `captures` и `extraction-reports`, но и recovery/archive слой.

Что это подтверждает:
- `report != success` зафиксировано уже не только в docs, но и в runtime enforcement слое;
- подтверждённый gap, где recovery/archive артефакты могли создаться, но не попасть в git, закрыт на уровне runner.

Что это пока НЕ подтверждает:
- это ещё не полный `Strategist` return loop;
- это ещё не доказывает full recovery по всем историческим источникам.

## Slice 3 — Extractor provider timeout guard

Что сделано:
- живой прогон `inbox-check` показал новый runtime-gap: `codex exec` может зависнуть в headless режиме, не доводя outcome-loop до финала;
- в `roles/extractor/scripts/extractor.sh` добавлен `CODEX_TIMEOUT` и timeout-wrapper для provider execution;
- timeout теперь классифицируется как явный runtime failure, а не бесконечное зависание headless job.

Почему это важно:
- пока provider может висеть бесконечно, даже хороший outcome-contract не считается operationally safe;
- для ночного/автоматического `inbox-check` нужен bounded runtime, иначе возможны partial edits и подвисшие launchd циклы.

Что дальше:
- следующий practical hardening — добавить atomic apply guard, чтобы при timeout/abort partial edits не оставались в `captures` или соседних артефактах.

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
