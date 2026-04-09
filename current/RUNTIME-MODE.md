---
type: runtime-mode
updated: 2026-04-09 20:28:49
provider_policy: auto
provider_preference: codex
runtime_policy: cloud-primary
cloud_takeover_scope: all-agents
---

# Runtime Mode

## Provider Plane

- Primary provider: `codex`
- Why: `both_available_preference_codex`
- Codex: `available` (`login_ok`)
- Claude: `available` (`auth_helper_ok`)

## Runtime Plane

- Local control plane: `available` (`launchctl_scheduler_loaded`)
- Cloud RAG status: `unknown` (`health_url_not_configured`)
- Cloud bot runtime: `vps`
- Runtime policy: `cloud-primary`
- Cloud takeover scope: `all-agents`

## Truthful Verdict

- Local agents (`strategist`, `extractor`, `scheduler`) переведены в `cloud-primary`; локальный dispatch должен быть standby-only.
- Product services (`VK-offee-rag`, `VK-offee/telegram-bot`) остаются `cloud-primary` контуром.
- Provider selection для активного runtime должен брать `codex`, пока он доступен.
- Если primary provider станет недоступен, runner должен переключаться на доступный fallback-provider без ручного переписывания скриптов.
