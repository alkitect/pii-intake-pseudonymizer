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
| `--also-machines` | off | Scrub labeled hostname/machine fields (`MACHINE_NNN`) |
| `--also-paths` | off | Scrub absolute Windows/Unix paths (`PATH_NNN`) |
| `--also-commands` | off | Scrub command-like whole lines (`CMD_NNN`) |
| `--also-certificates` | off | Scrub PEM certificate blocks (`CERT_NNN`) |
| `--also-technical` | off | Enable all four technical flags above (logs/exports with hostnames, paths, shell lines, or PEM) |
| `--also-nl-id` | off | Labeled BSN (11-proef) |
| `--also-p2` / `--no-also-p2` | on | MAC, NL postcode, labeled DOB |
| `--harvest-names` / `--no-harvest-names` | on | Harvest person display names from structured fields |
| `--harvest-single-token` | off | Allow single-token display names in harvest |
| `--expand-name-parts` / `--no-expand-name-parts` | on | Also replace first/last tokens from multi-token names |
| `--scrub-orgs` / `--no-scrub-orgs` | on | Replace org names from org list |

## What is replaced

| Category | Detection scope | Replacement | Default |
|----------|-----------------|---------------|---------|
| Email | Bare addresses and `Name <email>` | `user_NNN@example.test` | on |
| Person | Harvested display names, optional NER | `PERSON_NNN` | on (harvest) |
| Phone | NL/EU-ish patterns | `PHONE_NNN` | on |
| IBAN | Checksum-valid candidates | `IBAN_NNN` | on |
| IP | IPv4/IPv6 (non-loopback, non-doc) | `203.0.113.N` / `2001:db8::…` | off (`--also-ip`) |
| Machine | Labeled `hostname:` / `host=` / `machine name:` fields | `MACHINE_NNN` | off (`--also-machines`) |
| Path | Absolute Windows paths; Unix under `/home`, `/Users`, `/tmp`, `/opt`, `/var`, `/mnt` | `PATH_NNN` | off (`--also-paths`) |
| Command | Whole lines starting with `py`, `python`, `powershell`, `git`, `curl`, etc. | `CMD_NNN` | off (`--also-commands`) |
| Certificate | Whole PEM blocks (`-----BEGIN … -----END …`) | `CERT_NNN` | off (`--also-certificates`) |
| BSN | Labeled fields (11-proef) | synthetic BSN token | off (`--also-nl-id`) |
| MAC / postcode / DOB | Patterns in `pii_detectors` | category tokens | on (`--also-p2`) |

Use **`--also-technical`** when exports contain infrastructure noise (hostnames, paths, shell snippets, PEM). Technical categories are **not** included in the high-confidence fail-write gate (email + checksum IBAN). A run with `residual=0` can still leave hostnames, paths, commands, or PEM unless you pass the technical flags.

### Limitations (technical scrub)

- **Commands:** line-start prefixes only; mid-line commands are not scrubbed
- **Unix paths:** only `/home`, `/Users`, `/tmp`, `/opt`, `/var`, `/mnt` prefixes
- **Residuals:** technical categories are replace-only when flagged; they do not trigger fail-write on residual scan

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

# Infra-heavy exports (logs, PEM, shell snippets)
pii-intake-pseudonymizer input --also-technical

# Migrate plaintext map
pii-intake-pseudonymizer --map-migrate
```
