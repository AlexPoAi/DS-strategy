---
type: support-case
created: 2026-04-26
vendor: GitHub
status: waiting-for-support
topic: trade-control account restriction
---

# ENG-SUPPORT-GITHUB-2026-04-26 — Appeal по trade-control restriction

## Ситуация

GitHub вернул для приватных репозиториев ошибку:
`Due to U.S. trade controls law restrictions, this repository has been disabled.`

Поведение подтверждено на `DS-agent-workspace`:
- `git ls-remote https://github.com/AlexPoAi/DS-agent-workspace.git HEAD` -> `403`
- `git push` -> `403`
- `gh auth status` также показывает invalid token, но GitHub endpoint возвращает отдельную legal/compliance ошибку, не только auth failure.

## Действие владельца

- Подготовлено обращение в GitHub Support: `Appeal a trade-control account restriction`.
- В appeal указано, что владелец находится в Казахстане и ездит в Германию по работе.
- Статус: ждём ответа GitHub Support.

## Временная мера

- `VK-offee` временно переведён владельцем в public-доступ, чтобы восстановить хотя бы public repository services.
- Проверка 2026-04-26: `git ls-remote https://github.com/AlexPoAi/VK-offee.git HEAD` успешно возвращает `8e448880fcbc435648bb0e8db326c6822adaf5a8`.

## Рабочий режим до ответа

- Private GitHub не считать надёжным источником истины.
- Продолжать local-first работу в репозиториях.
- Критичные документы дублировать в Google Drive.
- Для важных локальных изменений держать резервный путь: `git bundle`, патчи или другой Git hosting.
- Перед push проверять, открыт ли конкретный repo endpoint (`git ls-remote origin HEAD`).

## Следующий шаг

1. Дождаться ответа GitHub Support по appeal.
2. Если restriction снят — переавторизовать `gh`, проверить `fetch/push` по всем core repos.
3. Если restriction не снят — принять решение: public repos, другой Git hosting или self-hosted Gitea.
