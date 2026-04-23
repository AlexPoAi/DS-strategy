---
type: work-plan
wp_id: 112
title: Стратегия Gmail между alexpoaiagent и ООО Терра
created: 2026-04-23
status: done
owner: Environment Engineer
support:
  - Strategist
domain: exocortex-engineering
mode: gmail-account-strategy
---

# WP-112 — Стратегия Gmail между alexpoaiagent и ООО Терра

## Зачем открыт

После фиксации канонической модели:

- `Google Drive` → `alexpoaiagent@gmail.com`
- `Google Calendar` → `alexpoaiagent@gmail.com`
- `Park external mail` → `oooterrasimf@gmail.com`

нужно отдельно проверить и formalize работу с `Gmail`.

Главный вопрос:

- можно ли держать рабочий `Gmail` контур так, чтобы агент надёжно работал
  и с `alexpoaiagent@gmail.com`, и с `oooterrasimf@gmail.com`,
  не создавая риска отправки письма не с того ящика.

## Граница slice

Внутри этого WP:

1. Проверить, какой `Gmail` контур сейчас реально активен.
2. Проверить, можно ли безопасно использовать multi-account модель.
3. Если нужно, провести тест:
   - отправить письмо с `oooterrasimf@gmail.com`
   - на `alexpoaiagent@gmail.com`
4. Зафиксировать truthful operating rule для агентов.

Вне этого WP:

- не меняем `Google Drive` контракт;
- не меняем `Google Calendar` контракт;
- не трогаем Park-доменные документы, кроме случаев, когда нужен
  factual след по тестовой почте.

## Acceptance

Slice считается успешным, если:

1. truthful-вердикт по `Gmail` стратегии зафиксирован;
2. есть проверенный рабочий сценарий как минимум для Park external mail;
3. rule для агентов обновлён так, чтобы исключить скрытый account drift.

## Verified result

Подтверждено live-проверкой:

- активный `Gmail` connector работает от `oooterrasimf@gmail.com`;
- тестовое письмо успешно отправлено:
  - sender: `oooterrasimf@gmail.com`
  - recipient: `alexpoaiagent@gmail.com`
  - Gmail message id: `19dba30deb894662`

## Truthful verdict

Для текущей экзосистемы рабочее правило такое:

- `Drive + Calendar` держим канонически на `alexpoaiagent@gmail.com`;
- `Gmail` для внешней Park/ТЕРРА переписки держим на `oooterrasimf@gmail.com`;
- multi-account auto-switch для `Gmail` не считаем подтверждённой возможностью;
- если когда-то понадобится исходящий `Gmail` именно с `alexpoaiagent@gmail.com`,
  это должен быть отдельный bounded slice с отдельной проверкой.

## Truthful стартовый статус

`WP-112` открыт после закрытия `WP-111`.

На входе уже известно:

- `Google Drive` и `Google Calendar` закреплены за `alexpoaiagent@gmail.com`;
- `Gmail` по Park сейчас работает от `oooterrasimf@gmail.com`;
- auto-switch между несколькими `Gmail` контурами пока не подтверждён.
