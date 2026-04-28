---
type: runtime-mode
updated: 2026-04-28 23:59:41
provider_policy: codex
provider_preference: codex
runtime_policy: split
cloud_takeover_scope: product-only
---

# Runtime Mode

## Provider Plane

- Primary provider: `codex`
- Why: `policy_codex`
- Codex: `available` (`login_ok`)
- Claude: `available` (`auth_status_ok`)

## Runtime Plane

- Local control plane: `available` (`launchctl_scheduler_loaded`)
- Cloud RAG status: `unknown` (`health_url_not_configured`)
- Cloud bot runtime: `vps`
- Runtime policy: `split`
- Cloud takeover scope: `product-only`

## Truthful Verdict

- Local agents (`strategist`, `extractor`, `scheduler`) остаются `local-primary` до отдельного runtime redesign.
- Product services (`VK-offee-rag`, `VK-offee/telegram-bot`) считаются `cloud-primary` контуром.
- Provider selection для активного runtime должен брать `codex`, пока он доступен.
- Если primary provider станет недоступен, runner должен переключаться на доступный fallback-provider без ручного переписывания скриптов.
