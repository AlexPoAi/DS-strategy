---
type: runtime-mode
updated: 2026-04-08 09:00:02
provider_policy: auto
provider_preference: codex
runtime_policy: split
cloud_takeover_scope: product-only
---

# Runtime Mode

## Provider Plane

- Primary provider: `claude`
- Why: `only_claude_available`
- Codex: `missing` (`codex_cli_not_found`)
- Claude: `available` (`auth_helper_ok`)

## Runtime Plane

- Local control plane: `available` (`launchctl_scheduler_loaded`)
- Cloud RAG status: `unknown` (`health_url_not_configured`)
- Cloud bot runtime: `declared`
- Runtime policy: `split`
- Cloud takeover scope: `product-only`

## Truthful Verdict

- Local agents (`strategist`, `extractor`, `scheduler`) остаются `local-primary` до отдельного runtime redesign.
- Product services (`VK-offee-rag`, `VK-offee/telegram-bot`) считаются `cloud-primary` контуром.
- Provider selection для локальных агентов должен брать `claude`, пока он доступен.
- Если primary provider станет недоступен, runner должен переключаться на доступный fallback-provider без ручного переписывания скриптов.
