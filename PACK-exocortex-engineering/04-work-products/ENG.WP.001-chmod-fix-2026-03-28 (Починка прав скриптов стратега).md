---
type: work-product
pack: PACK-exocortex-engineering
id: ENG.WP.001
title: Починка прав +x на скриптах стратега (инцидент 2026-03-28)
created: 2026-03-28
status: done
linked_fm: ENG.FM.001 (FM-01, FM-05)
---

# ENG.WP.001 — Починка прав +x на скриптах стратега

## Инцидент

**Дата:** 2026-03-28 утро
**Симптом:** `strategist.sh: Permission denied` при открытии рабочей сессии
**validate-template:** `MISSING: roles/strategist/scripts/strategist.sh`

## Диагностика

```
ls -la ~/Github/FMT-exocortex-template/roles/strategist/scripts/strategist.sh
# -rw-r--r-- (нет +x)
```

**Корневая причина:** `git pull` из upstream Цырена (26.03 19:24) снял execute-биты.
git не гарантирует сохранение +x при merge с upstream через `git pull`.

## Исправление

```bash
chmod +x ~/Github/FMT-exocortex-template/roles/strategist/scripts/strategist.sh
chmod +x ~/Github/FMT-exocortex-template/roles/synchronizer/scripts/scheduler.sh
chmod +x ~/Github/FMT-exocortex-template/roles/synchronizer/scripts/daily-report.sh
```

## Системный фикс

Создан `post-merge` git hook:
`~/Github/FMT-exocortex-template/.git/hooks/post-merge`

Логика: после каждого `git pull/merge` автоматически запускает
`find roles -name "*.sh" -exec chmod +x {} \;`

## Верификация

```bash
~/Github/FMT-exocortex-template/roles/strategist/scripts/strategist.sh status
# → Usage: strategist.sh {morning|...} ✅
```

## Урок

**Capture → ENG.FM.001 (FM-01):**
git pull может снимать +x права на скриптах.
Системный фикс: post-merge hook с chmod +x.
validate-template отображает этот сбой как MISSING (файл есть, но не исполняемый).
