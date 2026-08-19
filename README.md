# PII Intake Anonymization Scrubber

Offline PII scrubber / pseudonymizer for local file trees — replaces common identifiers with stable tokens using an encrypted mapping.

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/alkitect/?hidefeed=true&widget=true&embed=true)

## What this does

It helps you safely process exports where PII may be embedded in free text (emails, usernames, org names, IPs, etc.).

It runs `scripts/anonymize_intake.py` to scan one or more input files/directories and write scrubbed outputs while keeping replacements stable across runs via an encrypted `./.local/pii-map.json`.

**Safe by default:** start with `--summary` (detect-only; no output/map writes) or `--dry-run` (scrub without writing). Only run a real scrub when you’ve set your map key.

## Who this is for

- **In:** people who need offline, local PII pseudonymization for testing, validation, and sharing artifacts
- **In:** workflows that must keep stable tokenization across multiple runs (same input patterns → same pseudonyms)
- **Not for:** production de-identification pipelines that require formal compliance guarantees

## Quick start

```bash
git clone https://github.com/alkitect/pii-intake-scrubber.git
cd pii-intake-scrubber

./scripts/install-to-local.sh

python -m pip install -r requirements-pii.txt pytest

mkdir -p input output

# 1) Detect-only (no map key required)
pii-intake-scrubber input --summary

# 2) Real scrub (writes scrubbed output + updates encrypted map)
#    (set your key first; see Configure)
pii-intake-scrubber input
```

**What you installed:** wrappers `pii-intake-scrubber` and `verify-pii-intake-scrubber` in `~/.local/bin`.

**Stay safe before enabling:** run `--summary` first; keep `PII_MAP_KEY` secret until you’ve confirmed outputs look right.

**Needs:**
- Python 3 + `pip`
- No network required at intake time (tool is offline)

## Check it works

Good output means: `verify-pii-intake-scrubber` exits 0.

```bash
verify-pii-intake-scrubber
```

Maintainers: `./scripts/ci-check.sh`.

## Uninstall

```bash
./scripts/uninstall-from-local.sh
```

## Configure

Set the encryption key used for `./.local/pii-map.json`:

- `PII_MAP_KEY` (raw Fernet key)
- `PII_MAP_KEY_FILE` (path to a file containing the Fernet key)

Optional NER extras:
- `requirements-pii-ner.txt` adds Presidio/spaCy; NER is off by default (use `--ner` to opt in).

## Limits & safety

This tool can rewrite your local files if you run it in non-`--dry-run` / non-`--summary` modes. Scope:

- **Platform:** offline, local file processing (CLI defaults to `input`/`output`)
- **Cursor hooks:** `.cursor/hooks/` use an `inbox/raw` intake workflow for agent safety; wire them in your editor if you adopt that layout
- **Kill-switch:** use `--dry-run` / `--summary` to prevent output/map writes; run `./scripts/uninstall-from-local.sh` to remove installed wrappers
- **Defaults:** detect-only supported; real scrub requires an encryption key for saving the map
- **Tradeoffs:** stable tokenization requires a persistent encrypted map; deleting `./.local/pii-map.json` will change pseudonyms

- This GitHub repo is the release source for tagged releases and public docs — see [CONTRIBUTING.md](CONTRIBUTING.md)

## License

MIT — see [LICENSE](LICENSE).

Optional tip jar: [ko-fi.com/alkitect](https://ko-fi.com/alkitect/?hidefeed=true&widget=true&embed=true)

