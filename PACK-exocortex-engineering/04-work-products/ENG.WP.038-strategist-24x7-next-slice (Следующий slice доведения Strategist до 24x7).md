---
type: engineering-work-product
wp_id: ENG.WP.038
title: Следующий slice доведения Strategist до 24x7
date: 2026-04-13
status: active
priority: critical
linked_inbox: ENGINEERING
author: Environment Engineer (Codex)
---

# ENG.WP.038 — Следующий slice доведения Strategist до 24x7

## Контекст

После:

- `ENG.WP.021` — зафиксирован общий контракт `24/7` для `Strategist`;
- `ENG.WP.036` — проведена сверка с эталоном и подходом Церена;
- `ENG.WP.037` — `week-review` подтверждён как первый стабильный weekly path:
  - `Claude Haiku` = stable primary path;
  - `Claude Sonnet` = broken for current weekly contract;
  - `Codex` = второе плечо fallback.

Теперь следующий честный шаг — не повторять weekly-pass, а довести `Strategist` от локально стабильного weekly-path к следующему `24/7` slice без поломки truthful-контуров.

## Основание

- команда пользователя: добивать `Strategist` как главное слабое звено;
- команда пользователя: сначала `Церен -> эталон -> РП -> реализация`;
- команда пользователя: вести инженерные шаги через ритуалы рабочих продуктов.

## Сверка с эталоном

Эталон для этого slice:

- надёжность выше экономии токенов;
- один source-of-truth на сценарий;
- никакого `double-run`;
- local/cloud граница явно названа;
- deep-work сценарии не выносятся в always-on до отдельного redesign.

Следовательно, этот slice не должен:

- превращать весь `Strategist` в cloud-runner;
- ломать `open/work/close`;
- подменять локальный `Strategist` псевдо-облачным клоном.

## Что уже считается решённым

- opening/startup drift снят;
- `SESSION-CONTEXT` облегчён;
- weekly-path больше не является главным blocker;
- provider semantics truthfully диагностированы.

## Главный вопрос этого slice

Что является **следующим минимальным 24/7-улучшением** после weekly-pass:

1. выделить `week-review` как отдельный always-on contract;
2. определить следующего cloud-safe кандидата;
3. или сперва довести scheduler/synchronizer runtime, чтобы не ломать orchestration.

## Рабочая гипотеза

Наиболее вероятный следующий правильный ход:

- не трогать ещё `session-prep` и не выносить новый сценарий сразу;
- сначала усилить `Strategist` как orchestrated runtime:
  - scheduler truth;
  - status artifacts;
  - one-run semantics;
  - provider fallback discipline.

То есть следующий slice вероятнее должен быть:

- **не новый prompt-сценарий**,
- а **runtime-contract slice** вокруг already-working `week-review`.

## Кандидаты на следующий slice

### Вариант A — week-review runtime hardening

Сделать weekly-path эталонно наблюдаемым и reproducible:

- явный success contract;
- проверка side-effects;
- защита от ложного `success`;
- стабильная модельная политика.

### Вариант B — session-prep как второй cloud-safe кандидат

Начать следующий сценарий после weekly-pass.

Риск:

- можно слишком рано раздвинуть scope.

### Вариант C — scheduler/synchronizer first

Сначала убедиться, что orchestrator-layer сам по себе эталонно стабилен, и только потом расширять `Strategist`.

## Предварительный verdict

Лучший следующий путь сейчас:

- **Вариант A + C в связке**:
  - сначала подтвердить runtime-contract weekly-path;
  - затем коротко сверить `scheduler/synchronizer`;
  - только потом расширять сценарии `Strategist`.

## План работ

1. Сверить текущий weekly-path с эталоном результата:
   - какой артефакт считается обязательным;
   - что считается ложным `success`;
   - что должно логироваться.
2. Снять, кто именно оркестрирует weekly:
   - scheduler;
   - synchronizer;
   - strategist status layer.
3. Зафиксировать минимальный runtime-contract `Strategist 24x7 next`.
4. После этого решить:
   - остаёмся ещё на weekly runtime hardening;
   - или открываем следующий сценарный slice.

## Найденный orchestration-gap

Во время runtime-сверки weekly-path найден конкретный drift:

- `scheduler` мыслит `week-review` как weekly scenario через marker `W{week}`;
- `strategist.sh` внутри самого weekly-path проверял повторный запуск по функции `already_ran_today()`;
- при этом status message уже называл это `same-week completion`.

Это означало semantic mismatch:

- orchestration снаружи — weekly;
- guard внутри сценария — daily.

## Решение текущего slice

В текущем slice weekly guard выровнен:

- для `week-review` введена проверка `already_ran_this_week()`;
- повторный skip теперь truthfully означает completion в текущем `week-window`, а не в пределах одного дня.

### Что это даёт

- меньше риск ложной семантики `success`;
- weekly-path становится ближе к эталону `one scenario -> one truth window`;
- `scheduler` и `strategist` начинают мыслить weekly одинаково.

