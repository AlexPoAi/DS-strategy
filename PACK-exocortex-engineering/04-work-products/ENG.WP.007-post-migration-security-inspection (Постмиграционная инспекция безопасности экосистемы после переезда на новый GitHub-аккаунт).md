---
type: engineering-work-product
wp_id: ENG.WP.007
title: Постмиграционная инспекция безопасности экосистемы после переезда на новый GitHub-аккаунт
date: 2026-04-04
status: active
priority: high
linked_inbox: SECURITY
author: Environment Engineer (Codex)
---

# ENG.WP.007 — Постмиграционная инспекция безопасности экосистемы после переезда на новый GitHub-аккаунт

## Контекст

Экосистема переезжает на новый GitHub-аккаунт. Старый аккаунт и старые публичные репозитории считаются потенциально скомпрометированным контуром.

Цель этого WP — провести полную post-migration инспекцию безопасности на новом аккаунте, не ломая рабочие автоматизации, и подготовить безопасный порядок ротации секретов и зачистки следов.

---

## Scope

### Репозитории экосистемы

- `VK-offee`
- `VK-offee-rag`
- `DS-strategy`
- `DS-agent-workspace`
- `FMT-exocortex-template`
- `creativ-convector`
- `PACK-iwe-culture`
- `DS-Knowledge-Index-Tseren`
- `agency-agents`

### Что проверяем

1. Visibility и доступы новых репозиториев на новом GitHub-аккаунте
2. Локальные `remote.origin.url` и каналы аутентификации (`git`, `gh`, VS Code, Claude Code)
3. Runtime-хранилища секретов (`.env`, `~/.config/aist/env`, локальные конфиги среды)
4. GitHub Actions secrets и зависимые workflow
5. Локальные OAuth-файлы и интеграции (Google Drive / Sheets, Saby, Telegram)
6. Следы секретов в документации, логах и истории git

---

## Подтверждённые риски на момент открытия WP

### История и публичность

- В истории `VK-offee` ранее подтверждались утечки Telegram bot token и частично Anthropic key
- Ключевые репозитории экосистемы были публичными

### Локальная среда

- В `~/Github/.claude/settings.json` найден прямой Telegram bot token в командах `curl`
- Секреты распределены между несколькими runtime-контурами:
  - `VK-offee/telegram-bot/.env`
  - `VK-offee-rag/.env`
  - `~/.config/aist/env`
  - GitHub Actions secrets
  - локальные конфиги среды

### Архитектурный риск

- Нет единого source-of-truth для секретов и каналов авторизации
- Экосистема использует несколько независимых auth-слоёв одновременно

---

## Рабочий порядок

### Этап 1 — инвентаризация

- Зафиксировать все репозитории на новом аккаунте
- Проверить, что целевые репозитории private
- Собрать таблицу: `секрет → где хранится → кто использует → риск ротации`

### Этап 2 — изоляция доступа

- Убедиться, что новые `remote.origin.url` не содержат токены
- Проверить collaborators, GitHub Apps, webhooks, Actions permissions

### Этап 3 — ротация

- GitHub PAT / repo token
- Telegram bot token
- OpenAI / Anthropic keys
- Google OAuth tokens при необходимости
- Saby secrets при необходимости

### Этап 4 — верификация

- Проверить `git push/pull`
- Проверить Telegram notifications
- Проверить sync Google Drive / Sheets
- Проверить VK-offee bot / RAG
- Проверить cloud/local scheduler workflows

### Этап 5 — чистка следов

- Санитизация документации
- Удаление секретов из локальных конфигов, где они не должны жить
- Решение по rewrite history только после успешной ротации

---

## Артефакты, которые должны появиться по итогам

- `security-migration-audit-report.md`
- `rotation-runbook.md`
- `residual-risks.md`
- при необходимости: `secret-inventory.md` или `.csv`

---

## Критерии завершения

- Все целевые репозитории на новом аккаунте приватные
- Локальные remotes переведены на новый аккаунт без токенов в URL
- Критичные секреты ротированы или признаны безопасными по результатам инспекции
- Автоматизации проходят smoke test после миграции
- Зафиксирован остаточный риск и решение по истории git

---

## Handoff for Implementation

### Цель для агента-исполнителя

После завершения миграции на новый GitHub-аккаунт провести полную post-migration инспекцию безопасности экосистемы, затем поэтапно устранить уязвимости без разрушения текущих автоматизаций.

### Обязательный порядок действий

1. Read-only audit нового аккаунта и локальных remotes
2. Инвентаризация всех секретов и каналов авторизации
3. Проверка visibility, collaborators, GitHub Apps, Actions permissions
4. Ротация секретов по одному сервису
5. Smoke test после каждой ротации
6. Санитизация документации и локальных конфигов
7. Решение по rewrite history только в самом конце

### Что проверить в первую очередь

- `VK-offee`
- `VK-offee-rag`
- `DS-strategy`
- `DS-agent-workspace`
- `FMT-exocortex-template`
- `creativ-convector`

### Критичные места хранения секретов

- `~/Github/.claude/settings.json`
- `~/.config/aist/env`
- `VK-offee/telegram-bot/.env`
- `VK-offee-rag/.env`
- `VK-offee/.github/scripts/credentials.json`
- `VK-offee/.github/scripts/token.pickle`
- `VK-offee/.github/scripts/token_upload.pickle`
- GitHub Actions secrets в новых репозиториях

### Подтверждённые риски, которые нельзя игнорировать

- Старые утечки в истории `VK-offee`
- Публичность ключевых репозиториев до миграции
- Прямой Telegram token в локальном `~/Github/.claude/settings.json`
- Многослойное хранение одних и тех же секретов в разных runtime-контурах

### Ожидаемые выходные артефакты

- `security-migration-audit-report.md`
- `rotation-runbook.md`
- `residual-risks.md`
- `secret-inventory.md` или `.csv`

### Ограничения исполнения

- Не выполнять массовую ротацию “одним махом”
- Не переписывать историю git до завершения миграции и стабилизации нового контура
- Не удалять рабочие локальные secret stores без проверки зависимых сервисов
- Не ломать cloud/local scheduler, Telegram notifications, Drive/Sheets sync, RAG, bot deploy
