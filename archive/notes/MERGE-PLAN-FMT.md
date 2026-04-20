---
type: merge-plan
date: 2026-03-02
upstream: TserenTserenov/FMT-exocortex-template
commits: 25 (c7ab72b..4cd9d65)
status: draft
---

# План мерджа FMT upstream → fork

## Резюме

**57 файлов изменено**, 25 коммитов от наставника. Ключевые изменения:
- ADR-002: Модульная архитектура ролей (role.yaml)
- Оптимизация токенов УЖЕ ЕСТЬ в protocol-open.md ✅
- 7 категорий заметок + творческий конвейер
- Vendor-agnostic AI CLI
- Удалены: ECOSYSTEM.md, archive-review.md, session-import.md

---

## Конфликты (предварительный анализ)

### 1. CLAUDE.md

**Наша версия:**
- §0 "СТАРТ И ФИНИШ" (блокирующее)
- §0.1 Старт сессии — обязательное чтение файлов
- §0.2 После каждой задачи — `close-task.sh`
- Ссылки на `DS-strategy/`

**Upstream версия:**
- §0 удалён
- Ссылки на `DS-my-strategy/` (переименование)
- АрхГейт расширен: +Безопасность, 3-step flow
- "Source-of-truth" → "Первоисточник" (русификация)

**Решение:**
- ✅ Сохранить наш §0 (критично для workflow)
- ✅ Взять upstream: АрхГейт 3-step, Безопасность
- ✅ Заменить `DS-strategy` → `DS-my-strategy` (у нас DS-strategy, оставляем как есть)
- ✅ Взять русификацию терминов

### 2. memory/protocol-open.md

**Конфликт:**
- Upstream: `DS-my-strategy/`
- Наш: `DS-strategy/`

**Решение:**
- ✅ Оставить `DS-strategy/` (наше именование)
- ✅ Взять правило нумерации РП (без буквенных суффиксов)

### 3. Удалённые файлы

**Upstream удалил:**
- `my-strategy/current/SESSION-CONTEXT.md`
- `roles/extractor/prompts/archive-review.md`
- `roles/extractor/prompts/session-import.md`
- `ECOSYSTEM.md`

**У нас активно используются:**
- `DS-strategy/current/SESSION-CONTEXT.md` ✅ (критично!)

**Решение:**
- ✅ Восстановить SESSION-CONTEXT.md после мерджа
- ⚠️ Проверить зависимости от archive-review, session-import

### 4. Новые файлы (role.yaml)

**Upstream добавил:**
- `roles/strategist/role.yaml`
- `roles/extractor/role.yaml`
- `roles/synchronizer/role.yaml`
- `roles/ROLE-CONTRACT.md`
- `docs/adr/ADR-001-setup-in-template.md`
- `docs/adr/ADR-002-modular-roles.md`

**У нас НЕТ:**
- role.yaml × 3

**Решение:**
- ✅ Принять все новые файлы
- ✅ После мерджа: проверить что скрипты работают с role.yaml

### 5. Изменённые скрипты

**Upstream изменил:**
- `setup.sh` — автодискавери ролей
- `update.sh` — цикл по role.yaml
- `scheduler.sh` — get_role_runner()
- `notify.sh` — динамический список

**Решение:**
- ✅ Принять все изменения
- ⚠️ После мерджа: протестировать агенты

### 6. Наши кастомизации

**Что у нас есть, чего нет в upstream:**
- `roles/extractor/config/routing.md` — 5 Pack (bar, kitchen, service, management, hr)
- `close-task.sh` в корне ~/Github/
- Персональные настройки в `.claude/settings.local.json`

**Решение:**
- ✅ Сохранить routing.md для 5 Pack
- ✅ Сохранить close-task.sh
- ✅ Проверить settings.local.json после мерджа

---

## Стратегия мерджа (пошагово)

### Фаза 0: Подготовка (5 мин)

```bash
cd /Users/alexander/Github/FMT-exocortex-template

# 1. Создать backup ветку
git checkout -b backup-before-upstream-merge
git push origin backup-before-upstream-merge

# 2. Вернуться на main
git checkout main

# 3. Проверить статус
git status
```

### Фаза 1: Мердж (10 мин)

```bash
# 1. Мердж upstream
git merge upstream/main

# 2. Ожидаемые конфликты:
#    - CLAUDE.md (§0)
#    - memory/protocol-open.md (DS-strategy vs DS-my-strategy)
#    - Возможно: routing.md, другие кастомизации

# 3. Разрешить конфликты вручную (см. ниже)
```

### Фаза 2: Разрешение конфликтов (20 мин)

#### CLAUDE.md

