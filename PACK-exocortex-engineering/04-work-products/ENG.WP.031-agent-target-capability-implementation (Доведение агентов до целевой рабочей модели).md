---
id: ENG.WP.031
name: Доведение агентов до целевой рабочей модели
status: active
created: 2026-04-08
last_updated: 2026-04-09
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

## Slice 4 — Strategist Claude-runtime fallback to Codex

Что сделано:
- по живому логу `Strategist` подтверждён runtime-gap: `Claude-compatible provider` мог падать на `503 / E015 / Internal server error`, но сценарий не уходил в `Codex`, а просто завершался как `failed`;
- в `roles/strategist/scripts/strategist.sh` добавлен отдельный детектор provider-runtime failures;
- такие сбои теперь переводятся в `Codex` fallback, а не считаются конечной точкой отказа;
- `Codex`-ветка у `Strategist` также получила `CODEX_TIMEOUT`, чтобы fallback-path сам не зависал бесконечно.

Почему это важно:
- пользовательский operational contract для агентного слоя теперь жёстче: если Anthropic/Claude path неактивен или нестабилен, рабочий цикл должен продолжаться через GPT/Codex path;
- это уменьшает зависимость `Strategist` от одного provider-а и приближает runtime к целевой модели `provider resilience`.

Что это пока НЕ подтверждает:
- это ещё не полный cross-agent orchestration loop;
- нужен отдельный живой прогон, который покажет именно фактический `Claude failure -> Codex success` на сценарии `Strategist`.

Live evidence on 2026-04-09:
- контролируемый тест `note-review` с подменённым `CLAUDE_PATH` на искусственный `503 / E015` подтвердил runtime path:
  - `Claude-compatible provider runtime failure for note-review on claude-haiku-4-5 — falling back to Codex`
  - затем `Strategist` действительно стартовал `Codex`-ветку с причиной `claude_provider_runtime_failure`
- test был остановлен после подтверждения fallback engagement, чтобы не держать лишний headless run и не вносить побочные изменения в рабочий контур.

## Slice 5 — Strategist recovery-return contract

Что сделано:
- weekly/session-prep prompt для `Strategist` теперь обязан читать `RECOVERY-CATALOG-LOST-INPUTS-*` как отдельный source layer;
- `Inbox Triage` расширен с 3 до 4 корзин, добавлен блок `♻️ Recovery return loop`;
- для recovery items теперь требуется явный weekly/governance verdict:
  - `→ WeekPlan`
  - `→ INBOX backlog`
  - `→ keep in recovery`

Почему это важно:
- раньше recovery catalog мог существовать отдельно от стратегического weekly контура;
- теперь у `Strategist` появился явный contract не просто “знать о recovery”, а возвращать его в управляемый planning loop.

Что это пока НЕ подтверждает:
- пока это prompt/contract layer, а не live end-to-end proof;
- следующий шаг — живой weekly/session-prep сценарий, где recovery item реально попадёт в `WeekPlan` или останется в backlog с явным verdict.

## Slice 6 — Strategist recovery brief generator

Что сделано:
- добавлен `roles/strategist/scripts/build-recovery-brief.sh`;
- генератор собирает актуальный `RECOVERY-CATALOG-LOST-INPUTS-*` в компактный артефакт `DS-strategy/current/RECOVERY-BRIEF.md`;
- `strategist.sh` теперь обновляет recovery-brief перед `session-prep`;
- `session-prep.md` читает не только сырой recovery-catalog, но и готовый brief как compact input.

Live evidence on 2026-04-09:
- генератор успешно построил `current/RECOVERY-BRIEF.md`;
- в brief подняты 3 recovery-элемента, которые действительно требуют weekly/governance verdict:
  - переезд Кипр/Таиланд
  - канал продаж VK Coffee
  - ИИ ассистенты для проработки

Почему это важно:
- recovery layer перестаёт быть “скрытым” markdown-каталогом;
- `Strategist` получает materialized recovery input до запуска weekly/session-prep;
- это уже ближе к управляемому return-loop, чем один только prompt-contract.

Что это пока НЕ подтверждает:
- ещё не доказано, что `Strategist` автоматически вернул эти элементы в WeekPlan или backlog по живому weekly сценарию;
- нужен следующий live proof на `session-prep` или эквивалентном controlled run.

## Slice 7 — Runtime arbiter: Codex detection hardening

