---
type: engineering-work-product
wp_id: ENG.WP.019
title: История надёжности и сбоев Strategist
date: 2026-04-05
status: active
priority: high
linked_inbox: ENGINEERING
author: Environment Engineer (Codex)
---

# ENG.WP.019 — История надёжности и сбоев Strategist

## Зачем нужен этот WP

`strategist` стал самым проблемным локальным агентом экосистемы:

- он участвует в `day-open`, `day-close`, `week-review`, `note-review`;
- он сильнее всего завязан на локальный `claude` CLI;
- его сбои напрямую ломают truthful opening/closing route.

До этого история ошибок была размазана по `INBOX`, `SESSION-CONTEXT`, failure-modes и точечным WP. Этот документ собирает её в один reliability dossier.

## Канонический scope

Под `strategist` здесь понимаются:

- [strategist.sh](/Users/alexander/Github/FMT-exocortex-template/roles/strategist/scripts/strategist.sh)
- сценарии:
  - `morning`
  - `day-plan`
  - `session-prep`
  - `note-review`
  - `week-review`
  - `day-close`
- зависимые контуры:
  - `notify.sh`
  - `protocol-open.md`
  - `protocol-close.md`
  - `scheduler`
  - `health-check`
  - `AGENTS-STATUS`
  - `SESSION-OPEN`
  - `SESSION-CONTEXT`

## Повторяющиеся классы сбоев

### 1. Path drift / repo drift

Симптомы:

- `notify.sh` вызывался по старому пути из эпохи `IWE`
- `day-close` смотрел в устаревший prompt path

Артефакты:

- [ENG.WP.004-notify-path-drift-2026-03-29 (Починка notify.sh после дрейфа путей IWE→Github).md](/Users/alexander/Github/DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.004-notify-path-drift-2026-03-29%20%28%D0%9F%D0%BE%D1%87%D0%B8%D0%BD%D0%BA%D0%B0%20notify.sh%20%D0%BF%D0%BE%D1%81%D0%BB%D0%B5%20%D0%B4%D1%80%D0%B5%D0%B9%D1%84%D0%B0%20%D0%BF%D1%83%D1%82%D0%B5%D0%B9%20IWE%E2%86%92Github%29.md)
- [ENG.WP.010-day-close-entrypoint-drift (Устранение дрейфа entrypoint для day-close у Strategist).md](/Users/alexander/Github/DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.010-day-close-entrypoint-drift%20%28%D0%A3%D1%81%D1%82%D1%80%D0%B0%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5%20%D0%B4%D1%80%D0%B5%D0%B9%D1%84%D0%B0%20entrypoint%20%D0%B4%D0%BB%D1%8F%20day-close%20%D1%83%20Strategist%29.md)

Текущий статус:

- основной drift снят;
- риск повторения остаётся при дальнейших migration/refactor изменениях.

### 2. `day-close` зависание и lock anomalies

Симптомы:

- `strategist.sh day-close` стартует, но не даёт финальный результат;
- lock мог существовать в форме директории, а не обычного lock-файла;
- день приходилось закрывать обходным безопасным маршрутом.

Артефакты:

- [ENG.FM.001-typical-incidents (Типовые инциденты экзокортекса).md](/Users/alexander/Github/DS-strategy/PACK-exocortex-engineering/05-failure-modes/ENG.FM.001-typical-incidents%20%28%D0%A2%D0%B8%D0%BF%D0%BE%D0%B2%D1%8B%D0%B5%20%D0%B8%D0%BD%D1%86%D0%B8%D0%B4%D0%B5%D0%BD%D1%82%D1%8B%20%D1%8D%D0%BA%D0%B7%D0%BE%D0%BA%D0%BE%D1%80%D1%82%D0%B5%D0%BA%D1%81%D0%B0%29.md)
- [INBOX-TASKS.md](/Users/alexander/Github/DS-strategy/inbox/INBOX-TASKS.md)
  Контур: pending задача от `2026-03-22` про зависание `day-close`

Текущий статус:

- runner доведён до рабочей точки входа;
- но сам `day-close` остаётся чувствителен к auth/runtime и не является полностью автономным shell-close.

### 3. Claude auth / helper / model access failures

Симптомы:

- `401`
- `Auth failed`
- helper/env/custom API failures
- сценарии падают без полезного пользовательского алерта

Артефакты:

