# ENGINEERING-CONTEXT — management

> Инженерный контекст предметной области `management`.

**Последнее обновление:** 2026-04-23  
**Статус:** seeded  
**Primary domain:** `/Users/alexander/Github/VK-offee/PACK-management`

---

## Что это за ветка

Эта ветка хранит не сам управленческий source-of-truth, а инженерную историю
работ по management-domain:

- какие bounded slices открывались;
- какие роли и артефакты materialized;
- какие навигационные слои уже добавлены;
- что остаётся следующим инженерным шагом.

## Уже выполненные инженерные работы

### WP-106

**Тема:** `PACK-management` через `FPF -> SRT -> SPF` и роль `управляющего кофейней`

Materialized:

- `MGMT.ROLE.001-cafe-manager`
- `MGMT.WP.018-management-domain-fpf-srt-spf-pass`
- обновлены `PACK-management/00-pack-manifest.md` и `PACK-management/MANIFEST.md`

Главный результат:

- `PACK-management` теперь различён как primary management layer для:
  - `readiness`
  - `repair`
  - `relocation`
  - `launch`
  - `major equipment`

### WP-107

**Тема:** `CONTEXT` и `DOCUMENT-REGISTRY` для `PACK-management`

Materialized:

- `PACK-management/CONTEXT.md`
- `PACK-management/DOCUMENT-REGISTRY.md`

Главный результат:

- домен получил базовый navigation-layer;
- следующий агент может входить в management-domain без восстановления картины с нуля.

## Текущее состояние ветки

- домен различён;
- role-layer materialized;
- navigation-layer materialized;
- factual management events ещё не занесены как первая живая серия карточек.

## Следующий честный инженерный шаг

Не engineering refactor, а предметный factual slice:

1. занести ремонт кухни в `PACK-management` как primary fact;
2. занести покупку `Victoria Arduino Eagle One` как management-level equipment fact;
3. при необходимости дать secondary echoes в `PACK-kitchen` и `barista-class`.
