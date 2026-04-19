---
type: inbox-task
status: pending
created: 2026-04-19
priority: high
owner: engineering
---

# WP-89 — Единый реестр документов по всей базе знаний

## Зачем
Создать верхнеуровневый `DOCUMENT-REGISTRY`, который покрывает всю базу знаний, а не только отдельные Pack-контуры.

## Контекст
- Сейчас уже есть локальные реестры:
  - `VK-offee/PACK-warehouse/DOCUMENT-REGISTRY.md`
  - `VK-offee/PACK-park-development/DOCUMENT-REGISTRY.md`
  - отдельные csv/md-реестры внутри `knowledge-base`
- Нет единой master-карты, где видно:
  - какие домены существуют;
  - где их source-of-truth;
  - какие реестры полные, а какие нет;
  - где есть пробелы и дубли.

## Что сделать
1. Определить целевую архитектуру `master registry -> child registries`.
2. Описать обязательные поля для master-реестра:
   - `domain`
   - `subdomain`
   - `registry_path`
   - `source_of_truth`
   - `coverage_status`
   - `owner`
   - `last_reviewed_at`
   - `gaps`
3. Собрать первый live-slice по ключевым доменам:
   - warehouse
   - operations
   - park
   - legal
   - staff
4. Зафиксировать процесс обновления и quality gate.

## Артефакт
- master `DOCUMENT-REGISTRY`
- policy обновления
- first live-slice по ключевым доменам

## Done when
- есть единый входной реестр по всей базе;
- каждый ключевой домен связан с дочерним registry или помечен как gap;
- агент может понять структуру базы без ручного поиска по репозиторию.