- [ENG.WP.006](#) auth failure detector в `strategist.sh` + chat-id
- [INBOX-TASKS.md](/Users/alexander/Github/DS-strategy/inbox/INBOX-TASKS.md)
  Контур: pending задачи про auth failed без alert и extractor/strategist failures
- [SESSION-CONTEXT.md](/Users/alexander/Github/DS-strategy/current/SESSION-CONTEXT.md)
  Контур: 2026-03-22 и 2026-04-04 сессии стабилизации auth

Текущий статус:

- детектор auth failures уже усиливался;
- но сам `strategist` по-прежнему desktop-bound и зависит от живой локальной сессии `claude`.

### 4. Runtime / CLI drift

Симптомы:

- невалидный `CLAUDE_PATH`
- проблемы с timeout wrapper
- жёсткая модель в runner
- чувствительность к `bash 3.2` / shell-compatible runtime

Артефакты:

- [SESSION-CONTEXT.md](/Users/alexander/Github/DS-strategy/current/SESSION-CONTEXT.md)
  Контур: 2026-03-25, 2026-04-05
- [ENG.WP.010-day-close-entrypoint-drift (Устранение дрейфа entrypoint для day-close у Strategist).md](/Users/alexander/Github/DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.010-day-close-entrypoint-drift%20%28%D0%A3%D1%81%D1%82%D1%80%D0%B0%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5%20%D0%B4%D1%80%D0%B5%D0%B9%D1%84%D0%B0%20entrypoint%20%D0%B4%D0%BB%D1%8F%20day-close%20%D1%83%20Strategist%29.md)

Текущий статус:

- основные жёсткие блокеры снимались точечно;
- единый remote-capable runtime для `strategist` пока отсутствует.

### 5. Truthful semantics mismatch

Симптомы:

- `Strategist` мог отчитаться не тем классом статуса;
- open/close route расходились между агентами;
- `day-close` summary и operational result расходились.

Артефакты:

- [ENG.WP.011-opening-and-day-close-route-alignment (Выравнивание opening-state и day-close маршрута экзокортекса).md](/Users/alexander/Github/DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.011-opening-and-day-close-route-alignment%20%28%D0%92%D1%8B%D1%80%D0%B0%D0%B2%D0%BD%D0%B8%D0%B2%D0%B0%D0%BD%D0%B8%D0%B5%20opening-state%20%D0%B8%20day-close%20%D0%BC%D0%B0%D1%80%D1%88%D1%80%D1%83%D1%82%D0%B0%20%D1%8D%D0%BA%D0%B7%D0%BE%D0%BA%D0%BE%D1%80%D1%82%D0%B5%D0%BA%D1%81%D0%B0%29.md)
- [ENG.WP.012-canonical-day-close-summary (Канонический day-close summary и удаление token-report из закрытия дня).md](/Users/alexander/Github/DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.012-canonical-day-close-summary%20%28%D0%9A%D0%B0%D0%BD%D0%BE%D0%BD%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%B8%D0%B9%20day-close%20summary%20%D0%B8%20%D1%83%D0%B4%D0%B0%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5%20token-report%20%D0%B8%D0%B7%20%D0%B7%D0%B0%D0%BA%D1%80%D1%8B%D1%82%D0%B8%D1%8F%20%D0%B4%D0%BD%D1%8F%29.md)
- [ENG.WP.013-unified-open-close-route (Единый маршрут открытия и закрытия сессии для всех агентов).md](/Users/alexander/Github/DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.013-unified-open-close-route%20%28%D0%95%D0%B4%D0%B8%D0%BD%D1%8B%D0%B9%20%D0%BC%D0%B0%D1%80%D1%88%D1%80%D1%83%D1%82%20%D0%BE%D1%82%D0%BA%D1%80%D1%8B%D1%82%D0%B8%D1%8F%20%D0%B8%20%D0%B7%D0%B0%D0%BA%D1%80%D1%8B%D1%82%D0%B8%D1%8F%20%D1%81%D0%B5%D1%81%D1%81%D0%B8%D0%B8%20%D0%B4%D0%BB%D1%8F%20%D0%B2%D1%81%D0%B5%D1%85%20%D0%B0%D0%B3%D0%B5%D0%BD%D1%82%D0%BE%D0%B2%29.md)

Текущий статус:

- маршрут выровнен намного лучше;
- но реальная надёжность `strategist` всё ещё ограничена локальным runtime и auth.

## Что уже починено

1. Сняты старые path drift проблемы
2. `day-close` runner переведён на актуальный `protocol-close.md`
3. Убран блокер `CLAUDE_PATH`
4. Усилены Telegram notification paths вокруг `strategist`
5. Канонический open/close route и day-close summary выровнены между агентами

## Что остаётся системным риском

1. `strategist` остаётся `desktop-bound`
2. Локальный `claude` auth остаётся single point of failure
3. `week-review` и часть review-сценариев ещё имеют хвосты в inbox
4. `day-close` зависит не только от кода runner-а, но и от живой интерактивной модели исполнения
5. У `strategist` нет ещё собственного сводного health contract уровня `service maturity`

## Truthful verdict

`Strategist` сейчас уже не в состоянии “хаотично ломается без карты”.

Но и не в состоянии “production-stable agent”.

Правильный статус на сегодня:

- `functional but fragile`
- годится как local-primary deep-work agent;
- не годится как fully reliable always-on agent без отдельного redesign runtime/auth layer.

## Следующий инженерный шаг

Наиболее логичный следующий WP после этого dossier:

1. либо `strategist reliability hardening`
2. либо `remote-capable/openai-compatible runner contract for strategist`

До этого момента все новые инциденты по `strategist` стоит фиксировать с ссылкой на этот dossier.
