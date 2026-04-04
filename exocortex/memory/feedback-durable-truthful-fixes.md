---
name: Durable truthful fixes
description: User prefers one-time durable architectural fixes with truthful contracts, not local patches or temporary workarounds.
type: feedback
---
Предпочитать durable и truthful исправления, которые закрывают проблему один раз без повторных переделок, даже если нужно выровнять документацию, runtime и валидацию вместе.

**Why:** Пользователь явно подтвердил, что лучший результат — убрать ложные ссылки, довести контракт до truthful состояния и после этого успешно закрыть день без расхождений.

**How to apply:** При архитектурном drift, ложных путях или несовпадении docs/runtime не ограничиваться локальным фиксиком; сначала выровнять source-of-truth, validator, navigation и runtime contract, затем закрывать WP отдельным truthful циклом.