## Второй найденный orchestration-gap

После первой правки выявлен ещё один риск:

- `scheduler` ставил weekly marker по одному только `exit 0` от `strategist.sh`;
- при этом status-artifact weekly-path живёт отдельно;
- следовательно, существовал риск ложного `done`, если сценарий когда-либо вернёт `0`, но не оставит verified-success result.

## Второе решение текущего slice

В `scheduler` добавлена проверка `weekly_status_verified()`:

- weekly marker теперь ставится только если:
  - `strategist-week-review.status` существует;
  - `STATUS=success`;
  - `EVIDENCE_STATUS=verified`.

Если `strategist.sh` вернул `0`, но verified-success не подтверждён:

- weekly marker не ставится;
- scheduler пишет предупреждение и оставляет сценарий на повторный проход.

### Что это даёт

- снимается двойная и слишком мягкая семантика успеха;
- `scheduler` перестаёт быть независимым source-of-truth;
- verified status-artifact становится главным доказательством успешного weekly run.

## Общее правило provider-chain для ключевых агентов

По команде пользователя зафиксирована единая модель provider fallback для всего ключевого агентного слоя:

- `Claude Haiku` → primary;
- `Claude Sonnet` → внутренний fallback;
- `Codex` → внешний fallback, если Claude-path не сработал.

### Что уже выровнено

- `Strategist` приведён к этой схеме;
- `Extractor` приведён к этой схеме;
- `Codex` остаётся равноправным вторым плечом, но не должен перехватывать primary path раньше `Claude Haiku / Sonnet`.

### Что это даёт

- единая предсказуемая модель поведения агентов;
- меньше неожиданных уходов сразу в `Codex`;
- более truthful диагностика реального состояния `Claude`-контура.

## Третий найденный drift — weekly missing маскировался после понедельника

Во время проверки `scheduler/synchronizer` найден ещё один semantic drift:

- `daily-report.sh` и `health-check.sh` считали отсутствие `strategist-week-review` ожидаемым просто потому, что сегодня не понедельник;
- это означало, что во вторник–воскресенье система могла слишком мягко скрыть факт, что weekly вообще не был получен в текущем weekly window.

## Третье решение текущего slice

Логика `task_missing_is_expected()` для `strategist-week-review` ужесточена:

- отсутствие weekly больше не считается “нормой после понедельника”;
- если weekly missing, это остаётся видимым сигналом until real completion is present.

### Что это даёт

- меньше ложной жёлто-зелёной картины;
- weekly-path становится наблюдаемым не только в понедельник, но на всём окне недели;
- это ближе к эталону `stable first`, где система не скрывает неисполненный weekly contract.

## Стратегия доведения Strategist до 24x7

### Фаза 1 — Weekly contract solid

Цель:

- сделать `week-review` полностью эталонным scheduled-path.

Критерии:

- один weekly window;
- один verified success;
- одна truth-semantics между `strategist`, `scheduler`, `daily-report`, `health-check`;
- provider-chain стабильна: `Haiku -> Sonnet -> Codex`.

Статус:

- **почти выполнено**.

### Фаза 2 — Orchestrator truth

Цель:

- довести `scheduler/synchronizer` до состояния, где они не:
  - маскируют пропуски;
  - не создают второй source-of-truth;
  - не вводят мягкие ложные зелёные статусы.

Что сюда входит:

- проверка status-artifacts;
- корректные weekly/daily windows;
- строгая видимость missing/stale;
- отсутствие `double-run`.

Статус:

- **частично выполнено**, но ещё нужен финальный short audit всего orchestration-layer.

### Фаза 3 — Second cloud-safe scenario

Цель:

- выбрать следующий сценарий после weekly.

Кандидат:

- `session-prep`

Но только после:

- завершения Фазы 2;
- и только как тонкий scheduled contract, не как full deep-work move.

Статус:

- **ещё не начинали реализацию**.

### Фаза 4 — 24x7 Strategist pilot

Цель:

- получить честный partial `24/7` Strategist:
  - не весь агент;
  - а набор cloud-safe scheduled scenarios.

Входит:

- `week-review`
- затем `session-prep`
- при необходимости позднее `morning/opening-summary`

Не входит:

- `day-close`
- `strategy-session`
- интерактивный deep-work

## Новый практический вывод

Лучший путь теперь выглядит так:

1. Закончить `weekly + orchestration` как один solid runtime layer
2. Провести короткий final audit `scheduler/synchronizer`
3. Только потом брать `session-prep`
4. Не трогать deep-work сценарии до отдельного redesign

## Текущий truthful status

`Strategist 24/7` сейчас:

- уже **не broken**
- уже **не weekly-fragile**
- но всё ещё **partial**

Ближайшая цель:

- перевести его из `partial` в `stable scheduled partial`

## Критерий завершения

WP считается завершённым, когда:

- выбран следующий минимальный `24/7` slice;
- он сверён с эталоном;
- риск `double-run` и ложного `success` оценён;
- следующий implementation step назван без архитектурной двусмысленности.
