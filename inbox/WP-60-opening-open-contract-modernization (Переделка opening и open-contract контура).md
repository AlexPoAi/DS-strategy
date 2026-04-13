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

## Фаза 2 — verification matrix и порядок переноса

### Verification matrix

| Шаг | Что меняем | Где меняем | Что проверяем сразу после шага | Класс риска |
|-----|------------|------------|--------------------------------|-------------|
| 1 | Канонический open protocol | `FMT-exocortex-template/memory/protocol-open.md` + связанные ссылки в `CLAUDE.md`/skills | `opening-contract-check.sh`, чтение маршрута `day-open`, отсутствие legacy/двойного маршрута | High |
| 2 | Skill / hook слой | `.claude/skills/day-open/SKILL.md`, `.claude/skills/run-protocol/SKILL.md`, `.claude/hooks/wp-gate-reminder.sh` | `run-protocol open`, корректный lazy-load, отсутствие ссылок на старый маршрут | Medium |
| 3 | Checker слой | `roles/synchronizer/scripts/opening-contract-check.sh`, при необходимости `health-check.sh` | красный/жёлтый/зелёный статус строится по новой модели без ложного legacy drift | High |
| 4 | Runtime слой | `roles/strategist/scripts/strategist.sh`, `roles/synchronizer/scripts/daily-report.sh` | `day-plan/session-prep/day-close` используют тот же canonical route и собирают корректные status artifacts | High |
| 5 | Backup / mirror слой | `DS-strategy/exocortex/*`, производные backup-копии | checker не падает на зеркалах, backup остаётся производным от canonical source-of-truth | Medium |

### Порядок переноса
1. **Canonical protocol first** — сначала определить и стабилизировать единый source-of-truth маршрута открытия.
2. **Skill / hook alignment** — затем выровнять все точки входа, чтобы они читали только canonical route.
3. **Checker alignment** — после этого обновить enforce-слой, чтобы он валидировал новую модель, а не legacy-следы.
4. **Runtime alignment** — затем подключить strategist / reports / session-open artifacts к уже стабилизированному контракту.
5. **Backup alignment last** — только в конце синхронизировать зеркала и backup-производные.

### Инварианты проверки
- Один canonical route для opening/day-open/session-prep.
- Skills, hooks, runtime и checker не должны ссылаться на разные protocol-open файлы.
- Personal truthful governance, WP Gate и close-flow сохраняются как обязательный слой.
- Backup/mirror не может быть самостоятельным source-of-truth.
- После каждого шага обязательна отдельная диагностика итога до следующего шага.

## Следующий шаг (следующий отдельный цикл)
- выполнить шаг 1: зафиксировать целевой canonical protocol route и список файлов, которые обязаны ссылаться только на него;
- после реализации отдельно прогнать checker/runtime-диагностику и только потом переходить к skill/hook alignment.

## Осталось
- реализовать шаг 1 как отдельный truthful цикл;
- после него отдельно проверить checker/runtime verdict;
- пройти шаги 2-5 отдельными закрываемыми блоками.