Что сделано:
- по живым Telegram alert'ам `2026-04-09 19:15` и `20:15` подтверждён новый operational gap:
  - `Provider plane degraded: codex=missing, claude=available`
- root-cause: `runtime-arbiter.sh` определял Codex только через `command -v codex`; в некоторых launch/scheduler окружениях это давало `missing`, хотя Codex фактически установлен и залогинен;
- в `roles/synchronizer/scripts/runtime-arbiter.sh` добавлен `resolve_codex_path`:
  - сначала `CODEX_PATH`,
  - затем `command -v`,
  - затем fallback по фиксированным путям (`/Applications/Codex.app/...`, `/usr/local/bin`, `/opt/homebrew/bin`, `$HOME/.local/bin`);
- проверка login теперь идёт через найденный бинарник (`"$codex_path" login status`), а не через голый `codex`.

Live evidence on 2026-04-09:
- после фикса:
  - `bash runtime-arbiter.sh --env` вернул `AI_CLI_CODEX_STATUS="available"` и `AI_CLI_PROVIDER_PRIMARY_RESOLVED="codex"`;
  - `health-check.sh` зафиксировал `provider=codex ... codex=available claude=available`;
  - итог health-check: `✅ Среда исправна`.

Почему это важно:
- снимает ложную деградацию provider-plane в мониторинге;
- делает runtime-выбор truthful при урезанном `PATH` у планировщика;
- укрепляет контракт `Codex/Claude parity` без ручного переключения.

## Slice 8 — VPS-first runtime for scheduler/agents

Что сделано:
- добавлен Linux/VPS installer для always-on агентного контура:
  - `setup/optional/setup-vps-agent-runtime.sh`
  - `systemd` templates для `com.exocortex.scheduler.service` и `com.exocortex.scheduler.timer`;
- `scheduler.sh` получил runtime-config слой (`DS-strategy/current/SCHEDULER-RUNTIME.env`):
  - `EXOCORTEX_RUNTIME_TARGET`
  - `EXOCORTEX_DISABLE_LOCAL_DISPATCH`
- локальный scheduler теперь может truthfully уходить в standby, чтобы не было double-run при активном VPS;
- runtime policy в `DS-strategy/current/RUNTIME-POLICY.env` переведена в:
  - `AI_RUNTIME_POLICY=cloud-primary`
  - `CLOUD_TAKEOVER_SCOPE=all-agents`
  - `CLOUD_BOT_RUNTIME_DECLARED=vps`

Почему это важно:
- при выключенном ноутбуке execution больше не должен останавливаться;
- появляется канонический путь миграции `local -> VPS` без ручной пересборки роли;
- снимается главный operational риск пользователя: "день закончился, потому что компьютер выключили".

## Slice 9 — Workspace-layout agnostic runtime layer

Что сделано:
- добавлен единый resolver `roles/synchronizer/scripts/resolve-workspace.sh`;
- ключевые runner'ы переведены с жёсткого `~/Github` на auto-resolve workspace root:
  - `strategist.sh`
  - `extractor.sh`
  - `scheduler.sh`
  - `runtime-arbiter.sh`
  - `health-check.sh`
  - `daily-report.sh`
  - `daily-telegram-report.sh`
  - `opening-contract-check.sh`
  - `code-scan.sh`
  - recovery helpers `build-recovery-brief.sh` и `sync-recovery-into-weekplan.sh`;
- `Strategist` больше не требует macOS-only `caffeinate` для запуска: guard стал conditional.

Что это подтверждает:
- локальный и VPS layout теперь могут использовать один и тот же script layer без ручного переписывания путей;
- `Codex` и `Cloud/Claude` остаются равноправными provider-path'ами, а изменение касается только runtime/layout слоя.

Внешний blocker на 2026-04-09:
- доступ к VPS `72.56.4.61` как `root` подтверждён, но во время синхронизации нового workspace сервер начал сбрасывать SSH/rsync сессии (`Connection reset by peer`);
- additionally на самом VPS обнаружен broken git state:
  - `/root/DS-strategy` указывает на несуществующий remote/repo,
  - `FMT-exocortex-template` там отсутствует как canonical checkout;
- значит blocker сейчас не в agent logic, а в transport/server state:
  - нужен следующий safe-pass по восстановлению canonical checkout на VPS,
  - затем installation pass для `com.exocortex.scheduler`.

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
