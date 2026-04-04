---
name: natural language session start triggers
description: User wants ordinary Russian phrases for starting a work session to be understood directly, without slash commands.
type: feedback
---
Interpret ordinary natural-language phrases about starting the workday/session as intent to run the exocortex work-session opening flow, not as a request for a slash command.

**Why:** The user does not want a separate slash command or special syntax; they want to just type a normal phrase and have Claude understand it in the Github workspace context.

**How to apply:** When the user says things like "давай начинаем рабочую сессию", "открывай день", "начинаем работу", or similar variants, treat them as the same trigger and start the work-session check/opening flow directly.