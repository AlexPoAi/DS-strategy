# ENG.WP.033 — Анализ сокращения расхода токенов через обновления upstream

**Дата:** 2026-04-11
**Статус:** анализ завершён, внедрение отложено (передаётся другому агенту)
**Связан с:** ENG.WP.032 (аудит upstream)
**Цель:** сократить расход токенов в 2x за счёт механизмов Церена

---

## Контекст

После аудита ENG.WP.032 поставлена задача: проанализировать какие именно обновления Церена дадут 2x экономию токенов и насколько безопасно их внедрить в нашу экосистему без поломки агентов.

---

## Текущий overhead (до внедрения)

| Файл | Строк | ~Токенов | Загружается |
|------|-------|----------|-------------|
| CLAUDE.md | 198 | ~6 000 | Каждая сессия |
| MEMORY.md | 188 | ~5 500 | Каждая сессия |
| protocol-open.md | 125 | ~3 500 | При Open |
| protocol-close.md | 59 | ~1 800 | При Close |
| protocol-work.md | 63 | ~1 800 | При Work |
| settings.json + additionalDirectories | — | ~3 000 | Каждая сессия |
| **Итого** | | **~21 000** | |

У Церена после Context Compression: **~13 000** (заявлено в CHANGELOG v0.15).

---

## Три ключевых механизма сжатия Церена

### Механизм 1: `.claude/rules/` — автозагрузка без ссылки
Claude Code автоматически читает все файлы из `.claude/rules/` в каждой сессии.
Церен вынес туда:
- `distinctions.md` — различения и терминология
- `formatting.md` — правила форматирования

**Экономия:** ~3 500 токенов/сессию (контент выносится из CLAUDE.md)
**Риск:** нет — новые файлы, ничего не ломает

### Механизм 2: CLAUDE.md сжат до ~90 строк (Context Compression v0.15)
Детали протоколов, форматирования, различений вынесены из CLAUDE.md.
Было ~280 строк → стало ~90. Overhead: 27K → 13K токенов.

**Экономия:** ~2 000 токенов/сессию
**Риск:** нельзя взять его CLAUDE.md напрямую — перетрёт наши кастомные правила

### Механизм 3: skill `/day-open` — lazy loading шаблонов
Шаблоны DayPlan/WeekPlan вынесены в `.claude/skills/day-open/SKILL.md`.
Загружаются только при «открывай день» — не в каждой сессии.

**Экономия:** ~8 000 токенов в обычных сессиях (не Day Open)
**Риск:** его skill ссылается на `day-rhythm-config.yaml`, `IWE_SCRIPTS`, `strategy_day` — у нас нет, нужна адаптация

---

## Анализ рисков для нашей экосистемы

| Компонент | Риск | Причина |
|-----------|------|---------|
| `strategist.sh` | Нет | Ищет `protocol-open.md` — путь не меняем |
| `extractor.sh` | Нет | То же |
| `health-check.sh` | Нет | Проверяет canonical route — не трогаем |
| `close-task.sh` | Нет | Не зависит от CLAUDE.md / rules |
| Hooks | Нет | `.claude/rules/` не меняет поведение hooks |
| SESSION-OPEN артефакт | Нет | Генерируется `daily-report.sh` |

---

## Что можно скачать у Церена как есть (upstream открыт)

| Файл | Статус | Примечание |
|------|--------|------------|
| `.claude/rules/distinctions.md` | ✅ Брать | Общие различения |
| `.claude/rules/formatting.md` | ✅ Брать | Универсальные правила |
| `.claude/skills/verify/SKILL.md` | ✅ Брать | Универсальный |
| `.claude/skills/archgate/SKILL.md` | ✅ Брать | Универсальный |
| `extensions/` + `params.yaml` | ✅ Брать | Новые файлы, нейтральные |
| `.claude/hooks/wp-gate-reminder.sh` | ⚠️ Адаптировать | Ссылки на `IWE_SCRIPTS`, `extensions/` |
| `.claude/hooks/close-gate-reminder.sh` | ⚠️ Адаптировать | То же |
| `.claude/skills/day-open/SKILL.md` | ⚠️ Адаптировать | `day-rhythm-config.yaml`, `IWE_SCRIPTS` |
| `memory/MEMORY.md` | ❌ Не брать | Перетрёт наш |
| `memory/protocol-open.md` | ❌ Не брать | Перетрёт наши правила |
| `CLAUDE.md` | ❌ Не брать | Перетрёт всё кастомное |

