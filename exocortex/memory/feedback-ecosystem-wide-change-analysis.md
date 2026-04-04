---
name: Ecosystem-wide change analysis before fixes
description: User wants every fix treated as an ecosystem-level change, with upfront analysis of cross-system impact rather than session-local patching.
type: feedback
---
Любое изменение рассматривать не как локальный фикс на одну сессию, а как изменение экосистемы в целом; перед правкой обязательно анализировать сквозное влияние и риск поломки соседних контуров.

**Why:** Пользователь сталкивается с ситуацией, когда локально кажется, что всё закрыто, а утром ломается другой контур. Нужны не сессионные починки, а системные изменения без скрытых побочных эффектов.

**How to apply:** Перед предложением или внесением изменений сначала проверять влияние на status layer, artifacts, git-state, scheduler/strategist/extractor контуры и truthful completion contract. Не считать задачу решённой, если исправление не оценено на уровне всей экосистемы.
