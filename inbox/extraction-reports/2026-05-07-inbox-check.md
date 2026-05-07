---
type: extraction-report
source: inbox-check
date: 2026-05-07
status: pending-review
processed: 1
remaining: 0
---

# Extraction Report (Inbox-Check)

**Дата:** 2026-05-07
**Источник:** DS-strategy/inbox/captures.md
**Обработано captures:** 1 из 1
**Осталось:** 0

---

## Кандидат #1

**Источник capture:** Проверить скил fpf \fpf [source: Telegram 2026-05-06]
**Сырой текст:** «Проверить скил fpf \fpf»
**Классификация:** wp

**Куда записать:**
- **Репо:** n/a
- **Файл:** n/a
- **Действие:** не создавать отдельный артефакт

**Совместимость:**
- **Результат:** governance-контент / already materialized
- **Проверено:** FMT-exocortex-template/roles/extractor/config/routing.md; FMT-exocortex-template/roles/extractor/config/feedback-log.md; PACK-iwe-culture/00-pack-manifest.md; .claude/skills/fpf/SKILL.md; FMT-exocortex-template/.claude/skills/fpf/SKILL.md

**Готовый текст (ready-to-commit):**

~~~markdown
N/A — capture не задаёт новый Pack candidate. Это короткий governance/runtime reminder проверить уже существующий `fpf` skill route, который materialized в `.claude/skills/fpf/SKILL.md` и template-источнике `FMT-exocortex-template/.claude/skills/fpf/SKILL.md`.
~~~

**Вердикт:** reject
**Обоснование:** Capture не описывает доменную сущность, метод, различение или bounded work product. Он указывает на операционную проверку существующего skill-а, а routing прямо запрещает экстрагировать governance-контент в Pack. Дополнительно bounded context `PACK-iwe-culture` покрывает культуру работы, но не runtime-reminders про проверку конкретного slash-skill.

---

## Сводка

| Метрика | Значение |
|---------|----------|
| Captures обработано | 1 |
| Всего кандидатов | 1 |
| Accept | 0 |
| Reject | 1 |
| Defer | 0 |
| Осталось в inbox | 0 |
