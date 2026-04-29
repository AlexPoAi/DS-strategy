---
name: Drive-ссылки в Pack-артефактах
description: При заполнении предметной области (Pack) вставлять ссылку на Drive-папку прямо в карточку объекта
type: feedback
valid_from: 2026-04-29
originSessionId: fe20340e-d040-4df3-88e0-89831654d8e2
---
При создании или заполнении Pack-артефактов (domain-contract, entity-card, data-layer) — вставлять прямую ссылку на соответствующую Google Drive папку.

**Why:** агент должен всегда знать где взять реальные данные. Ссылка в карточке = агент идёт за данными сам, без вопросов.

**How to apply:** в секции «Источники данных» или «Входные данные» Pack-карточки добавлять строку:
`Drive: https://drive.google.com/drive/folders/{id} — что там лежит`

Карта всех папок: `DS-strategy/exocortex/reference-google-drive-vkoffee.md`
