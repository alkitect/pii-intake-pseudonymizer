# Getting started

Offline CLI for pseudonymizing text files before you share or analyze them. Start detect-only; add a map key only when you are ready to write outputs.

## Prerequisites

- Python 3.10+ with `pip`
- Git Bash or a Unix shell for `install-to-local.sh` (Windows) or any POSIX shell (Linux/macOS)

## Install

```bash
git clone https://github.com/alkitect/pii-intake-pseudonymizer.git
cd pii-intake-pseudonymizer

./scripts/install-to-local.sh
python -m pip install -r requirements-pii.txt pytest
```

Wrappers land in `~/.local/bin`: `pii-intake-pseudonymizer`, `verify-pii-intake-pseudonymizer`.

## Day 1 — detect only (no key)

```bash
mkdir -p input output

# Put a text or markdown export under input/
echo 'Contact jane.doe@example.com for access.' > input/sample.txt

pii-intake-pseudonymizer input --summary
```

`--summary` is detect-only: redacted hit counts, no output files, no map writes. Exit code is non-zero when hits are found (`--fail-on-hits` is implied).

## Day 2 — dry run (still no durable writes)

```bash
pii-intake-pseudonymizer input --dry-run
```

Simulates token replacement in memory; does not write `output/` or update the map.

## Day 3 — real pass (key required)

Generate a Fernet key once (store outside the repo):

```bash
python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"
```

Save it to a file outside cloud sync. Platform defaults if you set nothing:

- Windows: `%LOCALAPPDATA%/ServiceNow-PII/pii-map.key`
- Linux/macOS: `~/.config/servicenow-pii/pii-map.key`

Or any path outside sync (example):

```bash
export PII_MAP_KEY_FILE="$HOME/.config/pii-intake/pii-map.key"
# or: export PII_MAP_KEY="<paste key>"

pii-intake-pseudonymizer input
```

Inspect `output/` — emails and names become stable tokens (`user_001@example.test`, `PERSON_001`, …). The encrypted mapping lives in `.local/pii-map.json`.

## Verify installation

```bash
verify-pii-intake-pseudonymizer
```

## Optional NER (Presidio)

```bash
python -m pip install -r requirements-pii-ner.txt
pii-intake-pseudonymizer input --ner --dry-run
```

NER is **off by default**. Counts report `ner=skipped` when extras are not installed.

## Troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| `map=unavailable` on `--summary` | Expected without a key | Normal for detect-only |
| Write fails without key | Real pass needs encryption key | Set `PII_MAP_KEY` or `PII_MAP_KEY_FILE` |
| `residual=…` abort, no output | High-confidence email/IBAN left | Fix source or adjust allowlist; see [Security](security.md) |
| Different tokens on second run | Map deleted or new key | Keep `.local/pii-map.json` and the same key |
| Binary files skipped | `.xlsx`, `.pdf` not pseudonymized as text | Export to CSV/text first |

## Next steps

- [Configuration](configuration.md) — allowlist, org scrub list, person-field harvest
- [CLI reference](cli-reference.md) — all flags
- [Architecture](architecture/README.md) — how components fit together
