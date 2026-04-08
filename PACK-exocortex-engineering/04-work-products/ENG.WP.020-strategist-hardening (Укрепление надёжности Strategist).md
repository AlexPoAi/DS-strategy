---
type: engineering-work-product
wp_id: ENG.WP.020
title: Укрепление надёжности Strategist
date: 2026-04-05
status: active
priority: critical
linked_inbox: ENGINEERING
author: Environment Engineer (Codex)
---

# ENG.WP.020 — Укрепление надёжности Strategist

## Контекст

После [ENG.WP.019-strategist-reliability-history (История надёжности и сбоев Strategist).md](/Users/alexander/Github/DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.019-strategist-reliability-history%20%28%D0%98%D1%81%D1%82%D0%BE%D1%80%D0%B8%D1%8F%20%D0%BD%D0%B0%D0%B4%D1%91%D0%B6%D0%BD%D0%BE%D1%81%D1%82%D0%B8%20%D0%B8%20%D1%81%D0%B1%D0%BE%D0%B5%D0%B2%20Strategist%29.md) стало ясно:

- `strategist` уже починен по нескольким слоям,
- но остаётся самым хрупким local-primary агентом,
- а реальные operational хвосты всё ещё живут в `auth`, `week-review`, `day-close` и runtime-совместимости.

## Цель

Довести `strategist` из состояния `functional but fragile` до состояния:

- `truthful and operationally predictable local-primary agent`

Без попытки сейчас превращать его в always-on сервис.

## Scope этого WP

### 1. Auth failure hardening

Нужно сделать так, чтобы `strategist` больше не умирал тихо:

- детектировать `401`, `Auth failed`, helper/env/custom API failures;
- давать немедленный локальный сигнал;
- не оставлять пользователя в ложном ощущении, что сценарий просто “не отработал”.

### 2. `day-close` runtime hardening

Нужно закрыть remaining gap между:

- runner repaired
- и реально надёжным `day-close`

Проверить и стабилизировать:

- locking
- timeout / runtime budget
- поведение при `claude` auth-loss
- truthful финальный verdict

### 3. `week-review` recovery

`strategist-week-review` всё ещё висит pending как отдельный хвост. Его надо:

- воспроизвести;
- понять, это auth/runtime/model issue или отдельный сценарный дефект;
- вернуть в рабочее состояние или честно понизить его статус до unsupported path.

### 4. Runtime compatibility

Проверить и уменьшить хрупкость относительно:

- `bash 3.2`
- shell wrappers
- `CLAUDE_PATH`
- model selection / fallback
- локальных логов и lock-paths

## Не входит в этот WP

- полный remote redesign `strategist`
- перенос `strategist` на VPS
- полный OpenAI-runtime refactor
- переписывание всех protocol-runs на новый оркестратор

Это отдельный следующий слой.

## План работ

1. Свести все pending хвосты по `strategist` из `INBOX` в один actionable checklist
2. Проверить текущие места:
   - [strategist.sh](/Users/alexander/Github/FMT-exocortex-template/roles/strategist/scripts/strategist.sh)
   - runtime logs
   - `protocol-close.md`
   - `week-review` entry
3. Усилить auth-failure observability
4. Прокатить `day-close` и `week-review` как отдельные acceptance paths
5. Зафиксировать truthful verdict:
   - `stable`
   - `stable with caveats`
   - или `architecturally limited`

## Acceptance criteria

WP можно считать успешным, если:

1. `strategist` не падает молча на auth-loss
2. `day-close` даёт предсказуемый truthful result class
3. `week-review` либо починен, либо честно выведен в unsupported/legacy
4. в инженерном Pack появляется понятный `hardening outcome`, а не ещё одна россыпь симптомов

## Текущий truthful статус

WP только открыт.

## Первый выполненный slice

Сделан первый low-risk hardening шаг:

- auth-failure у `strategist` больше не ограничен только локальным `osascript`;
- при срабатывании auth-детектора runner теперь шлёт отдельный Telegram alert через `notify.sh`;
- сценарий алерта отделён от обычных success-notify сценариев.

Это не лечит сам `claude /login`, но резко уменьшает риск тихого падения `strategist`.

## Второй выполненный slice

Исправлена truthful semantics раннера:

- `run_claude()` больше не пишет `Completed scenario` при `exit code != 0`;
- timeout и прочие runtime ошибки теперь возвращаются как реальный failure, а не как псевдоуспех;
- в логах появился явный `Scenario result: ... status=success|failed|timeout`.

Это особенно важно для `week-review` и `day-close`, потому что раньше сценарий мог формально выглядеть завершённым даже после реального сбоя.

## Третий выполненный slice

Усилена lock-механика:

- lock теперь PID-aware;
- runner различает живой lock и stale lock;
- stale lock очищается автоматически перед новым запуском сценария;
- это снижает риск ложного состояния “сценарий уже идёт”, когда процесс давно умер.

## Четвёртый выполненный slice

