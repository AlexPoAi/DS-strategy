# Протокол Close (Закрытие сессии)

> **Триггер:** «закрываю», «всё», «закрывай», или РП завершён.
> **«Закрывай» = push сразу без вопросов.**
> **Runtime contract:** закрытие provider-agnostic. Если текущий агент работает в `Codex`, протокол выполняется прямо там. `claude /login` нужен только для Claude-specific route и не должен блокировать close в `Codex`.
> **Анти-петля (блокирующее):** если получен ответ `Not logged in · Please run /login`, ЗАПРЕЩЕНО повторять тот же slash-route. Агент обязан сразу перейти на manual execution этого протокола по шагам в текущем рабочем агенте.

---

## Exit Protocol (ОБЯЗАТЕЛЬНО)

| # | Шаг | Что |
|---|-----|-----|
| 1 | **Артефакт** | Зафиксировать результат (коммит, файл) |
| 2 | **Статус** | Обновить трекер (WeekPlan, MEMORY.md) |
| 3 | **Уведомление** | Сообщить пользователю |

---

## Алгоритм Close

0. **Auth-independent entrypoint (обязательно):**
   - `bash ~/Github/FMT-exocortex-template/scripts/day-close-safe.sh`
   - Этот шаг не требует `claude /login` и не использует slash-route.
1. **Runtime preflight:** если `Claude` не залогинен, но текущий агент/`Codex` работает — продолжать в текущем агенте. Truthful blocker только если нет ни одного рабочего аутентифицированного runtime.

2. **Pull:** `cd DS-strategy && git pull --rebase`
3. **Knowledge Extraction:**
   - Собрать captures
   - Классифицировать → маршрутизировать
   - Показать Extraction Report → одобрение
   - Применить (accept → Pack/CLAUDE.md/memory)
4. **Обновить SESSION-CONTEXT.md:**
   - "Где мы находимся" → timestamp
   - "Что делаем" → статус РП
   - "Следующий шаг" → что делать дальше
   - Добавить: `- 🔒 [HH:MM] Сессия закрыта`
5. **Обновить MEMORY.md** (статус РП)
6. **Закоммитить** (с подтверждением)
7. **Обновить WeekPlan** (статусы РП)
8. **Backup:** `memory/ + CLAUDE.md → DS-strategy/exocortex/`
9. **WP Context File:**
   - in_progress + ≥2 сессий → обновить `inbox/WP-{N}-{slug}.md`
   - done → `mv inbox/WP-{N}-*.md → archive/wp-contexts/`

> Этот список шагов и есть канонический route. `/run-protocol *` и Claude-route не являются обязательными.

---

## Шаблон отчёта

```
**РП:** #N — [название]
**Статус:** done / in_progress

**Что сделано:**
- [артефакт 1]
- [артефакт 2]

**Что осталось:**
- [задача 1]

**Следующий шаг:** [что делать]
```

---

**Обновлено:** 2026-03-14
