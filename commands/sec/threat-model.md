---
description: "Security: STRIDE-lite threat model of a feature (assets, entry points, abuse cases, required controls) into THREAT_MODEL.md"
argument-hint: "<feature slug or description>"
---

**Feature folder:** `docs/features/<slug>/` in the current project. If the first word(s) of the arguments match an existing folder there, use it; otherwise treat the arguments as a description (the agent writes `docs/security/THREAT_MODEL-<slug>.md`).

Use the **security-auditor** agent, operation **threat-model**, for: $ARGUMENTS

If the report ends with a fenced block and `Save to: <path>`, write that block to the path in the project.

Relay the threat count and the required controls. Offer to take missing controls to the architect as spec requirements (/arch:update) and any SEC-# findings to `/sec:audit` hand-off.
