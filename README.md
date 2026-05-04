# WhatsApp MVP Assistant

MVP of an operational assistant via WhatsApp for freelancers.

Stack:
- WhatsApp API
- n8n (backend/orchestration)
- PostgreSQL (database)

Features:
- Create service
- View today's agenda
- Mark service as completed
- Register payment
- View pending payments for completed services only

Current documented contracts:
- `create_service.sql` requires a non-blank `service_date`; blank input should fail instead of silently defaulting.
- Session `retry_count` starts at `0` and increments only on actual retry handling.
- Pending payments apply only to completed services, not future scheduled work.
- Seed SQL is for development/test reseeding only, not runtime n8n execution.
- The repo documents static SQL review evidence, but not a committed PostgreSQL smoke test or n8n end-to-end proof.

Rules:
- Do not create any additional files or folders
- Do not modify anything else
- Do not install dependencies
- Only execute the steps above
