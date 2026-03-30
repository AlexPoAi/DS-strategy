---
type: engineering-work-product
wp_id: ENG.WP.004
title: Починка notify.sh после дрейфа путей IWE→Github
date: 2026-03-29
status: done
priority: high
linked_inbox: WP-39
author: Environment Engineer (Claude Sonnet 4.6)
---

# ENG.WP.004 — Починка notify.sh после дрейфа путей IWE→Github

## Инцидент

**Дата обнаружения:** 2026-03-28
**Дата исправления:** 2026-03-29
**Симптом:** strategist.sh завершал сценарии (day-plan, evening и др.), но post-step уведомление падало с `No such file or directory`, из-за чего «мозг экзокортекса» оставался в жёлтом статусе.

**Лог ошибки:**
```
/Users/alexander/Github/FMT-exocortex-template/roles/strategist/scripts/strategist.sh: line 64:
/Users/alexander/IWE/DS-IT-systems/DS-ai-systems/synchronizer/scripts/notify.sh: No such file or directory
```

---

## Диагностика (Шаг 1)

**Корневая причина:** path drift после миграции `~/IWE → ~/Github`.

Строка 64 в `strategist.sh` содержала захардкоженный путь к `notify.sh` по старой структуре.

| Устаревший путь | Реальный путь |
|-----------------|---------------|
| `$HOME/IWE/DS-IT-systems/DS-ai-systems/synchronizer/scripts/notify.sh` | `$HOME/Github/FMT-exocortex-template/roles/synchronizer/scripts/notify.sh` |

**Аудит других файлов** выявил дополнительные остатки:

| Файл | Строка | Тип проблемы |
|------|--------|--------------|
| `strategist.sh:64` | 🔴 Исполняемый скрипт | **Критично → исправлен** |
| `protocol-close.md:50` | 🟠 Инструкция для агента | **Важно → исправлен** |
| `protocol-close.md:182` | 🟠 Пример команды | **Важно → исправлен** |
| `day-close.sh:23 LINEAR_SYNC` | 🟡 Нет файла, но graceful skip | Приемлемо (linear-sync.sh не существует) |
| `memory/navigation.md` | 📄 Справочник устарел | Информационный дрейф |

---

## Исправления (Шаг 2)

### Файл 1: `roles/strategist/scripts/strategist.sh:64`

**До:**
```bash
"$HOME/IWE/DS-IT-systems/DS-ai-systems/synchronizer/scripts/notify.sh" strategist "$scenario" >> "$LOG_FILE" 2>&1 || true
```

**После:**
```bash
"$HOME/Github/FMT-exocortex-template/roles/synchronizer/scripts/notify.sh" strategist "$scenario" >> "$LOG_FILE" 2>&1 || true
```

### Файл 2: `memory/protocol-close.md:50`

**До:** `DS-IT-systems/DS-ai-systems/extractor/prompts/session-close.md`
**После:** `FMT-exocortex-template/roles/extractor/prompts/session-close.md`

### Файл 3: `memory/protocol-close.md:182`

**До:** `{{WORKSPACE_DIR}}/DS-IT-systems/DS-ai-systems/synchronizer/scripts/day-close.sh`
**После:** `{{WORKSPACE_DIR}}/FMT-exocortex-template/scripts/day-close.sh`

---

## Верификация (Шаг 3)

| Проверка | Результат |
|----------|-----------|
| `ls notify.sh` по новому пути | ✅ файл существует, права `rwxr-xr-x` |
| `bash -n notify.sh` (синтаксис) | ✅ OK |
| Симуляция строки 64: `notify.sh strategist test` | ✅ exit 0, `Empty message — skip` |
| Отсутствие старых путей в protocol-close.md | ✅ grep вернул пустой результат |
| git commit + push | ✅ `1fddbc8` в main |

---

## Коммит

```
fix(WP-39): исправить path drift IWE→Github в strategist.sh и protocol-close.md
Commit: 1fddbc8
Repo: FMT-exocortex-template
Date: 2026-03-29
```

---

## Типовой паттерн (Урок для будущих инцидентов)

**Path Drift** — захардкоженные абсолютные пути в скриптах устаревают при переносе директорий.

**Признаки:** `No such file or directory` в логе + агент завершается успешно, но post-step падает → статус остаётся жёлтым, хотя работа выполнена.

**Диагностика:**
```bash
grep -rn "IWE/DS-IT-systems\|DS-ai-systems" ~/Github/ 2>/dev/null
```

**Профилактика:**
- Использовать переменные (`$HOME`, `$(dirname "$0")`) вместо абсолютных путей
- После любой миграции директорий — аудит `grep -rn "старый_путь" ~/Github/`

---

## Критерий закрытия

- [x] `No such file or directory` для notify.sh больше не появляется при симуляции
- [x] Фикс законсёрчен и запушен в GitHub
- [x] ENG.WP.004 создан и сохранён в PACK-exocortex-engineering
- [ ] Следующий плановый запуск стратега (04:00 ПН) пройдёт без ошибки — финальное подтверждение
