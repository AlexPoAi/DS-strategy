---
type: extraction-report
source: inbox-check
date: 2026-04-29
status: pending-review
processed: 4
remaining: 0
---

# Extraction Report (Inbox-Check)

**Дата:** 2026-04-29
**Источник:** DS-strategy/inbox/captures.md
**Обработано captures:** 4 из 4
**Осталось:** 0

---

## Кандидат #1

**Источник capture:** Пересмотр меню и дисциплины сервиса должен идти как единый пакет бариста-собрания [source: сессия 2026-02-03]
**Сырой текст:** «На бариста-собрании нужно рассматривать не только цены, но целый связанный пакет решений: поднятие цен на основные напитки, сверку цен зерна с рынком, обновление drip-ассортимента, проверку исполнения должностных инструкций и состояния сервиса по сети. Обучение тоже встроено в этот пакет: первым кандидатом на сенсорику рассматривается Родион Высокий.»
**Классификация:** rule

**Куда записать:**
- **Репо:** VK-offee/PACK-management
- **Файл:** VK-offee/PACK-management/04-work-products (Рабочие продукты)/MGMT.WP.019-barista-meeting-decision-package (Пакет решений для бариста-собрания).md
- **Действие:** создать файл

**Совместимость:**
- **Результат:** совместим
- **Проверено:** VK-offee/PACK-management/00-pack-manifest.md; VK-offee/PACK-management/MANIFEST.md; VK-offee/PACK-service/03-methods (Методы)/SERVICE.METHOD.001-sales-funnel-barista-v2 (Воронка продаж для бариста v2).md

**Готовый текст (ready-to-commit):**

~~~markdown
---
type: work-product
id: MGMT.WP.019
title: Пакет решений для бариста-собрания
status: draft
created: 2026-04-29
domain: PACK-management
source: capture 2026-02-03
---

# MGMT.WP.019 — Пакет решений для бариста-собрания

## Назначение

Зафиксировать barista-meeting как управленческий пакет связанных решений,
а не как разрозненный разговор только о ценах.

## Что входит в пакет

1. Поднятие цен на основные напитки.
2. Сверка цен на зерно с рынком.
3. Обновление drip-ассортимента.
4. Проверка исполнения должностных инструкций.
5. Проверка состояния сервиса по сети.
6. Выбор ближайшего учебного шага по сенсорике.

## Принцип

Если бариста-собрание обсуждает только один кусок, например цены,
а сервисная дисциплина, ассортимент и обучение остаются вне кадра,
собрание считается неполным.

## Результат собрания

- есть один согласованный пакет решений;
- по каждому пункту назначен владелец;
- зафиксированы follow-up действия по меню, сервису и обучению.
~~~

**Вердикт:** accept
**Обоснование:** Capture смешан по исходному типу (`rule`), но по смыслу это устойчивый management-level work product: повестка и composition barista-meeting. Он попадает в bounded context `PACK-management` как междоменный координационный пакет, а не как локальный сервисный SOP.

---

## Кандидат #2

**Источник capture:** Контроль витрин и заявок должен быть закреплён персонально по точкам [source: сессия 2026-02-03]
**Сырой текст:** «Контроль витрин и заявок нельзя оставлять без владельца; его нужно закреплять персонально по конкретным точкам. В сессии таким владельцем для Самокиша и Луговой назначается Родион, а рядом сразу фиксируется смежный цифровой хвост по Instagram. Это задаёт принцип: у каждой операционной зоны должен быть ответственный и набор сопутствующих контрольных контуров.»
**Классификация:** rule

**Куда записать:**
- **Репо:** VK-offee/PACK-service
- **Файл:** VK-offee/PACK-service/04-work-products (Рабочие продукты)/SERVICE.WP.001-checklist-waiter (Чек-лист официанта по сменам).md
- **Действие:** не создавать новый файл; отклонить как дубликат и governance-mixed capture

**Совместимость:**
- **Результат:** дубликат
- **Проверено:** VK-offee/PACK-service/04-work-products (Рабочие продукты)/SERVICE.WP.001-checklist-waiter (Чек-лист официанта по сменам).md; VK-offee/PACK-service/04-work-products (Рабочие продукты)/SERVICE.WP.002-checklist-runner (Чек-лист раннера по сменам).md; VK-offee/PACK-cafe-operations/01-domain-contract (Контракт домена)/distinctions.md

**Готовый текст (ready-to-commit):**

~~~markdown
N/A — принцип ownership для витрины и заявок уже зафиксирован в service checklists,
а персональное назначение Родиона и Instagram-tail относится к governance слоям,
а не к новому Pack-знанию.
~~~

**Вердикт:** reject
**Обоснование:** Универсальная часть capture уже материализована в чек-листах официанта/раннера и в различении ответственности ролей. Остаток capture — это situational assignment по людям и точкам, то есть governance-контент, который не нужно экстрагировать в Pack заново.

---

## Кандидат #3

**Источник capture:** В Marathon-v2 нужно явно различать режим ленты и режим марафона [source: сессия 2026-02-03]
**Сырой текст:** «В продукте Marathon-v2 пользователю должно быть явно объяснено различие между режимом ленты и режимом марафона. Отдельно нужно описать, как именно выполнять задание так, чтобы система засчитывала прогресс; иначе сам интерфейс и материалы для учеников создают путаницу. Это знание относится не к маркетингу, а к базовому контракту использования продукта.»
**Классификация:** distinction

