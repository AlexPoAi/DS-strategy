---
name: iterative engineering cycles
description: For exocortex engineering work, execute only in small truthful cycles: open a WP block, finish one bounded change, close with close-task.sh, commit/push, and record in the engineering Pack before continuing.
type: feedback
---

For exocortex engineering work, execute only in small truthful cycles: open a work-product block, complete one bounded change, close it with `close-task.sh`, commit/push, and record the result in the engineering Pack before starting the next block.

**Why:** The user wants every engineering step to be fixed in the system state immediately, with no long multi-step implementation passes and no unclosed context spanning several blocks.

**How to apply:** For WP-60 and similar engineering work, split the job into separate micro-cycles (diagnosis, verification matrix, first transfer step, checker alignment, runtime alignment, backup alignment). After each block, run the full close flow and only then continue.