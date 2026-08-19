# Examples

Synthetic fixture used by unit tests — safe to read (no real PII):

- [`tests/fixtures/pii-gold/nl_synthetic.md`](../../tests/fixtures/pii-gold/nl_synthetic.md) — NL-style fields the stdlib detectors target

**Typical token shapes after pseudonymization:**

- `jane@company.example` → `user_001@example.test`
- Display names → `PERSON_001`
- Org names (when `--scrub-orgs` is on) → `ORG_001`

Run detect-only on a copy under `input/`:

```bash
pii-intake-pseudonymizer input --summary
```
