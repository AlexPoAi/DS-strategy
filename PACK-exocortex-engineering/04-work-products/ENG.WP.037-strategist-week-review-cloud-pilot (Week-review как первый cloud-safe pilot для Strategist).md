---
type: engineering-work-product
wp_id: ENG.WP.037
title: Week-review как первый cloud-safe pilot для Strategist
date: 2026-04-13
status: active
priority: critical
linked_inbox: ENGINEERING
author: Environment Engineer (Codex)
---

# ENG.WP.037 — Week-review как первый cloud-safe pilot для Strategist

## Контекст

После `ENG.WP.019-021`, `ENG.WP.035` и `ENG.WP.036` картина зафиксирована:

- `Strategist` остаётся главным слабым звеном агентного слоя;
- лучший путь к эталону — не полный cloud-clone, а симбиоз:
  - надёжность и простота как у Церена;
  - truthful governance и ритуалы как у нас;
- первым кандидатом на `24x7` является не весь `Strategist`, а сценарий `week-review`.

## Основание

- команда пользователя: продолжить по `Strategist` как по слабому звену;
- команда пользователя: не забывать ритуалы открытия/закрытия рабочих продуктов;
- команда `сверь с эталоном` уже применена в `ENG.WP.036`.

## Эталонная рамка

Для этого WP принимаем:

- **надёжность выше экономии токенов**;
- pilot не должен ломать local-primary контур;
- pilot не должен создавать `double-run`;
- pilot должен быть truthfully observable и иметь явный verdict.

## Цель WP

Спроектировать минимальный и безопасный `cloud-safe` pilot для `Strategist/week-review`, чтобы:

1. проверить реальную исполнимость `24x7` сценария;
2. не выносить весь `Strategist` в облако;
3. получить testable контракт для последующего запуска и проверки.

## Что уже знаем

- `Strategist` локально стал устойчивее, но всё ещё `functional but fragile`;
- логирование уже облегчено;
- `SESSION-CONTEXT` уже сжат;
- opening/startup drift уже снят;
- следующий честный шаг — не ещё один локальный hotfix, а pilot-контракт.

## Рабочий план

1. Поднять и сверить прежний план по `Strategist` и `week-review`.
2. Сверить pilot с эталоном.
3. Выделить минимальный безопасный scope `week-review`.
4. Определить `no-double-run` и ownership contract.
5. Подготовить сценарий тестового запуска после починки.
6. Только потом переходить к live-run.

## Решение по pilot-scope

### Что берём

В pilot берём только `week-review` как scheduled сценарий со следующими свойствами:

- один запуск на окно недели;
- один truth-producing runner;
- единые result semantics;
- без выноса `day-close`, `note-review` и `strategy-session`.

### Что НЕ берём

В этот pilot сознательно не входят:

- полный cloud clone `Strategist`;
- изменение canonical `open/work/close` маршрутов;
- параллельный local+cloud запуск одного weekly сценария;
- любые сценарии, требующие живого интерактивного governance.

## No-double-run contract

Для `week-review` pilot принимается:

1. пока local heartbeat свежий -> local strategist остаётся primary;
2. cloud pilot не имеет права писать competing weekly result поверх локального;
3. pilot допустим либо как:
   - dry-run без truth-writing;
   - либо как единственный writer в явно выделенном окне.

На сегодня безопасный режим:
- **dry-run / contract validation first**.

## Тестовый запуск на сегодня

Сегодняшний тест должен ответить не на вопрос “умеем ли мы уже жить в облаке”, а на вопрос:

- готов ли `Strategist/week-review` к truthfully controlled rerun без старых слабых мест.

### Цель теста

Проверить:

1. что `Strategist` стартует без старых startup/opening drift;
2. что сценарий weekly не шумит и не раздувает лог;
3. что result semantics остаются truthful;
4. что weekly path можно использовать как основу для следующего pilot-slice.

### Формат теста

1. локальный controlled run;
2. без cloud writer;
3. с проверкой:
   - status artifact;
   - основной лог;
   - raw-output archive;
   - итоговый verdict.

## Быстрый verdict

На сегодня лучший путь такой:

- **не** пытаться запускать весь `Strategist` “по-новому” сразу;
- сначала truthfully прогнать `week-review` как controlled local test;
- если weekly path стабилен, это становится входом в следующий slice:
  - remote/cloud-safe pilot.

## Slice 1 — scenario-specific Codex fallback облегчён

Реализован первый минимальный implementation slice:

- для `week-review` введён отдельный Codex fallback-контракт;
- вместо общего тяжёлого `gpt-5.4` weekly теперь использует:
  - `gpt-5.4-mini`
  - timeout `600s`
- остальной `Strategist` не затронут.

### Truthful результат slice 1

- progress есть:
  - `week-review` больше не ломается на старом opening/shell drift;
  - fallback-path стал уже и дешевле;
- но сценарий всё ещё не завершился успешно:
  - weekly зависает уже внутри самого fallback execution path;
  - артефакты `WeekPlan / post` не были созданы;
  - slice оценивается как `partial`, а не `pass`.

### Новый вывод

Следующий implementation slice должен бить уже не в модель как таковую, а в **облегчённый weekly contract**:

- thinner prompt;
- меньше обязанностей в fallback-режиме;
- сначала core weekly result в `WeekPlan`;
- тяжёлый publishing / week-close tail — отдельно или позже.

## Slice 2 — provider contract diagnostics

Проведена отдельная живая диагностика provider-path для `week-review`.

### Что подтверждено

- `Sonnet` сейчас не является надёжным default-path:
  - на weekly path дал `API Error 400 / E005 / Invalid request`;
  - как стабильный primary-path не подтверждён;
- `Haiku` живой:
  - прямой короткий CLI-пинг прошёл успешно;
- dual-provider логика стала truthful:
  - сначала Claude-compatible path;
  - затем fallback внутри Claude-path;
  - затем Codex как второе плечо.

### Решение по default-contract

Пока не будет нормального доступа/подписки для `Sonnet`, стабильный default оставляем таким:

- `Claude Haiku` = primary stable path;
- `Claude Sonnet` = future-path / not trusted as default right now;
- `Codex` = второе плечо fallback-контура.

### Truthful verdict slice 2

- improved, but not done;
- слабое место `Strategist` теперь локализовано уже очень узко:
  - не routing;
  - не opening;
  - не lock-модель как главная причина;
  - а именно `week-review` execution contract и provider compatibility.

## Критерий завершения

WP считается завершённым, когда есть:

- короткий pilot-контракт;
- понятный порядок запуска;
- правила `local/cloud`;
- критерии успеха/ошибки;
- следующая команда на реальный тест без архитектурной двусмысленности.