```bash
# Открыть в редакторе
code CLAUDE.md

# Стратегия:
# 1. Сохранить наш §0 (СТАРТ И ФИНИШ) — в начало файла
# 2. Взять upstream §1-6 (обновлённые)
# 3. В §5 АрхГейт — взять 3-step flow + Безопасность
# 4. Заменить "DS-my-strategy" → "DS-strategy" (наше именование)
```

#### memory/protocol-open.md

```bash
# Открыть в редакторе
code memory/protocol-open.md

# Стратегия:
# 1. Оставить "DS-strategy" (не менять на DS-my-strategy)
# 2. Взять правило нумерации РП (без буквенных суффиксов)
# 3. Взять обновлённую таблицу моделей (Opus/Sonnet/Haiku)
```

#### Восстановить SESSION-CONTEXT.md

```bash
# Upstream удалил, но у нас критично
git checkout backup-before-upstream-merge -- DS-strategy/current/SESSION-CONTEXT.md

# Или создать заново из backup
```

### Фаза 3: Проверка после мерджа (30 мин)

#### 3.1 Проверить role.yaml

```bash
# Проверить что файлы появились
ls -la roles/strategist/role.yaml
ls -la roles/extractor/role.yaml
ls -la roles/synchronizer/role.yaml

# Прочитать контракт
cat roles/ROLE-CONTRACT.md
```

#### 3.2 Проверить скрипты

```bash
# Проверить что setup.sh работает с role.yaml
./setup.sh --dry-run

# Проверить scheduler
cat roles/synchronizer/scripts/scheduler.sh | grep "get_role_runner"
```

#### 3.3 Проверить агенты

```bash
# Статус всех агентов
launchctl list | grep -E "(strategist|extractor|scheduler)"

# Ожидаемые:
# - com.exocortex.scheduler
# - com.strategist.morning
# - com.strategist.weekreview
# - com.extractor.inbox-check
# - com.extractor.session-watcher
```

#### 3.4 Проверить routing.md

```bash
# Проверить что наша кастомизация сохранилась
cat roles/extractor/config/routing.md | grep -E "PACK-bar|PACK-kitchen"
```

#### 3.5 Проверить close-task.sh

```bash
# Проверить что скрипт на месте
ls -la ~/Github/close-task.sh

# Проверить что он работает
~/Github/close-task.sh --dry-run "test"
```

### Фаза 4: Коммит и push (5 мин)

```bash
# 1. Добавить все изменения
git add .

# 2. Коммит
git commit -m "merge: синхронизация с upstream (25 коммитов, ADR-002 модульные роли)"

# 3. Push
git push origin main
```

---

## Чек-лист мерджа

### Подготовка
- [ ] Создать backup ветку
- [ ] Проверить git status (нет uncommitted changes)

### Мердж
- [ ] git merge upstream/main
- [ ] Разрешить конфликты в CLAUDE.md
- [ ] Разрешить конфликты в protocol-open.md
- [ ] Восстановить SESSION-CONTEXT.md
- [ ] Проверить routing.md (5 Pack)

### Проверка
- [ ] role.yaml × 3 появились
- [ ] ROLE-CONTRACT.md на месте
- [ ] ADR-001, ADR-002 на месте
- [ ] setup.sh работает
- [ ] scheduler.sh работает
- [ ] Агенты запущены (launchctl list)
- [ ] routing.md сохранён
- [ ] close-task.sh работает

### Финализация
- [ ] git add .
- [ ] git commit
- [ ] git push origin main
- [ ] Обновить MEMORY.md (запись о мердже)
- [ ] Обновить project-brain.md (запись о мердже)

---

## Риски и митигация

| Риск | Вероятность | Митигация |
|------|-------------|-----------|
| Конфликты в CLAUDE.md | Высокая | Backup ветка + ручное разрешение |
| Агенты перестанут работать | Средняя | Проверка launchctl после мерджа |
| Потеря SESSION-CONTEXT.md | Высокая | Восстановить из backup |
| Потеря routing.md (5 Pack) | Низкая | Проверить после мерджа |
| Скрипты не найдут role.yaml | Средняя | Тестирование setup.sh |

---

## Откат (если что-то пошло не так)

```bash
# Вернуться на backup ветку
git checkout backup-before-upstream-merge

# Или hard reset
git reset --hard backup-before-upstream-merge

# Или создать новую ветку от backup
git checkout -b main-restored backefore-upstream-merge
```

---

## Следующие шаги (после успешного мерджа)

1. ✅ РП#1 — Оптимизация токенов (уже есть в upstream!)
2. ⏭️ РП#2 — Проверка инфраструктуры (продолжение)
3. ⏭️ РП#3 — Развитие VK-offee

---

*Создан: 2026-03-02*
*Статус: Draft — ждём подтверждения пользователя*
