---
type: work-product
id: WP-61
date: 2026-04-17
priority: high
category: engineering
status: completed
---

# WP-61 — Миграция на Claude Pro (официальный контур)

## Цель

Переключить экзокортекс со старого кастомного API-контура на официальный Claude Pro.

## Артефакт

Рабочая конфигурация Claude Code c `authMethod=claude.ai` + обновлённые точки входа агентов без `anthropic_auth_helper.sh`.

## Контекст

- **Было:** helper + кастомный `ANTHROPIC_BASE_URL` (`dev.aiprime.store`)
- **Стало:** официальный логин Claude Pro (`claude auth status -> loggedIn=true`, `subscriptionType=pro`)
- **Итог:** legacy auth удалён, runtime-arbiter/extractor/strategist переведены на `claude auth status`

## Задачи

1. [x] Удалён старый auth-контур из `~/.claude/settings.json` (`apiKeyHelper`, `ANTHROPIC_BASE_URL`)
2. [x] Подтверждён официальный вход Claude Pro (`authMethod=claude.ai`, `subscriptionType=pro`)
3. [x] Обновлены точки входа агентов и preflight под `claude auth status`
4. [x] Удалены legacy-файлы (`~/.config/aist/anthropic_auth_helper.sh`, backup с legacy токеном)
5. [x] Проверен runtime-arbiter (`AI_CLI_CLAUDE_STATUS=available`, `AI_CLI_CLAUDE_REASON=auth_status_ok`)

## Бюджет

40 минут

## Дедлайн

Сегодня (2026-04-17)

## Репозиторий

- FMT-exocortex-template (основная конфигурация)
- DS-agent-workspace (агенты)

## Критерии готовности

- [x] Claude Pro auth активен в Claude Code
- [x] Legacy helper/proxy удалены
- [x] Ключевые агентские скрипты обновлены на официальный auth-check
- [x] Проверка работоспособности выполнена

---

**Создано:** 2026-04-17
**Категория:** Инженерные работы (PACK-exocortex-engineering)
