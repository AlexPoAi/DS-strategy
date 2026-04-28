---
type: extraction-report
source: inbox-check
date: 2026-04-28
status: pending-review
processed: 1
remaining: 0
---

# Extraction Report (Inbox-Check)

**Дата:** 2026-04-28
**Источник:** DS-strategy/inbox/captures.md
**Обработано captures:** 1 из 1
**Осталось:** 0

---

## Кандидат #1

**Источник capture:** Extractor: session-watcher не должен хранить незамененные path placeholders [source: Agent 2026-04-28]
**Сырой текст:** «Сбой: source-скрипт session-watcher.sh содержал {{WORKSPACE_DIR}} и {{HOME_DIR}}, поэтому launchd запускал корректный plist, но сам watcher пытался создавать директории с буквальными шаблонами и писал ошибки Read-only file system. Паттерн фикса: runtime-скрипты должны сами резолвить workspace через resolve-workspace.sh, а prompt runner должен заменять и WORKSPACE_DIR, и HOME_DIR.»
**Классификация:** fm

**Outcome:** backlog_task

**Куда направить:**
- **Репо/контур:** DS-strategy
- **Файл:** DS-strategy/inbox/INBOX-TASKS.md
- **Действие:** создать backlog task

**Совместимость:**
- **Результат:** уточняет
- **Проверено:** FMT-exocortex-template/roles/extractor/scripts/session-watcher.sh; FMT-exocortex-template/roles/synchronizer/scripts/resolve-workspace.sh; DS-strategy/inbox/INBOX-TASKS.md; DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.031-agent-target-capability-implementation (Доведение агентов до целевой рабочей модели).md

**Готовый текст (ready-to-commit):**

~~~markdown
- [pending] 2026-04-28: Формализовать runtime contract Extractor против path-placeholder drift
  - Контекст: extracted from inbox-check 2026-04-28, кандидат #1
  - Источник: Extractor: session-watcher не должен хранить незамененные path placeholders [source: Agent 2026-04-28]
  - Outcome: backlog_task
  - Почему не Pack: это runtime/implementation hardening конкретного Extractor-стека и launchd-сценария, а не переносимое Pack-knowledge
  - Следующий шаг: зафиксировать инцидент, проверить extractor runtime scripts и prompt runners на self-resolution `WORKSPACE_DIR`/`HOME_DIR`, и добавить guard против повторного placeholder drift
  - Приоритет: medium
  - Бюджет: 30-60 мин
~~~

**Вердикт:** backlog_task
**Обоснование:** Capture фиксирует реальный runtime-инцидент и полезный паттерн исправления, но в текущей routing-конфигурации это не Pack-knowledge, а implementation hardening. Кодовый симптом уже устранён в `session-watcher.sh`, поэтому правильный route сейчас — отдельная backlog-задача на formalization и анти-рецидивную проверку.

---

## Сводка

| Метрика | Значение |
|---------|----------|
| Captures обработано | 1 |
| Всего кандидатов | 1 |
| Pack candidate | 0 |
| Backlog task | 1 |
| Recovery item | 0 |
| Rejected | 0 |
| Deferred | 0 |
| Осталось в inbox | 0 |
