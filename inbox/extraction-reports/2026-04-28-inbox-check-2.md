---
type: extraction-report
source: inbox-check
date: 2026-04-28
status: pending-review
processed: 3
remaining: 0
---

# Extraction Report (Inbox-Check)

**Дата:** 2026-04-28
**Источник:** DS-strategy/inbox/captures.md
**Обработано captures:** 3 из 3
**Осталось:** 0

---

## Кандидат #1

**Источник capture:** Runtime Codex-first must be explicit [source: Codex 2026-04-28]
**Сырой текст:** «После обновления runtime нельзя полагаться только на auto-selection: Codex должен быть явно задан как primary provider в runner defaults и runtime policy. Claude допускается только как fallback/ручной override. Проверка: runtime-arbiter должен возвращать provider=codex reason=policy_codex, а generated .iwe-runtime scripts должны иметь AI_CLI_PROVIDER_PRIMARY default codex, не auto.»
**Классификация:** rule

**Outcome:** backlog_task

**Куда направить:**
- **Репо/контур:** DS-strategy
- **Файл:** DS-strategy/inbox/INBOX-TASKS.md
- **Действие:** создать backlog task

**Совместимость:**
- **Результат:** уточняет
- **Проверено:** FMT-exocortex-template/roles/extractor/scripts/extractor.sh; FMT-exocortex-template/roles/strategist/scripts/strategist.sh; FMT-exocortex-template/roles/synchronizer/scripts/runtime-arbiter.sh; DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.027-runtime-arbiter-codex-cloud-parity (Арбитр доступности Codex и Cloud provider plane).md; DS-strategy/exocortex/project-brain.md

**Готовый текст (ready-to-commit):**

~~~markdown
- [pending] 2026-04-28: Формализовать explicit Codex-primary runtime policy после update drift
  - Контекст: extracted from inbox-check 2026-04-28, кандидат #1
  - Источник: Runtime Codex-first must be explicit [source: Codex 2026-04-28]
  - Outcome: backlog_task
  - Почему не Pack: это implementation-policy для текущего agent runtime и generated `.iwe-runtime`, а не переносимое доменное знание
  - Следующий шаг: зафиксировать policy `Codex primary / Claude fallback`, сверить runtime-arbiter verdict `provider=codex reason=policy_codex` и проверить что generated runner defaults больше не откатываются в `auto`
  - Приоритет: high
  - Бюджет: 30-60 мин
~~~

**Вердикт:** backlog_task
**Обоснование:** Capture описывает не универсальное Pack-правило, а конкретный runtime-policy contract для текущего экзокортекс-стека после update drift. Правильный route сейчас: backlog formalization и anti-regression check, без записи в Pack.

---

## Кандидат #2

**Источник capture:** Update must verify settings hook targets [source: Codex 2026-04-28]
**Сырой текст:** «После обновления до v0.29.11 workspace .claude/settings.json ссылался на .claude/hooks/precompact-checkpoint.sh, но сам hook не был скопирован в workspace, потому что update.sh пропагировал только new/updated files. Проверка кастомных настроек должна включать: распарсить settings.json hooks[].command и проверить, что каждый target существует и executable.»
**Классификация:** fm

**Outcome:** rejected

**Куда направить:**
- **Репо/контур:** archive
- **Файл:** DS-strategy/inbox/archive/rejected/CO.reject.008-settings-hook-targets-duplicate.md
- **Действие:** архивировать как duplicate reject

**Совместимость:**
- **Результат:** дубликат
- **Проверено:** FMT-exocortex-template/CHANGELOG.md; FMT-exocortex-template/update-manifest.json; DS-strategy/inbox/WP-22-exocortex-runtime-stabilization (Стабилизация рабочей среды экзокортекса).md

**Готовый текст (ready-to-commit):**

~~~markdown
---
id: CO.reject.008
type: capture
status: rejected
reason: duplicate of already documented hook-target drift and follow-up validation gap
date: 2026-04-28
source: Update must verify settings hook targets [source: Codex 2026-04-28]
tags:
  - capture
  - rejected
  - duplicate
  - runtime
  - hooks
  - update
---

# Rejected Capture

Capture повторяет уже зафиксированный drift-класс: `settings.json` ссылается на hook target, которого нет в workspace, и нужен cross-check `hooks[].command -> file exists + executable`.
~~~

**Вердикт:** rejected
**Обоснование:** Этот failure mode уже документирован в `FMT-exocortex-template/CHANGELOG.md` вместе с systemic followup на cross-reference validation. Новый capture не добавляет нового маршрута, а повторяет уже открытое знание.

---

## Кандидат #3

**Источник capture:** Runtime update to Tseren v0.29.11 [source: Codex 2026-04-28]
**Сырой текст:** «После обновления до Tseren v0.29.11 manifest удалил prompt-файлы Strategist, но runtime всё ещё ссылался на них; также runner'ы должны брать prompts из FMT и резолвить workspace через файл, а не executable-флаг. Исправление: восстановлен рабочий provider fallback/status runtime, добавлен params.yaml, пересобран .iwe-runtime.»
**Классификация:** fm

**Outcome:** recovery_item

**Куда направить:**
- **Репо/контур:** DS-strategy
- **Файл:** DS-strategy/current/ENGINEERING-CHRONOLOGY.md
- **Действие:** добавить recovery note

**Совместимость:**
- **Результат:** совместим
- **Проверено:** DS-strategy/current/ENGINEERING-CHRONOLOGY.md; DS-strategy/current/SESSION-CONTEXT.md; FMT-exocortex-template/CLAUDE.md

**Готовый текст (ready-to-commit):**

~~~markdown
39. 2026-04-28: после update до `Tseren v0.29.11` выявлен runtime drift — manifest убрал prompt-файлы `Strategist`, а runtime ещё ссылался на них; дополнительно выровнены prompt-routing через `FMT`, workspace-resolution через файл, восстановлен provider fallback/status runtime, добавлен `params.yaml` и пересобран `.iwe-runtime`.
~~~

**Вердикт:** recovery_item
**Обоснование:** Capture фиксирует уже выполненный incident-recovery slice и полезен как хронологическое evidence, но не как новый Pack-кандидат и не как отдельная backlog-задача. Правильный route — recovery note в инженерную хронологию.

---

## Сводка

| Метрика | Значение |
|---------|----------|
| Captures обработано | 3 |
| Всего кандидатов | 3 |
| Pack candidate | 0 |
| Backlog task | 1 |
| Recovery item | 1 |
| Rejected | 1 |
| Deferred | 0 |
| Осталось в inbox | 0 |
