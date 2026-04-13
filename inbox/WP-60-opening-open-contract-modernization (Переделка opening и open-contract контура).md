---
wp: 60
title: СИСТЕМА: Переделка opening/open-contract контура — перенос modern upstream с truthful governance
status: pending
created: 2026-04-11
source: пользователь инициировал отдельный инженерный WP после диагностики strategist/opening contract
verification_class: closed-loop
---

# WP-60: СИСТЕМА: Переделка opening/open-contract контура — перенос modern upstream с truthful governance

## Описание
Нужно не локально чинить opening/open-contract контур, а аккуратно переделать его под более современную модель upstream Церена с сохранением personal truthful governance, WP discipline и ритуалов экзокортекса.

## Артефакт
Инженерный пакет модернизации opening/open-contract контура:
- карта затронутых агентов, скриптов, skills и проверок;
- gap-анализ «наш эталон → upstream Церена → текущее состояние»;
- пошаговый план переноса;
- реализация по шагам с verification после каждого шага.

## Контекст
Связанные контуры:
- `FMT-exocortex-template/memory/protocol-open.md`
- `FMT-exocortex-template/roles/synchronizer/scripts/opening-contract-check.sh`
- `FMT-exocortex-template/roles/synchronizer/scripts/health-check.sh`
- `FMT-exocortex-template/.claude/skills/day-open/SKILL.md`
- `FMT-exocortex-template/.claude/skills/run-protocol/SKILL.md`
- `DS-strategy/exocortex/`
- `DS-agent-workspace/agency/agents/strategist.md`
- `DS-strategy/PACK-exocortex-engineering/01-concepts/ENG.CONCEPT.001-repair-protocol (Протокол починки).md`
- `DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.036-tseren-vs-target-model-gap-analysis (Сверка реализации Церена с нашим эталоном).md`

## Критерий готовности
- [ ] Определён полный список затронутых агентов и runtime-checks
- [ ] Зафиксирован эталон: что берём у Церена, что сохраняем своим
- [ ] Согласован безопасный порядок переноса
- [ ] Каждый шаг переноса проверяется отдельно и не ломает strategist / scheduler / extractor / open-close loop
- [ ] opening/open-contract контур приведён к новой целевой модели без legacy-дрейфа

## Бюджет
~3h

## Фаза 1 — карта зоны удара

### Затронутые агенты и контуры
- **Strategist** — runtime маршрут `day-plan/session-prep`, open-route и status artifacts завязаны на `memory/protocol-open.md` и `strategist.sh`.
- **Synchronizer / Health Check** — enforce-слой через `opening-contract-check.sh` и `health-check.sh`.
- **Day Open / Run Protocol** — skills жёстко ссылаются на `memory/protocol-open.md`.
- **Agency Hiring contour** — ритуал найма встроен в open protocol и strategist agent card.
- **Backup / mirror контур** — `DS-strategy/exocortex/*` содержит копии/backup слоя, которые checker тоже валидирует.

### Критические файлы
- `FMT-exocortex-template/memory/protocol-open.md`
- `FMT-exocortex-template/CLAUDE.md`
- `FMT-exocortex-template/.claude/skills/day-open/SKILL.md`
- `FMT-exocortex-template/.claude/skills/run-protocol/SKILL.md`
- `FMT-exocortex-template/roles/synchronizer/scripts/opening-contract-check.sh`
- `FMT-exocortex-template/roles/synchronizer/scripts/health-check.sh`
- `FMT-exocortex-template/roles/strategist/scripts/strategist.sh`
- `DS-strategy/exocortex/CLAUDE.md`
- `DS-strategy/exocortex/memory/protocol-open.md`
- `DS-agent-workspace/agency/agents/strategist.md`

### Формула переноса
1. **Наш эталон** — ENG.CONCEPT.001 + ENG.WP.013 + ENG.WP.036
2. **Upstream Церена** — slim `CLAUDE.md`, `memory/protocol-open.md`, `day-open` skill
3. **Наше текущее сос��ояние** — personal truthful governance + backup/mirror + checker/runtime слой

### Что брать у Церена
- slim-core decomposition `CLAUDE.md`
- более тонкий `protocol-open` как архитектурный паттерн
- `day-open` как lazy-loaded skill
- enforcement-style checks

### Что сохраняем своим
- truthful governance
- WP Gate и ритуал согласования
- close-flow / `close-task.sh`
- русский opening-screen
- personal mirrors/backup только как производные, не как отдельный source-of-truth

### Что нельзя делать
- wholesale replace personal контура upstream-файлами
- локальные фиксы без полного цикла `Церен -> эталон -> текущее -> перенос`
- менять protocol-open без синхронной проверки skills/checkers/runtime/backups

## Следующий шаг (Phase 2)
- построить verification matrix по шагам переноса;
- определить безопасный порядок модернизации: canonical protocol -> skills/hooks -> checker -> runtime -> backup mirrors;
- после этого открыть следующий инженерный цикл и реализовывать уже по шагам.

## Осталось
- собрать verification matrix;
- утвердить порядок переноса;
- выполнить перенос отдельными truthful циклами.
