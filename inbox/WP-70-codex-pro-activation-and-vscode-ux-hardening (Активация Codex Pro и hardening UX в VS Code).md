---
id: WP-70
title: "Codex Pro activation and VS Code UX hardening"
status: active
priority: critical
owner: "Code Engineer"
created: 2026-04-19
updated: 2026-04-19
---

# Контекст

Подписка Codex Pro активирована. Нужен стабильный ежедневный UX: быстрый запуск агента в VS Code, устойчивость после перезапуска/VPN-flap и рабочий мультимодальный контур для визуалов.

# Цель

Сделать Codex основным рабочим интерфейсом без UI-конфликтов и встроить Pro-возможности (включая генерацию изображений) в операционный контур.

# Scope

1. Codex-first запуск из `~/Github` без Welcome-залипания.
2. One-click/new-hotkey сценарий `New Codex Agent`.
3. Устранение конфликтов AI-расширений в VS Code.
4. Протокол image-workflows для документов/карточек/отчётов.
5. Проверка устойчивости после reload/restart/VPN flap.

# Acceptance

1. В новом окне VS Code новый Codex чат открывается ≤ 2 клика (или 1 hotkey).
2. После `Developer: Reload Window` Codex остаётся рабочим.
3. В `INBOX`/рабочих продуктах есть минимум 1 артефакт с использованием image-workflow.
4. Операционный отчёт содержит ссылку на визуальный артефакт, а не только текст.

# Next slice

1. Довести status-check для `loading model` зависаний и добавить recovery-runbook.
2. Описать naming/storage стандарт для визуалов (где лежат, как ссылаться в отчётах).
