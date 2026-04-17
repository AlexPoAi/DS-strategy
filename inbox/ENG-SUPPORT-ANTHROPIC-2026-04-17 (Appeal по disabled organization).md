---
type: engineering-support-case
date: 2026-04-17
status: waiting-response
priority: critical
---

# Anthropic Support Case — disabled organization

## Инцидент

- Симптом: `API Error: 400 ... "This organization has been disabled."`
- Затронуто: Claude CLI/API в инженерном контуре (включая складской pipeline, где был задействован Anthropic runtime).
- Подтверждение: ошибка воспроизводится на `claude -p "ping"` после авторизации.

## Идентификаторы

- Аккаунт: `alexpoaiagent@gmail.com`
- Org ID: `2e8cf63d-7da9-4588-8f78-243b5cf16659`
- Request IDs:
  - `req_011Ca9mFUGQ1hqvyKFX1zdSs`
  - `req_011Ca9mT3LJ4xQUV88LZkaBd`
  - `req_011Ca9mPYqDGKG7xBkPThsFr`

## Действия

1. Подготовлен и отправлен appeal в Trust & Safety через официальную форму Anthropic.
2. В appeal переданы org/request IDs и контекст production-impact.
3. Зафиксировано дополнительное пояснение по историческому использованию чужого ключа (возможный источник риска).

## Ответ поддержки

- Support направил в mandatory appeal-контур.
- Разблокировка недоступна через обычный support inbox.
- Текущий статус: ожидание ответа Trust & Safety.

## Временная инженерная политика до ответа

1. Не использовать старые/чужие ключи.
2. Для критичных задач держать fallback-провайдер в рабочем состоянии.
3. После ответа Anthropic обновить runtime-contract и закрыть инцидент отдельной записью.
