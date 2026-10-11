# NV$ wallet and payments integration — proposed

Money is **authoritative only on OpenGenesisLINK server services**. The
viewer may show balances, history and transfer confirmations, but must never
calculate a trustworthy balance or grant debit permission by itself.

## Planned flows

1. Discover and authenticate a region/grid-scoped wallet capability.
2. Read wallet currency identifier, precision, current server balance and
   transaction cursor. Show stale-data indicator if disconnected.
3. For transfers, submit target UUID, amount, idempotency key and optional
   memo with explicitly confirmed user intent.
4. Server performs all access checks, account UUID validation, anti-replay,
   balance checks, rate limiting and immutable audit record.
5. Display returned transaction receipt; do not infer success from HTTP 202
   or a UI animation alone.

No operator UUID, master-bank secret, signing key or privileged simulator
credentials belong inside an LSL script or viewer configuration.
Legacy llGiveMoney and debit permissions are independent protocol concerns
requiring dedicated end-to-end tests.

**Not implemented.** See [PROTOCOL.md](PROTOCOL.md).
