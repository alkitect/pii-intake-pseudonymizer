# Publish notes

Before tag: README must pass `./scripts/ci-check.sh`. See [CONTRIBUTING.md](../CONTRIBUTING.md) § README conventions.

First public tag: v0.1.0

Repo URL: `https://github.com/alkitect/pii-intake-pseudonymizer`

## GitHub About

| Field | Value |
|-------|--------|
| Description | Offline PII intake pseudonymizer — stable token replacement for local text files with an encrypted map |
| Website | _(empty — tip via README Ko-fi badge)_ |
| Topics | `pii`, `privacy`, `pseudonymization`, `security`, `offline`, `python` |

```bash
gh repo create pii-intake-pseudonymizer --public --source=. --remote=origin
gh repo edit alkitect/pii-intake-pseudonymizer \
  --description "Offline PII intake pseudonymizer — stable token replacement for local text files with an encrypted map" \
  --homepage "" \
  --add-topic pii --add-topic privacy --add-topic pseudonymization --add-topic security \
  --add-topic offline --add-topic python
```

Sidebar (manual if shown): Releases ✓ · Packages ✗ · Deployments ✗

## Linux monorepo submodule (human gate)

After GitHub is live:

```bash
cd /path/to/Linux
git submodule add -b v0.1.0 https://github.com/alkitect/pii-intake-pseudonymizer.git public/pii-intake-pseudonymizer
```

Pin submodule gitlink to tag `v0.1.0`, not `main`.