**Куда записать:**
- **Репо:** marathon-v2
- **Файл:** marathon-v2/PACK-*/01-domain-contract/01B-distinctions.md
- **Действие:** не выполнять; defer до появления явного Pack/repo маршрута и bounded context

**Совместимость:**
- **Результат:** defer
- **Проверено:** FMT-exocortex-template/roles/extractor/config/routing.md; DS-strategy/inbox/WP-58-marathon-alena-feedback (Ответы на вопросы Алёны по марафону).md

**Готовый текст (ready-to-commit):**

~~~markdown
### D.MARATHON.001: Режим ленты ≠ Режим марафона

| Режим ленты | Режим марафона |
|-----|-----|
| Свободное чтение и просмотр материалов | Выполнение заданий по заданной траектории |
| Контент можно потреблять без фиксации шага | Прогресс зависит от корректного выполнения шага |
| Навигация ориентирована на обзор | Навигация ориентирована на прохождение |

**Почему важно**: если пользователь не различает эти режимы, он не понимает, почему прогресс не засчитывается.

**Тест**: пользователь просто читает материалы? Да → режим ленты. Нет, он идёт по заданиям с зачётом прогресса → режим марафона.
~~~

**Вердикт:** defer
**Обоснование:** Capture содержательно хороший и не похож на feedback rejects, но текущая routing-конфигурация не содержит Pack для `Marathon-v2`, а в workspace нет явного целевого Pack manifest. Без bounded context и файла-назначения предлагать запись как `accept` нельзя.

---

## Кандидат #4

**Источник capture:** VPS runtime: утренний Strategist не автономен без рабочего LLM provider [source: engineering check 2026-04-28]
**Сырой текст:** «Проверка автономности при выключенном ноутбуке показала: на VPS `72.56.4.61` есть активный `com.exocortex.scheduler.timer`, но утренний Strategist не может завершить `day-plan`. Runtime-слой исправлен: systemd теперь запускает `/root/Github/.iwe-runtime/roles/synchronizer/scripts/scheduler.sh`, `.iwe-runtime` собран, `DS-strategy` на VPS переведён из nongit-копии в git checkout, `daily-report` и `extractor` доходят до выполнения. GitHub write auth на VPS настроен: `SchedulerReport 2026-04-28` успешно запушен в `DS-strategy`. Блокер остался в provider-plane: Codex CLI через ChatGPT websocket получает `403 Forbidden` от `chatgpt.com/backend-api/codex/responses`; Claude CLI с OAuth token показывает login, но запрос `-p` возвращает `API Error: 403 Request not allowed`. Вывод: если ноутбук выключен, morning Strategist на текущем VPS пока не гарантирован. Следующий инженерный шаг: выбрать один production-вариант — OpenAI API-key auth для Codex, разрешённый proxy/VPN для provider-доступа, или другой cloud runner с рабочим LLM-доступом.»
**Классификация:** fm

**Куда записать:**
- **Репо:** DS-strategy/PACK-exocortex-engineering
- **Файл:** DS-strategy/PACK-exocortex-engineering/05-failure-modes/ENG.FM.001-typical-incidents (Типовые инциденты экзокортекса).md
- **Действие:** добавить новый раздел в существующий файл

**Совместимость:**
- **Результат:** уточняет
- **Проверено:** DS-strategy/PACK-exocortex-engineering/00-pack-manifest (Манифест Pack инженерных работ).md; DS-strategy/PACK-exocortex-engineering/05-failure-modes/ENG.FM.001-typical-incidents (Типовые инциденты экзокортекса).md; DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.021-strategist-24x7-runtime-contract (Контракт 24x7 исполнения Strategist).md; DS-strategy/PACK-exocortex-engineering/04-work-products/ENG.WP.042-canonical-route-auth-independence (Auth-независимость канонических маршрутов).md

**Готовый текст (ready-to-commit):**

~~~markdown
### FM-07: VPS runner жив, но provider-plane недоступен для LLM execution

**Симптом:** scheduler, git push и runtime scripts на VPS работают, но morning Strategist не завершает `day-plan`, когда ноутбук выключен.
**Когда:** при попытке headless/cloud-run сценариев на VPS без подтверждённого provider access.
**Корневая причина:** infra-plane и git-plane уже доведены, но provider-plane не имеет рабочего production path:
- Codex path возвращает `403 Forbidden`;
- Claude path возвращает `403 Request not allowed`.
**Диагностика:** отдельно проверять не только timers и git push, но и реальный provider execution path для `day-plan` / `opening` сценария.
**Исправление:** выбрать один production-safe provider path для VPS:
- OpenAI API-key auth для Codex;
- разрешённый proxy/VPN;
- другой cloud runner с рабочим LLM-доступом.
**Системный фикс:** 24/7 runtime нельзя считать готовым, пока headless runner не проходит end-to-end provider execution, а не только scheduler/git smoke checks.
**Дата инцидента:** 2026-04-28
~~~

**Вердикт:** accept
**Обоснование:** Это типовой engineering failure mode на границе `runtime plane ≠ provider plane`. Capture не требует нового Pack-файла, потому что уже естественно расширяет каталог инцидентов и конкретизирует риск, описанный в `ENG.WP.021`: automation может быть green по timers и git, но still red по actual LLM execution.

---

## Сводка

| Метрика | Значение |
|---------|----------|
| Captures обработано | 4 |
| Всего кандидатов | 4 |
| Accept | 2 |
| Reject | 1 |
| Defer | 1 |
| Осталось в inbox | 0 |
