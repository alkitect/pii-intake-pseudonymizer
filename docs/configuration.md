# Configuration

## Environment variables

| Variable | Purpose |
|----------|---------|
| `PII_MAP_KEY` | Raw Fernet key (url-safe base64) for encrypting `.local/pii-map.json` |
| `PII_MAP_KEY_FILE` | Path to a file containing the Fernet key — **must be outside the repo / cloud-sync root** |
| `PII_MAP_ALLOW_PLAINTEXT` | Legacy migration only; do not use in normal operation |

If neither key variable is set, the CLI looks for a platform default under:

- Windows: `%LOCALAPPDATA%/ServiceNow-PII/pii-map.key`
- Unix: `~/.config/servicenow-pii/pii-map.key`

Paths like `$HOME/.config/pii-intake/pii-map.key` are valid **examples** in docs — any location outside cloud sync is fine.

Detect-only modes (`--summary`) work without a key (`map=unavailable`). Mutating writes fail closed without a valid key.

## Config files (shipped under `config/`)

| File | Role |
|------|------|
| `pii-allowlist.txt` | Functional emails and service accounts that must **not** be replaced (one entry per line; `#` comments) |
| `pii-org-scrub.txt` | Company / product names replaced with stable `ORG_NNN` tokens when `--scrub-orgs` is on (default) |
| `pii-person-fields.json` | XML/JSON field names and CSV headers used to harvest display names into the map |
| `pii-ner.json` | Presidio entity allowlist and threshold when `--ner` is enabled |

Override paths with `--allowlist`, `--org-list`, or install copies under `~/.local/share/pii-intake-pseudonymizer/config/` after `install-to-local.sh`.

## Local artifacts (default: `./.local/`)

| Path | Purpose |
|------|---------|
| `.local/pii-map.json` | Encrypted real → token map (never commit) |
| `.local/pii-map.json.bak` | Plaintext backup during `--map-migrate` |
| `.local/pii-map-audit.jsonl` | Optional metadata-only audit (`--map-audit`) |

## Default I/O layout

| Path | Role |
|------|------|
| `input/` | Default read root when no paths are passed |
| `output/` | Default write root (mirrors relative paths from input) |

Use explicit paths or `--out` for other layouts. See [CLI reference](cli-reference.md).

## Calibration tips

1. Start with the shipped example allowlist; replace placeholders with your org’s **non-personal** mailboxes.
2. Add org/product names your exports mention to `pii-org-scrub.txt`.
3. Run `--summary` after config edits before any write pass.
4. Enable `--ner` only when free-text PERSON coverage is worth the extra install weight.

See [Architecture decisions](decisions/README.md) for why pseudonymization uses a reversible map by default.
