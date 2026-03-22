---
type: work-plan
rp_id: 20
title: Восстановление агентов + система мониторинга инфраструктуры
created: 2026-03-19
deadline: 2026-03-19
budget: 3h
status: in_progress
---

# РП#20: Восстановление агентов + система мониторинга

## Цель

Восстановить работу всех агентов после 10 дней простоя (OAuth 401).
Создать систему мониторинга чтобы такое не повторялось.

## Причина простоя

OAuth токен истёк ~5-10 марта. Все агенты падали с 401 молча — никаких алертов не было.
Потеряно: 10 дней дневных планов стратега, недельный обзор W12, все inbox-check экстрактора.

## Входы

- Логи ~/logs/strategist/ и ~/logs/extractor/ с 9 по 19 марта
- SESSION-CONTEXT.md (устарел, последнее обновление 08.03)
- INBOX-TASKS.md (актуален — обновлялся вручную)
- StrategyReport W12 FINAL 2026-03-15.md

## Выход

1. Обновлённый OAuth токен (claude /login — вручную пользователем)
2. SESSION-CONTEXT.md актуален на 19.03
3. WeekPlan W12 создан в current/
4. Агенты запущены вручную (стратег + экстрактор)
5. health-check.sh — ежедневный мониторинг агентов
6. AGENTS-STATUS.md — дашборд статуса

## Действия

### Фаза 1: Восстановление (сейчас)
- [x] Диагностика причины — OAuth 401 с 5-10 марта
- [ ] Обновить токен: `claude /login` (пользователь)
- [ ] Обновить SESSION-CONTEXT.md
- [ ] Создать WeekPlan W12 в current/
- [ ] Запустить экстрактор вручную: inbox-check
- [ ] Запустить стратега вручную: day-plan

### Фаза 2: Мониторинг (после восстановления)
- [ ] Создать health-check.sh
- [ ] Алерт в Telegram при 401 или ошибке агента
- [ ] Аудит инфраструктуры каждые 3 дня (infra-audit.sh)
- [ ] AGENTS-STATUS.md — автообновление каждое утро
- [ ] Зарегистрировать в launchd

## Репо

FMT-exocortex-template (roles/synchronizer/scripts/)
DS-strategy (current/)

## Лог сессии 19 марта 2026

### Сделано:
- Диагностика: OAuth токен истёк ~5-10 марта, все агенты падали с 401
- Записана задача мониторинга в INBOX-TASKS.md
- Создан этот РП

### Следующий шаг:
- Дождаться `claude /login` от пользователя
- Обновить SESSION-CONTEXT и WeekPlan W12
- Запустить агентов вручную

## Лог сессии 22 марта 2026 — helper-only cleanup

### Что сделано
- Подтверждено, что `~/.claude/settings.json` использует только `apiKeyHelper=/Users/alexander/.config/aist/anthropic_auth_helper.sh` и хранит `ANTHROPIC_BASE_URL` в `env`
- Подтверждено, что токен живёт только в `~/.config/aist/env`, а helper корректно его читает
- Удалены shell-хвосты auth из `~/.zprofile`: `ANTHROPIC_BASE_URL` больше не экспортируется из shell
- `~/.zshrc` оставлен без auth-настроек, только алиасы выбора модели
- Остановлены зависшие диа��ностические процессы `claude`/`bash`, которые подвешивали проверку
- Проверено, что proxy `https://dev.aiprime.store/api/v1/models` отвечает `200 OK`
- Проверено пользователем: `claude` в обычном терминале снова запускается без ошибок

### Итоговая схема доступа
1. `~/.claude/settings.json` → `apiKeyHelper`
2. `~/.config/aist/anthropic_auth_helper.sh` → читает `~/.config/aist/env`
3. `~/.config/aist/env` → хранит `ANTHROPIC_AUTH_TOKEN`
4. Shell и VS Code не должны экспортировать `ANTHROPIC_AUTH_TOKEN` напрямую

### Что осталось
- Полностью закрыть VS Code и открыть заново, чтобы сбросить старое окружение процесса
- Проверить запуск Claude внутри VS Code после полного restart
- Если после restart ошибка останется: проверить runtime-хвосты VS Code / launchctl и выбор модели в VS Code

### Как восстановить контекст после перезапуска
- Прочитать этот файл: `~/Github/DS-strategy/inbox/WP-20-agent-recovery-and-monitoring.md`
- Короткий статус: терминал уже починен, helper-only схема очищена, следующий шаг — полный restart VS Code и повторная проверка Claude внутри VS Code
