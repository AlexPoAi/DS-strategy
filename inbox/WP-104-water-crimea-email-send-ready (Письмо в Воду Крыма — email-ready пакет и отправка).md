---
id: WP-104
title: "Письмо в Воду Крыма — email-ready пакет и отправка"
status: done
priority: high
owner: "Park Permitting & Infrastructure Coordinator"
created: 2026-04-22
updated: 2026-04-22
---

# Контекст

`Gmail` коннектор на `oooterrasimf@gmail.com` авторизован и письмо уже ушло.

По трубе был собран draft письма в `Воду Крыма`, а в этом slice выполнен send-step.

# Цель

Довести письмо в `Воду Крыма` до `send-ready` и выполнить отправку с `oooterrasimf@gmail.com`.

# Scope

1. Подтянуть канонические реквизиты `Терра`.
2. Перевести `PARK.COMM.026` из общего draft в `email-ready`.
3. Отправить письмо через Gmail connector.
4. Зафиксировать follow-up как отдельный следующий tracking-slice.

# Acceptance

1. Письмо использует канонические реквизиты `Терра`.
2. Письмо реально отправлено с `oooterrasimf@gmail.com`.
3. Поставлен follow-up reminder на проверку ответа.

# Что получилось по факту

- письмо отправлено с `oooterrasimf@gmail.com`
- `to`: `bah.pto@voda.crimea.ru`
- `cc`: `bah.abon@voda.crimea.ru`
- Gmail message id: `19db4d7893287d2f`
- follow-up напоминание поставлено на `2026-04-24`

# Truthful verdict

Slice закрыт как send-step.

Что сознательно не было доведено в этом WP:

- пост-send фиксация в Pack как `sent`
- входящий номер от `Воды Крыма`
- отдельный tracking-layer после отправки

# Следующий шаг

Открыть отдельный bounded tracking-slice:

1. перевести Park communication в `sent`;
2. зафиксировать дату, message id и follow-up;
3. после ответа добавить входящий номер и новый статус.
