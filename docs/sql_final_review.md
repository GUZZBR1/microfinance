# SQL Final Review

## Summary

Reviewed the initial schema, seed data, service queries, payment queries, financial summary query, and user session queries before n8n integration.

Files reviewed:

- `database/migrations/001_initial_schema.sql`
- `database/seeds/001_seed_test_data.sql`
- `database/queries/create_service.sql`
- `database/queries/list_today.sql`
- `database/queries/complete_service.sql`
- `database/queries/register_payment.sql`
- `database/queries/list_pending.sql`
- `database/queries/financial_summary_today.sql`
- `database/queries/get_session.sql`
- `database/queries/upsert_session.sql`
- `database/queries/increment_session_retry.sql`
- `database/queries/clear_session.sql`

## Issues Found

- Some n8n text expressions were not quoted, which would make SQL invalid or unsafe to copy into PostgreSQL nodes.
- `create_service.sql` handled optional date/time fields with raw expressions that could render invalid SQL when values were present or missing.
- `create_service.sql` did not explicitly document that it is not idempotent.
- `paid_amount`, `status`, `payment_status`, `retry_count`, and `updated_at` had defaults but were still nullable in the initial schema.
- Runtime metadata under `.omx/` and `.omc/` was tracked by Git.
- Seed data used realistic names and phone numbers.

## Fixes Applied

- Updated runtime service queries to use `{{ $("WhatsApp Trigger").item.json.from }}` as the source of `user_phone`.
- Quoted text/date/time n8n expressions correctly for PostgreSQL execution.
- Added safe optional handling for:
  - `description`
  - `service_date`
  - `service_time`
- Cast numeric fields as numeric/integer where appropriate.
- Documented `create_service.sql` as non-idempotent.
- Tightened schema nullability for payment state and session retry metadata:
  - `paid_amount not null default 0`
  - `status not null default 'agendado'`
  - `payment_status not null default 'nao_pago'`
  - `retry_count not null default 0`
  - `updated_at not null default now()`
- Removed `.omx/` and `.omc/` runtime metadata from Git tracking and added both paths to `.gitignore`.
- Replaced seed names and phone numbers with clearly fake test data:
  - `Cliente Teste 1` / `5500000000001`
  - `Cliente Teste 2` / `5500000000002`
  - `Cliente Teste 3` / `5500000000003`

## Checklist Result

- User isolation: runtime SELECT/UPDATE/DELETE queries filter by `user_phone`.
- Schema: constraints validate phone/client fields, service values, paid amount bounds, service status, and payment status.
- Payments: partial/full payments are supported; invalid non-positive payments are ignored; `LEAST()` prevents overpayment; `CASE` derives payment status.
- Idempotency:
  - SELECT queries are idempotent.
  - `create_service.sql` is intentionally not idempotent.
  - `complete_service.sql` is conditionally idempotent with `status != 'feito'`.
  - `clear_session.sql` can be safely repeated.
- n8n compatibility: text values are quoted or dollar-quoted, numeric values remain unquoted and cast, optional fields are handled.
- MVP simplicity: no new tables, triggers, functions, ORM assumptions, backend API assumptions, or n8n Data Tables.

## Remaining Notes / Risks

- `database/seeds/001_seed_test_data.sql` intentionally deletes and recreates fake test data globally. It should only be run in development/test environments, not as an n8n runtime query.
- Text values are prepared for MVP n8n copy/paste usage. For production hardening, prefer n8n PostgreSQL query parameters over direct expression interpolation.
- n8n should stop or cancel the AI retry flow when `retry_count >= 2`.
- `clear_session.sql` should be called after successful completion or cancellation.

## n8n Readiness

The SQL is ready for MVP n8n PostgreSQL node integration, with the seed file reserved for local/test setup only.
