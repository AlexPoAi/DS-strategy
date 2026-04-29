# Навигация по репозиториям (Слой 3)

> Claude читает этот файл при поиске конкретного файла/репо. Для поиска знаний → `mcp__claude_ai_knowledge-mcp__search`.

## Ключевые файлы

| Тема | Файл |
|------|------|
| Различения (жёсткие пары) | `memory/hard-distinctions.md` |
| FPF (навигация, принципы) | `memory/fpf-reference.md` |
| Правила по типам репо | `memory/repo-type-rules.md` |
| Чеклисты | `memory/checklists.md` |
| SOTA-практики (18 шт.) | `memory/sota-reference.md` |
| Протокол Open (WP Gate, Ритуал) | `memory/protocol-open.md` |
| Протокол Close (чеклист, шаблон) | `memory/protocol-close.md` |
| Нулевые принципы + иерархия | `ZP/README.md` |
| Кодирование сущностей | `SPF/spec/SPF.SPEC.001-entity-coding.md` |
| Масштабируемость Pack | `SPF/spec/SPF.SPEC.003-pack-scalability.md` |

## Репозитории

| Репо | Путь |
|------|------|
| LMS Aisystant (READ-ONLY) | `DS-IT-systems/aisystant/` |
| SystemsSchool_bot (READ-ONLY) | `DS-IT-systems/SystemsSchool_bot/` |
| Монорепо ИИ-систем (7 шт.) | `DS-IT-systems/DS-ai-systems/` |
| — Стратег (Grade 3) | `DS-IT-systems/DS-strategist/` |
| — Шаблонизатор (Grade 0) | `DS-IT-systems/DS-ai-systems/setup/` |
| — Наладчик (Grade 2) | `DS-IT-systems/DS-ai-systems/fixer/` |
| — Статистик (Grade 1) | `DS-IT-systems/DS-ai-systems/pulse/` |
| — Оценщик (Grade 2) | `DS-IT-systems/DS-ai-systems/evaluator/` |
| Личная онтология | `DS-strategy/ontology.md` |
| Программа обучения | `DS-principles-curriculum/` |

## Pack-репо

| Pack | Путь |
|------|------|
| PACK-education | Методика обучения |
| PACK-personal | Личностное развитие |

## Ключевые документы (Pack DP)

| Документ | Код |
|----------|-----|
| Тиры обслуживания | DP.ARCH.002 |
| Role-Centric Architecture | DP.D.033 |
| Runbook ошибок бота | DP.RUNBOOK.001 |

## MCP

| MCP | Путь |
|-----|------|
| knowledge-mcp (исходники) | `DS-MCP/knowledge-mcp/src/index.ts` |
| knowledge-mcp (ingest) | `DS-MCP/knowledge-mcp/scripts/ingest.ts` |
| guides-mcp (исходники) | `DS-MCP/guides-mcp/src/index.ts` |

## Стратегия

| Файл | Путь |
|------|------|
| Стратегия | `DS-strategy/docs/Strategy.md` |
| WeekPlan | `DS-strategy/current/` |

## WP Context Files

> Все context files: `DS-strategy/inbox/WP-{N}-{slug}.md`
> Архив: `DS-strategy/archive/wp-contexts/`

---

## Внешние ресурсы (Google Drive / Sheets)

**Маршрут доступа:** перед Drive/Calendar/Gmail действиями читать
`DS-strategy/PACK-agent-skills/03-skills/AGENT.SKILL.004-google-workspace-operating-contract (Скилл работы агентов с Google Workspace контурами).md`.
Claude и Codex идут одним Google Workspace route; tool/MCP/connector — адаптер.

| Ресурс | Ссылка | Назначение |
|--------|--------|-----------|
| Google Drive — папка для бота (VK-offee) | [1sGGcG1DBHIMMhZFvPGd_gGOesncQwhiq](https://drive.google.com/drive/folders/1sGGcG1DBHIMMhZFvPGd_gGOesncQwhiq) | Жанна загружает отчёты Сабы: Каталог_, Накладные_, Продажи_ |
| Google Sheets — реестр документов | [14PxApr1x8iHuD...](https://docs.google.com/spreadsheets/d/14PxApr1x8iHuD-ioCzYjpRoaEJw_7iYWKjPAkpaOvsM/edit?gid=0#gid=0) | Реестр файлов по папке VK-offee |
| Google Sheets — остатки (Жанна) | [1OHG_qtW3RUty62R1lIx0thaozLZDNJn50Woi551y9II](https://docs.google.com/spreadsheets/d/1OHG_qtW3RUty62R1lIx0thaozLZDNJn50Woi551y9II/edit?gid=872814975#gid=872814975) | Все остатки по кофейне |

**Скрипт доступа:** `VK-offee/saby-integration/google_drive_parser.py`
**Credentials:** `VK-offee/.github/scripts/credentials.json` + `token.pickle`
