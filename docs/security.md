# Security

This tool helps **reduce accidental PII exposure** in local files. It is **not** a certified de-identification or compliance product.

## What it protects

- Common identifiers in **text** exports: emails, harvested person names, phones, IBAN (checksum-valid), optional IP/BSN/MAC/postcode/DOB
- **Stable teaching tokens** via an encrypted reversible map (pseudonymization)
- **Fail-closed** abort before write when high-confidence residuals (non-allowlisted email, checksum IBAN) remain

## What it does not protect

- Binary formats (`.xlsx`, `.pdf`) — skipped, not scrubbed
- PII already committed to git history
- Content pasted into chat before scrubbing
- Re-identification if you share **both** scrubbed files and the map key
- Full NLP coverage when `--ner` is off (`ner=skipped`)

## Pseudonymization vs anonymization

Output with a persisted map is **pseudonymization** (reversible with the key). Use `--irreversible` only when you deliberately want ephemeral tokens and **no** map write for external share. See [ADR-003](decisions/ADR-003-irreversible-no-map-mode.md).

## Key management

1. **Never** commit `.local/pii-map.json`, key files, or `.bak` maps.
2. Store `PII_MAP_KEY` / `PII_MAP_KEY_FILE` **outside** cloud-synced project folders when possible.
3. Ciphertext under sync is less useful without the key, but pre-migrate plaintext may remain in cloud **version history** — migrate early or exclude `.local` from sync.
4. Back up the key separately from the map; lost key ⇒ unreadable map.

## Operational safety modes

| Mode | Writes output | Writes map | Typical use |
|------|---------------|------------|-------------|
| `--summary` | No | No | Detect-only gate / audit |
| `--dry-run` | No | No | Preview tokenization |
| Default write | Yes | Yes | Production pseudonymization |
| `--irreversible` | Yes | No | External share without reverse table |

`--summary` **never** authorizes `--in-place`. Treat detect-only hits as a signal to fix scope or tooling, not an automatic mandate to mass-rewrite trees.

## `--report` warning

`--report` prints **original** values. Use only in an interactive human session — never in CI logs or shared terminals.

## Reporting issues

Do not open public issues with real PII. Redact samples and state which mode (`--summary`, `--dry-run`, write) and key setup you used. See [CONTRIBUTING.md](../CONTRIBUTING.md).
