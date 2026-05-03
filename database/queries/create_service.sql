-- create_service.sql
-- Bootstrap the current user row, then insert a new service for that user
-- Not idempotent: each execution creates a new service row
WITH raw_service_input AS (
    SELECT
        '{{ JSON.stringify($("WhatsApp Trigger").item.json.from ?? "").replace(/'/g, "''") }}'::jsonb #>> '{}' AS user_phone_raw,
        '{{ JSON.stringify($json.service_date || "").replace(/'/g, "''") }}'::jsonb #>> '{}' AS service_date_raw,
        '{{ JSON.stringify($json.service_time || "").replace(/'/g, "''") }}'::jsonb #>> '{}' AS service_time_raw,
        '{{ JSON.stringify($json.value ?? "").replace(/'/g, "''") }}'::jsonb #>> '{}' AS value_raw
),
service_input AS (
    SELECT
        NULLIF(BTRIM(r.user_phone_raw), '') AS user_phone,
        NULLIF('{{ JSON.stringify($json.client_name || "").replace(/'/g, "''") }}', '""')::jsonb #>> '{}' AS client_name,
        NULLIF('{{ JSON.stringify($json.description || "").replace(/'/g, "''") }}', '""')::jsonb #>> '{}' AS description,
        NULLIF(BTRIM('{{ $json.service_date || "" }}'), '')::date AS service_date,
        NULLIF(BTRIM('{{ $json.service_time || "" }}'), '')::time AS service_time,
        {{ $json.value }}::numeric(10,2) AS value
),
bootstrap_user AS (
    INSERT INTO users (phone)
    SELECT user_phone
    FROM service_input
    ON CONFLICT (phone) DO NOTHING
    RETURNING phone
),
resolved_user AS (
    SELECT phone
    FROM bootstrap_user
    UNION ALL
    SELECT u.phone
    FROM users u
    JOIN service_input s ON u.phone = s.user_phone
    WHERE NOT EXISTS (SELECT 1 FROM bootstrap_user)
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
JOIN resolved_user b ON b.phone = s.user_phone
RETURNING id, client_name, service_date, service_time, value, status;
