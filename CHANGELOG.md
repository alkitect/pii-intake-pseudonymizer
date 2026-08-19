# Changelog

All notable changes to this project are documented here. Format follows [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

### Added

- Opt-in technical scrub: `--also-machines`, `--also-paths`, `--also-commands`, `--also-certificates`, and **`--also-technical`** bundle (default off)
- Documentation set: getting started, architecture (C4), ADRs, CLI reference, security guide
- `SECURITY.md`, examples index
- Public extract renamed from `pii-intake-scrubber` to `pii-intake-pseudonymizer`

### Removed

- Cross-repo product comparison and ServiceNow-layout commit-gate docs (`product-comparison.md`, `commit-gate.md`, `pii_commit_gate.py`)

### Fixed

- Doc review: key path platform defaults, `--report` callout, `--copy-to` example, ci-check doc file gate
- Standalone docs: no references to sibling ServiceNow variant repo

## [0.1.0] - TBD

### Added

- Offline CLI pseudonymizer for generic `input/` → `output/` layouts
- Hybrid detection: stdlib regex/harvest + opt-in Presidio NER (`--ner`)
- Encrypted map at rest with key separation ([ADR-002](docs/decisions/ADR-002-map-encryption-key-separation.md))
- Detect-only `--summary` and agent-safe default stdout
- Install/verify wrappers and `ci-check.sh` release gate

[Unreleased]: https://github.com/alkitect/pii-intake-pseudonymizer/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/alkitect/pii-intake-pseudonymizer/releases/tag/v0.1.0
