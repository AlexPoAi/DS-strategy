---
type: work-package-context
id: WP-27
created: 2026-03-24
status: in_progress
budget: 3h
depends_on: WP-26
---

# РП#27: Truthful close-flow и единый source-of-truth для протоколов

## Почему это отдельный РП

После WP-23…WP-26 стал виден главный архитектурный разрыв: система ссылается на протоколы закрытия как будто они живут в одном месте, а фактически template source, runtime mirror, backup и реальный `close-task.sh` расходятся. Из-за этого появляются ложные ссылки, путаница в навигации и риск ложного понимания того, как действительно работает закрытие дня и закрытие WP.

## Цель

Сделать один устойчивый и truthful вариант, в котором:
- есть один canonical source-of-truth для `protocol-open/work/close`;
- runtime mirror и backup явно отличены от source-of-truth;
- `CLAUDE.md`, navigation, validator и docs не содержат ложных ссылок;
- `close-task.sh` согласован с реальным close contract, а не живёт параллельно с другой правдой.

## Что нужно исправить

### 1. Source-of-truth protocol files
Закрепить как canonical source:
- `FMT-exocortex-template/memory/protocol-open.md`
- `FMT-exocortex-template/memory/protocol-work.md`
- `FMT-exocortex-template/memory/protocol-close.md`

### 2. Явно развести три уровня
- Canonical source — template memory
- Runtime mirror — `~/.claude/projects/<slug>/memory/`
- Backup snapshot — `DS-strategy/exocortex/`

### 3. Убрать ложные ссылки
Убрать двусмысленные или ложные path assumptions вида `~/Github/memory/...`, если такого реального пути нет.

### 4. Согласовать close-flow
Привести `close-task.sh` и `protocol-close.md` к одной модели:
- либо runtime следует documented contract;
- либо documented contract переписан под truthful runtime.

### 5. Закрыть drift в navigation / MEMORY / validate-template
- validator должен проверять все базовые protocol files;
- navigation и MEMORY должны согласованно показывать входные точки;
- backup semantics должны быть описаны честно.

## Границы пакета

### Входит
- protocol path model
- truthful close contract
- navigation / docs / validator alignment
- close-task path and backup semantics

### Не входит
- продолжение nightly redesign из второго окна
- новые правки scheduler/daily-report вне close-flow
- консолидация VK-offee trigger boundaries

## Критерий завершения WP-27

- Нет ложных ссылок на несуществующий `~/Github/memory/...`
- Ясно различены canonical source / runtime mirror / backup snapshot
- `protocol-close.md` и `close-task.sh` больше не противоречат друг другу по базовому contract
- Validator проверяет полный набор protocol files
- Navigation и MEMORY согласованы по протоколам
- Truthful close проходит без post-close dirty state из-за самого close-flow

## Следующий РП

**WP-28** — end-to-end acceptance run: открыть день, пройти критические сценарии и truthfully закрыть день без расхождения между status layer, runtime и close-flow.