Усилен prompt preflight:

- `strategist` теперь подставляет реальные `{{WORKSPACE_DIR}}`, `{{HOME_DIR}}`, `{{GITHUB_USER}}` перед запуском Claude;
- `WORKSPACE` больше не привязан жёстко к `~/IWE`, а предпочитает реальный `~/Github` с fallback на legacy-path;
- это уменьшает semantic drift в `week-review`, `day-plan`, `session-prep` и других protocol-like сценариях.

## Actionable checklist

1. Проверить auth-failure alert end-to-end
2. Воспроизвести и классифицировать `week-review`
3. Проверить `day-close` на auth-loss и truthful result class
4. Проверить lock/timeout semantics для `day-close`
5. После этого решить, нужен ли отдельный WP на `strategist remote-capable runner`

## Пятый выполненный slice

Починен live-path утреннего открытия дня:

- `day-plan` в `strategist.sh` больше не читает deprecated prompt-файл и теперь резолвится в canonical `memory/protocol-open.md`;
- runner снова уважает внешний `CLAUDE_PATH`, то есть wrapper/env override реально работают, а не затираются локальным дефолтом;
- детектор model-path failures расширен под `API Error: 400 {"code":"E005","message":"Invalid request"}`, чтобы `Haiku -> Sonnet` fallback срабатывал и на этом классе ошибок;
- mock smoke test подтвердил сценарий:
  - attempt 1: `claude-haiku-4-5` -> `E005 Invalid request`
  - automatic fallback -> `claude-sonnet-4-6`
  - success на втором проходе

Это не закрывает весь WP.020, но снимает актуальный operational дефект сегодняшнего morning-run.

## Шестой выполненный slice

Закрыт ложный headless-path для `day-close`:

- подтверждено по логам `2026-04-06`, что `strategist.sh day-close` кормил интерактивный `protocol-close.md`, получал уточняющий вопрос и ошибочно маркировал запуск как `success`;
- это не runtime timeout bug, а architectural mismatch между headless runner и interactive close protocol;
- `strategist.sh day-close` переведён в truthful отказ с `status=unsupported_path` и `exit_code=19`;
- в качестве canonical маршрута оставлен только интерактивный `protocol-close`.

Итог: опасный псевдо-автоматический путь закрытия дня больше не может создать ложное ощущение, что день был закрыт корректно.

## Седьмой выполненный slice

Снят аварийный shell-crash у `note-review`:

- canary counters для `fleeting-notes.md` переведены на deterministic helper functions вместо `grep ... || echo 0`, из-за которых появлялось значение вида `0\n0`;
- отсутствие `DS-strategy/inbox/fleeting-notes.md` теперь считается допустимым нулевым состоянием и логируется как warning, а не ломает весь nightly path;
- deterministic cleanup route исправлен с несуществующего `cleanup-processed-notes.py` на реальный `cleanup-processed-notes.sh`.

Проверка:

- `bash -n strategist.sh` проходит;
- `bash -n cleanup-processed-notes.sh` проходит;
- `strategist.sh note-review` больше не падает мгновенно на canary/cleanup stage и доходит до provider execution path.

## Восьмой выполненный slice

Снят legacy path-drift у `strategy_day` configuration:

- `strategist.sh` больше не читает `day-rhythm-config.yaml` только из мёртвого legacy-пути `~/.claude/projects/...-IWE/...`;
- добавлен truthful resolver, который сначала ищет config в canonical workspace / current `.claude/projects` путях для `Github`, и только потом пробует legacy `IWE`;
- при отсутствии конфига runner теперь явно логирует `Strategy day config: missing -> monday`, вместо тихого скрытого fallback без объяснения;
- это уменьшает риск ложного выбора `session-prep` / `day-plan` из-за незаметного path-drift после миграции `IWE -> Github`.

## Девятый выполненный slice

Найдена и снята реальная причина ложной lock-семантики morning-run:

- в runtime одновременно жили `com.exocortex.scheduler` и legacy launchd jobs `com.strategist.morning` / `com.strategist.weekreview`;
- из-за этого `Strategist` мог стартовать дважды: один экземпляр честно получал file-lock и писал `SKIP`, а второй реально выполнял `day-plan`;
- старые launchd jobs выгружены из `launchctl` и переведены в `.plist.disabled`;
- в `health-check.sh` добавлен отдельный detector на legacy Strategist jobs alongside scheduler, чтобы такой конфликт больше не возвращался тихо.

Итог: false-concurrent morning semantics больше не должны повторяться, пока source-of-truth runtime остаётся только `com.exocortex.scheduler`.

## Десятый выполненный slice

Снят semantic/path drift у `week-review`:

