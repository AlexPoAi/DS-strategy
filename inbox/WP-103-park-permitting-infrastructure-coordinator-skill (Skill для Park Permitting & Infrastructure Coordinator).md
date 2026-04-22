---
id: WP-103
title: "Skill для Park Permitting & Infrastructure Coordinator"
status: done
priority: high
owner: "Strategist + Park domain"
created: 2026-04-22
updated: 2026-04-22
---

# Контекст

По Парку открылся повторяемый класс задач, который нельзя оставлять на уровне разовых черновиков:
- официальные запросы;
- реквизиты отправителя;
- сохранение документов в Google Drive;
- фиксация ссылок и статусов в Pack;
- tracking отправки, входящего номера и follow-up.

Для этого нужен не временный ad-hoc исполнитель, а отдельный предметный агент с повторяемым skill-протоколом.

# Цель

Создать и зафиксировать исполнителя `Park Permitting & Infrastructure Coordinator` и дать ему первый рабочий skill `park-official-document-cycle`.

# Scope

1. Создать карточку агента в `DS-agent-workspace`.
2. Создать живой skill в `DS-agent-workspace/agency/skills/`.
3. Зафиксировать каноническую версию skill в `PACK-agent-skills`.
4. Связать skill с текущим Park-контуром по трубе.
5. Явно зафиксировать, что именно этот агент является primary executor для официальных документных циклов Парка.

# Acceptance

1. У агента есть отдельная карточка.
2. У агента есть skill-файл с входами, выходами, шагами и quality gates.
3. Skill сохранён в доменной области `PACK-agent-skills`.
4. В текущем Park work-product указаны primary agent и skill.

# Результат

Создан новый агент:
- `DS-agent-workspace/agency/agents/park-permitting-infrastructure-coordinator.md`

Создан живой skill:
- `DS-agent-workspace/agency/skills/park-permitting-infrastructure-coordinator/park-official-document-cycle.md`

Создана каноническая Pack-версия:
- `DS-strategy/PACK-agent-skills/03-skills/AGENT.SKILL.002-park-official-document-cycle (Скилл официального документного цикла Park).md`

Skill покрывает:
- подтяжку реквизитов `Терра`;
- заполнение clean-версии письма;
- сохранение в Google Drive;
- фиксацию ссылки в Pack;
- статусный переход `draft -> ready -> sent -> waiting -> answered`;
- follow-up по входящему номеру и сроку ответа.

# Следующий шаг

Открыть следующий bounded slice и уже применить skill на двух реальных письмах по канализационной трубе:
1. подставить реквизиты;
2. сохранить clean-docs в Google Drive;
3. зафиксировать ссылки и статусы;
4. подготовить отправку.
