---
id: WP-91
title: "Tomorrow plan and done criteria for Librarian-Park contour"
status: done
priority: high
owner: "Strategist"
created: 2026-04-19
updated: 2026-04-19
---

# Контекст

После `WP-90` контур `Knowledge Registry Curator + Park` стал достаточно зрелым, чтобы заранее зафиксировать:
- что именно делать завтра;
- что считать корректным завершением этой работы;
- по каким признакам утром понимать, что мы двигаемся к operational result, а не просто к ещё одной красивой классификации.

Этот planning-slice фиксирует только мой слой.
Общие day/session closing-артефакты второго окна сюда не подмешиваются.

# Цель

1. Собрать чёткий завтрашний маршрут по контуру `Библиотекарь + Park`.
2. Зафиксировать finish state.
3. Подготовить truthful критерий завершения, чтобы не работать бесконечно "над улучшением".

# План на завтра

## Главный луч

Завтра продолжать не весь мир сразу, а именно:
- `Knowledge Registry Curator`
- `Park` как pilot-domain

## Последовательность

1. Открыть день и войти в контур `Knowledge Registry Curator + Park`.
2. Прогнать первый живой `SRT-aware` slice по `Park`.
3. Проверить, как Библиотекарь различает:
   - `note`
   - `task`
   - `blocker`
   - `WP candidate`
4. Проверить routing:
   - что остаётся у Библиотекаря;
   - что передаётся следующему агенту;
   - что поднимается в `Strategist`.
5. Вынести truthful verdict:
   - `operational`
   - `partial`
   - `needs another bounded slice`

# Finish State

Работа по этому контуру считается корректно завершённой, если достигнуты все условия ниже.

## 1. Рабочий Библиотекарь

`Knowledge Registry Curator`:
- различает `note / task / WP / domain / subdomain`;
- умеет назначать `srt_slot`, не превращая `SRT` в source-of-truth;
- понимает, что является именно задачей, а не просто записью;
- умеет передать задачу дальше в правильный агентный контур.

## 2. Рабочий pilot-domain Park

Для `Park`:
- есть устойчивая карта `subdomain`;
- виден `coverage_state`;
- видны `primary_sources`;
- видны `open questions`;
- понятно, что требует нового WP, а что уже monitoring layer.

## 3. Рабочий routing layer

Есть живой маршрут:
- заметка входит;
- Библиотекарь её различает;
- если это задача, она правильно маршрутизируется дальше;
- если это blocker, собирается evidence-first ход;
- если это weekly decision, это поднимается в `Strategist`.

# Truthful критерий done

Для нас `done` здесь — не "идеальный навсегда агент", а:
- operationally working `Knowledge Registry Curator`;
- `Park` как подтверждённый pilot-domain;
- рабочий `registry + routing` слой вместо одного только `notes classification`.

# Следующий шаг

Утром открыть этот WP как planning anchor и пройти первый живой `SRT-aware` routing-slice по `Park`.