- `strategist.sh` больше не логирует weekly scenario как `Sunday`, если реальное scheduler-окно уже живёт по понедельнику;
- usage/help выровнены под truthful окно `Monday 00:00 local`;
- prompt `week-review.md` больше не жёстко указывает в несуществующий `DS-Knowledge-Index`, а получает реальный `{{KNOWLEDGE_INDEX_DIR}}` / `{{KNOWLEDGE_INDEX_REPO}}`;
- fallback push после weekly scenario тоже переведён на resolver knowledge-index репозитория, так что сценарий не зависит от legacy `~/IWE/DS-Knowledge-Index`.

Итог: `week-review` теперь меньше зависит от удачного контекстного угадывания и ближе к повторяемому scheduled-сценарию с одним source-of-truth.

## Одиннадцатый выполненный slice

Починен Telegram notify-path для weekly strategist scenario:

- `notify.sh strategist week-review` больше не возвращает пустое сообщение из-за literal `{{WORKSPACE_DIR}}` в template `roles/synchronizer/scripts/templates/strategist.sh`;
- strategist notification template переведён на runtime workspace resolution (`~/Github` с fallback на `~/IWE`);
- локальная проверка `build_message week-review` теперь возвращает корректный weekly summary и GitHub-ссылку на актуальный WeekPlan.

Итог: weekly scenario больше не должен молча завершаться без Telegram-сообщения только из-за broken template path.

## Двенадцатый выполненный slice

Убран опасный reinstall-path, который мог вернуть legacy double-run:

- `roles/strategist/install.sh` больше не копирует и не загружает `com.strategist.morning` / `com.strategist.weekreview`;
- install-script теперь честно удаляет legacy plist из `~/Library/LaunchAgents`, оставляет только ручной strategist entrypoint и отправляет к `roles/synchronizer/install.sh`;
- README Strategist обновлён под текущий runtime contract: scheduled source-of-truth = `com.exocortex.scheduler`.

Итог: даже после повторной установки роли `Strategist` legacy launchd jobs не должны тихо возвращаться в систему и ломать no-double-run правило.

## Тринадцатый выполненный slice

Дочищен remaining legacy wording внутри самого Strategist:

- `week-review.md` больше не объявляет `launchd` как runtime source-of-truth, а ссылается на `com.exocortex.scheduler`;
- `note-review.md` тоже переведён с `launchd` на scheduler-based wording;
- README Strategist выровнен до конца: `session-prep`, `day-plan` и `week-review` теперь все ссылаются на один и тот же scheduler-runtime.

Итог: у Strategist больше нет внутреннего расхождения между runtime-contract в коде и тем, что читают prompt/doc consumers.

## Четырнадцатый выполненный slice

Добавлен proactive smoke-check на weekly notify-contract Strategist:

- в `health-check.sh` появился отдельный `check_strategist_notify_contract()`;
- он source'ит strategist notification template и проверяет, что `build_message week-review` реально возвращает непустое сообщение;
- живой прогон `health-check` подтвердил новый guard: `ОК: strategist notify template builds week-review message`.

Итог: broken weekly Telegram-template теперь должен ловиться как инженерная ошибка среды заранее, а не только по факту “почему не пришёл отчёт”.

## Пятнадцатый выполненный slice

`Strategist` переведён с косвенной observability на прямую запись собственных status-artifacts:

- `strategist.sh` теперь сам пишет `~/.local/state/exocortex/status/strategist-*.status` для `morning`, `week-review` и `note-review`;
- статус обновляется на старте сценария (`running`) и затем фиксируется как `success / failed / timeout / auth_failed`;
- lock-конфликт тоже больше не остаётся только в логе: при живом lock пишется `running`-artifact с понятным summary;
- это уменьшает зависимость `daily-report` и `health-check` от legacy markers и grep по старым логам.

Итог: статусный слой Strategist становится source-of-truth ближе к самому runner'у, а не к downstream реконструкции по косвенным следам.

## Шестнадцатый выполненный slice

`Strategist` начал использовать собственные status-artifacts и для no-double-run проверки:

- `already_ran_today()` теперь сначала смотрит в свежий `strategist-*.status`, и только потом откатывается к legacy grep по логу;
- это уменьшает зависимость от лог-файла как единственного источника правды о том, завершался ли сценарий сегодня;
- особенно полезно для `morning`, `week-review` и `note-review`, где повторный запуск после частичных сбоев был одним из исторических failure-классов.

Итог: status-artifacts теперь не просто “пишутся для отчётов”, а реально участвуют в operational semantics самого runner'а.

## Семнадцатый выполненный slice

Выровнена lock-semantics между `Strategist` и `scheduler`:

- `scheduler.sh` теперь трактует `exit 2` для `week-review` и `note-review` так же, как уже трактовал для morning-path;
- живой lock больше не логируется как ложный `WARN: failed`, а идёт как `INFO: уже выполняется (lock), ждём завершения`;
- failure-ветка теперь честно пишет и `exit code`, если это действительно не lock, а ошибка.

Итог: scheduler больше не смешивает “сценарий реально сломан” и “сценарий уже выполняется другим экземпляром” для weekly/nightly strategist-paths.
