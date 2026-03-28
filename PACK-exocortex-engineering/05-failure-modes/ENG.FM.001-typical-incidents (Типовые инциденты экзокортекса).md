---
type: failure-modes
pack: PACK-exocortex-engineering
id: ENG.FM.001
title: Типовые инциденты экзокортекса
created: 2026-03-28
---

# ENG.FM.001 — Типовые инциденты экзокортекса (Failure Modes)

## Каталог инцидентов

### FM-01: git pull снимает +x права на скриптах

**Симптом:** `Permission denied` при запуске strategist.sh / scheduler.sh
**Когда:** после `git pull` или применения обновления от upstream
**Корневая причина:** git при merge/pull не всегда сохраняет execute-биты
**Диагностика:** `ls -la roles/*/scripts/*.sh` — найти файлы без `x`
**Исправление:** `chmod +x roles/*/scripts/*.sh`
**Системный фикс:** post-merge git hook → автоматический `chmod +x` после каждого pull
**Дата инцидента:** 2026-03-28

---

### FM-02: day-close зависает без вывода результата

**Симптом:** `strategist.sh day-close` стартует, в логе есть `Starting scenario: day-close`, но нет финального результата
**Когда:** при ручном запуске или launchd
**Корневая причина:** lock-файл существует как директория `day-close.2026-MM-DD.lock/` вместо обычного файла
**Диагностика:** `ls -la ~/logs/strategist/locks/` — проверить тип lock
**Исправление:** удалить lock-директорию, перезапустить
**Системный фикс:** в strategist.sh добавить проверку `[ -d "$LOCK" ]` с принудительным rm -rf
**Дата инцидента:** 2026-03-22

---

### FM-03: OAuth токен истёк, агенты молча падают с 401

**Симптом:** агенты не работают 10+ дней, SESSION-CONTEXT устарел, никаких уведомлений
**Когда:** при истечении срока OAuth токена
**Корневая причина:** нет мониторинга exit codes агентов, нет алерта на 401
**Диагностика:** `grep "401\|Unauthorized\|auth" ~/logs/strategist/*.log`
**Исправление:** `claude /login` → обновить токен
**Системный фикс:** health-check.sh с алертом в Telegram при 401
**Дата инцидента:** 2026-03-19

---

### FM-04: post-commit hook создаёт петлю при git rebase

**Симптом:** конфликты при `git pull --rebase` из-за автоматического push в середине rebase
**Когда:** pull с rebase в репо с post-commit hook
**Корневая причина:** post-commit hook пушит после каждого коммита, включая replay-коммиты при rebase
**Диагностика:** проверить `.git/hooks/post-commit` на наличие `git push`
**Исправление:** добавить guard в hook — проверять `[ -f .git/rebase-merge/head-name ]`
**Дата инцидента:** 2026-03-19

---

### FM-05: validate-template видит скрипты как MISSING (нет +x)

**Симптом:** `validate-template.sh` сообщает `MISSING: roles/strategist/scripts/strategist.sh`
**Когда:** после FM-01 (потеря +x прав)
**Корневая причина:** validate-template проверяет не только наличие файла, но и его исполняемость (`[ -x "$file" ]`)
**Диагностика:** `bash setup/validate-template.sh` → посмотреть MISSING список
**Исправление:** см. FM-01
**Дата обнаружения:** 2026-03-28

---

## Превентивные меры

| Риск | Мера |
|------|------|
| Потеря +x при git pull | post-merge hook с `chmod +x roles/*/scripts/*.sh` |
| 401 без алерта | health-check.sh + Telegram алерт |
| Зависание day-close | Lock-тип проверка в strategist.sh |
| Rebase-петля | Guard в post-commit hook |
| Два экрана открытия не совпадают | Единый source-of-truth для статуса агентов |
