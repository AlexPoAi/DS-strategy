---
name: DS-finance-private — только локально
description: Финансовые данные VK Coffee хранятся только локально, git push запрещён
type: feedback
valid_from: 2026-04-29
originSessionId: fe20340e-d040-4df3-88e0-89831654d8e2
---
DS-finance-private = локальный приватный контур. Никогда не пушить в git.

**Why:** финансовые данные (выручка, COGS, P&L, активы, долги) — конфиденциальная информация бизнеса.

**How to apply:** любые изменения в DS-finance-private — только Write/Edit локально. Команды git push, git commit для этого репо не выполнять. Если пользователь говорит «сохраняй» — это значит сохранить файл локально, не в git.
