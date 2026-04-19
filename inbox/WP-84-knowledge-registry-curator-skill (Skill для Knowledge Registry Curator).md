---
id: WP-84
title: "Knowledge Registry Curator skill"
status: done
priority: high
owner: "Strategist + Code Engineer"
created: 2026-04-19
updated: 2026-04-19
---

# Контекст

После создания агента `Knowledge Registry Curator` следующий обязательный шаг — дать ему повторяемый skill-протокол.

Отдельный `PACK-agent-skills` ещё не материализован (`WP-82`), поэтому текущий skill создаётся как самостоятельный агентский артефакт с явной пометкой на будущую миграцию в целевой PACK.

# Цель

Создать первый рабочий skill `notes-registry-and-domain-mapping` для `Knowledge Registry Curator`, чтобы агент мог стабильно:
- вести `Notes Registry`;
- строить `Domain Map`;
- находить `orphan notes` и `missing domains`;
- готовить handoff в `Strategist`.

# Scope

1. Описать skill как отдельный агентский артефакт.
2. Зафиксировать обязательные поля реестра.
3. Зафиксировать режимы работы skill.
4. Связать карточку агента с skill-файлом.
5. Отразить появление skill в инженерном контуре как capability-изменение.

# Acceptance

1. У `Knowledge Registry Curator` есть отдельный skill-файл.
2. В skill описаны входы, выходы, режимы работы и quality gates.
3. Карточка агента ссылается на skill.
4. Зафиксировано, что skill позже мигрирует в `PACK-agent-skills`.

# Результат

Создан skill:
- `agency/skills/knowledge-registry-curator/notes-registry-and-domain-mapping.md`

Skill фиксирует 4 режима:
- `ingest week notes`
- `classify backlog slice`
- `find missing domains`
- `prepare strategist handoff`

# Следующий шаг

1. При желании открыть первый live-slice на реальное заполнение `Notes Registry`.
2. Позже мигрировать skill в `PACK-agent-skills` в рамках `WP-82`.