---

## Команды для скачивания (готово к выполнению)

```bash
# Скачать rules/ (безопасно, как есть)
cd ~/Github/FMT-exocortex-template
git show upstream/main:.claude/rules/distinctions.md > ~/Github/.claude/rules/distinctions.md
git show upstream/main:.claude/rules/formatting.md > ~/Github/.claude/rules/formatting.md

# Скачать universal skills (безопасно, как есть)
mkdir -p ~/Github/.claude/skills/verify
mkdir -p ~/Github/.claude/skills/archgate
git show upstream/main:.claude/skills/verify/SKILL.md > ~/Github/.claude/skills/verify/SKILL.md
git show upstream/main:.claude/skills/archgate/SKILL.md > ~/Github/.claude/skills/archgate/SKILL.md

# Скачать extensions/ и params.yaml (безопасно, новые файлы)
git show upstream/main:extensions/README.md > ~/Github/extensions/README.md
git show upstream/main:params.yaml > ~/Github/params.yaml

# Хуки и day-open skill — требуют адаптации перед применением
```

---

## Ожидаемая экономия после Фазы 1

| Что внедряем | Экономия |
|-------------|----------|
| `.claude/rules/` | ~3 500 токенов/сессию |
| Сжатие CLAUDE.md | ~2 000 токенов/сессию |
| skill `/day-open` (адаптация) | ~5 000 в обычных сессиях |
| **Итого** | **~8 000–10 000 токенов/сессию** |
| **До** | ~21 000 |
| **После** | ~11 000–13 000 |
| **Сокращение** | **~45–50% ≈ 2x** |

---

## Что нужно сделать агенту (handoff)

### Фаза 1 — безопасная (~2h)
1. Создать `~/Github/.claude/rules/` — скачать `distinctions.md` и `formatting.md` от Церена
2. Создать `~/Github/.claude/skills/verify/` и `archgate/` — скачать как есть
3. Создать `~/Github/extensions/` и `params.yaml` — скачать как есть
4. Сократить `~/Github/CLAUDE.md`: вынести §4 навигация и §6 форматирование в rules, убрать дублирование с MEMORY.md (цель: ~120 строк)
5. Адаптировать `.claude/skills/day-open/SKILL.md` под нашу экосистему (убрать `IWE_SCRIPTS`, `day-rhythm-config.yaml`, `strategy_day` — заменить на наши эквиваленты)
6. Точечный фикс hooks: jq multiline bug (`tr '\n\r\t' '   '` уже есть у Церена в wp-gate-reminder)

### Важные ограничения
- **НЕ** трогать `memory/protocol-open.md`, `protocol-close.md` — агенты зависят от путей
- **НЕ** трогать `memory/MEMORY.md` — наши РП и правила
- **НЕ** брать CLAUDE.md Церена целиком
- После каждого изменения — проверить `bash ~/Github/FMT-exocortex-template/setup/validate-template.sh`
- Финал — стартовый экран: должен остаться зелёным

### Проверка успеха
```bash
# Размер CLAUDE.md после
wc -l ~/Github/CLAUDE.md  # цель: ≤130 строк

# rules/ загружены
ls ~/Github/.claude/rules/  # distinctions.md, formatting.md

# skills/ загружены
ls ~/Github/.claude/skills/  # verify/, archgate/, day-open/
```

---

## Связанные артефакты
- [ENG.WP.032](ENG.WP.032-exocortex-modernization-upstream-audit%20(Аудит%20обновлений%20upstream%20—%20модернизация%20экзокортекса).md) — аудит всех обновлений upstream
- Upstream: `git show upstream/main:<path>` из `~/Github/FMT-exocortex-template`
