---
name: Напоминания → INBOX-TASKS
description: Все напоминания которые просит пользователь пишутся в INBOX-TASKS (не только cron)
type: feedback
---

Когда пользователь просит что-то напомнить — всегда дублировать в `DS-strategy/inbox/INBOX-TASKS.md`.

**Why:** Cron напоминания session-only и умирают при закрытии Claude. INBOX-TASKS — надёжное хранилище.

**How to apply:** Cron ставить если сессия активна + всегда писать в INBOX-TASKS. Формат: `[pending] YYYY-MM-DD: [НАПОМИНАНИЕ] текст + контекст`.

**Будущее:** Планируется Pack «Личный помощник» с интеграцией Google Calendar (IntegrationGate перед реализацией). До тех пор — только INBOX-TASKS.
