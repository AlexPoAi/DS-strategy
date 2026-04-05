---
type: engineering-work-product
wp_id: ENG.WP.017
title: Автопереиндексация RAG после push в VK-offee
date: 2026-04-05
status: done
priority: critical
linked_inbox: ENGINEERING
author: Environment Engineer (Codex)
---

# ENG.WP.017 — Автопереиндексация RAG после push в VK-offee

## Контекст

После стабилизации always-on контура на VPS подтверждён production gap:

- `vk-rag-api` и `vk-telegram-bot` живы;
- `VK-offee` на сервере синхронизируется с GitHub;
- но ChromaDB не переиндексируется автоматически после push в Pack.

Итог: бот может отвечать по устаревшей базе знаний, даже если код и документы уже обновлены в `main`.

## Цель

Сделать server-side механизм, который:

1. периодически проверяет `origin/main` для `VK-offee`;
2. если `HEAD` Pack изменился — делает `git pull --ff-only`;
3. запускает `indexer.py` против актуального Pack;
4. после успешной переиндексации перезапускает `vk-rag-api`;
5. не запускается параллельно сам с собой.

## Выбранный механизм

Не webhook и не post-receive hook, а `systemd oneshot + timer` на VPS.

Причины:

- это надёжнее и прозрачнее в сопровождении;
- не требует отдельного входящего HTTP-контура;
- не зависит от GitHub webhook secrets;
- проще диагностируется через `systemctl status` и `journalctl`.

## Acceptance criteria

Работа считается завершённой, если:

1. на сервере есть `vk-rag-reindex.service` и `vk-rag-reindex.timer`;
2. таймер регулярно срабатывает без ручного вмешательства;
3. при отсутствии изменений в `VK-offee` сервис завершается быстро и без лишнего reindex;
4. при появлении нового коммита в `VK-offee/main` сервер:
   - подтягивает Pack,
   - переиндексирует Chroma,
   - перезапускает `vk-rag-api`;
5. повторный запуск не создаёт параллельных прогонов.

## Truthful note

Этот WP закрывает именно автопереиндексацию product RAG после изменения Pack.
Он не решает ещё:

- remote deploy для изменения самого `VK-offee-rag` кода;
- webhook-driven rollout;
- zero-downtime индексацию;
- оптимизацию RAM/OOM при полном reindex.

## Фактическая реализация

Что реально внедрено:

- в [VK-offee-rag/scripts/reindex-if-pack-changed.sh](/Users/alexander/Github/VK-offee-rag/scripts/reindex-if-pack-changed.sh) добавлен idempotent reindex-runner:
  - `git fetch` для `VK-offee`
  - `git pull --ff-only` только при новом `origin/main`
  - `flock`-lock
  - сохранение `last-pack-head`
  - остановка `vk-rag-api` на время полного `--reset`
  - повторный запуск `vk-rag-api` после завершения
- в [VK-offee-rag/deploy/systemd/vk-rag-reindex.service](/Users/alexander/Github/VK-offee-rag/deploy/systemd/vk-rag-reindex.service) и [VK-offee-rag/deploy/systemd/vk-rag-reindex.timer](/Users/alexander/Github/VK-offee-rag/deploy/systemd/vk-rag-reindex.timer) оформлен production systemd-контур
- в [VK-offee/telegram-bot/deploy.sh](/Users/alexander/Github/VK-offee/telegram-bot/deploy.sh) добавлена установка timer/service при серверном деплое
- в [VK-offee-rag/src/indexer.py](/Users/alexander/Github/VK-offee-rag/src/indexer.py) починен `--reset`: коллекция теперь удаляется до повторного создания, без конфликта embedding-function
- для VPS `72.56.4.61` добавлен `swapfile 2G`, потому что без swap полный reset-index стабильно ловил OOM на 2GB RAM

## Factual verification

Проверено на живом VPS `72.56.4.61`:

1. Первый прогон `vk-rag-reindex.service` успешно завершён
2. Проиндексировано `263` файлов
3. В Chroma после прогона `579` документов
4. `last-pack-head` записан:
   - `29709c656aa595009a1e0397e60a24efc775eb2c`
5. `vk-rag-api` после прогона автоматически поднялся обратно
6. `GET /health` после завершения вернул:
   - `{"status":"healthy","documents_indexed":579}`
7. Второй запуск без новых коммитов завершается быстро:
   - `pack unchanged since last reindex: 29709c656aa595009a1e0397e60a24efc775eb2c`

## Итог

`R-1` закрыт.

Теперь продуктовый always-on контур на VPS ведёт себя так:

- push в `VK-offee/main`
- VPS timer видит новый `origin/main`
- Pack подтягивается
- RAG переиндексируется
- `vk-rag-api` перезапускается
- повторный запуск без изменений не делает лишнюю работу
