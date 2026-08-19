# CLI reference

Entry point: `pii-intake-pseudonymizer` (wrapper) or `python scripts/anonymize_intake.py`.

## Positional arguments

| Argument | Default | Description |
|----------|---------|-------------|
| `paths…` | `./input` | One or more files or directories to process |

## Output and layout

| Flag | Description |
|------|-------------|
| `--out PATH` | Output file or directory (default: mirror under `./output/`) |
| `--force-path` | Allow paths outside the default input root |
| `--in-place` | Write back to source paths (incompatible with `--out`) |
| `--copy-to DEST` | After write, copy staging into `DEST/intake-clean/` |
| `--keep-raw` | Do not delete source files after successful text write |
| `--keep-clean` | Do not prune leftover files in output staging |

## Safety and modes

| Flag | Description |
|------|-------------|
| `--dry-run` | No output or map writes |
| `--summary` | Detect-only: redacted counts; implies `--dry-run` and `--fail-on-hits`; never allows `--in-place` |
| `--per-file-summary` | Redacted per-file counts (agent-safe); implies `--dry-run` |
| `--fail-on-hits` | Exit 1 when replacements or residual emails found |
| `--fail-on-prose-damage` | Exit 1 if tokenization would replace deny-listed tokens or remove probe stopwords (over-redaction guard) |
| `--report` | Print originals (human interactive only; opts out of agent-safe default) |
| `--agent-safe` / `--no-agent-safe` | Counts-only stdout (default: on); cannot combine with `--report` |

> **`--report`** prints original PII values. Use only in a private terminal — never in CI, agent logs, or shared transcripts.

## Detection

| Flag | Default | Description |
|------|---------|-------------|
| `--ner` / `--no-ner` | off | Opt-in Presidio PERSON NER |
| `--also-ip` | off | Scrub IPv4/IPv6 |
| `--also-nl-id` | off | Labeled BSN (11-proef) |
| `--also-p2` / `--no-also-p2` | on | MAC, NL postcode, labeled DOB |
| `--harvest-names` / `--no-harvest-names` | on | Harvest person display names from structured fields |
| `--harvest-single-token` | off | Allow single-token display names in harvest |
| `--expand-name-parts` / `--no-expand-name-parts` | on | Also replace first/last tokens from multi-token names |
| `--scrub-orgs` / `--no-scrub-orgs` | on | Replace org names from org list |

## Map and crypto

| Flag | Description |
|------|-------------|
| `--map PATH` | Map file (default: `.local/pii-map.json`) |
| `--allowlist PATH` | Allowlist file |
| `--org-list PATH` | Org scrub list |
| `--map-migrate` | Encrypt legacy plaintext map (creates `.bak`); then exit |
| `--map-rollback` | Restore map from `.bak`; then exit |
| `--map-prune-unused` | Human-only: drop unused map entries then save |
| `--map-audit` / `--no-map-audit` | Append metadata line to `.local/pii-map-audit.jsonl` |
| `--irreversible` | Ephemeral tokens; no map write/update |

## Exit codes

| Code | Meaning |
|------|---------|
| 0 | Success (no hits when `--fail-on-hits` / `--summary`) |
| 1 | Residual abort, hits under gate mode, or validation error |

## Examples

```bash
# Detect-only on a folder
pii-intake-pseudonymizer ./exports --summary

# Write with NER
pii-intake-pseudonymizer input --ner

# External share without reverse map
pii-intake-pseudonymizer input --irreversible --force-path

# Copy staging into a consumer repo after write
pii-intake-pseudonymizer input --copy-to ../my-story-repo

# Migrate plaintext map
pii-intake-pseudonymizer --map-migrate
```
