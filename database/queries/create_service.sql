-- create_service.sql
-- Bootstrap the current user row, then insert a new service for that user
-- Not idempotent: each execution creates a new service row
WITH service_input AS (
    SELECT
        '{{ $("WhatsApp Trigger").item.json.from }}'::text AS user_phone,
        NULLIF('{{ JSON.stringify($json.client_name || "").replace(/'/g, "''") }}', '""')::jsonb #>> '{}' AS client_name,
        NULLIF('{{ JSON.stringify($json.description || "").replace(/'/g, "''") }}', '""')::jsonb #>> '{}' AS description,
        NULLIF(BTRIM('{{ $json.service_date || "" }}'), '')::date AS service_date,
        NULLIF('{{ $json.service_time || "" }}', '')::time AS service_time,
        {{ $json.value }}::numeric(10,2) AS value
),
bootstrap_user AS (
    INSERT INTO users (phone)
    SELECT user_phone
    FROM service_input
    ON CONFLICT (phone) DO UPDATE
    SET phone = EXCLUDED.phone
    RETURNING phone
)
INSERT INTO services (
    user_phone,
    client_name,
    description,
    service_date,
    service_time,
    value,
    paid_amount,
    status,
    payment_status
)
SELECT
    b.phone,
    s.client_name,
    s.description,
    s.service_date,
    s.service_time,
    s.value,
    0,
    'agendado',
    'nao_pago'
FROM service_input s
JOIN bootstrap_user b ON b.phone = s.user_phone
RETURNING id, client_name, service_date, service_time, value, status;
