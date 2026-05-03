-- create_service.sql
-- Bootstrap the current user row, then insert a new service for that user
-- Not idempotent: each execution creates a new service row
WITH service_input AS (
    SELECT
        '{{ $("WhatsApp Trigger").item.json.from }}'::text AS user_phone,
        NULLIF($n8n${{ $json.client_name || "" }}$n8n$, '')::text AS client_name,
        NULLIF($n8n${{ $json.description || "" }}$n8n$, '')::text AS description,
        COALESCE(NULLIF('{{ $json.service_date || "" }}', '')::date, CURRENT_DATE) AS service_date,
        NULLIF('{{ $json.service_time || "" }}', '')::time AS service_time,
        {{ $json.value }}::numeric(10,2) AS value
),
bootstrap_user AS (
    INSERT INTO users (phone)
    SELECT user_phone
    FROM service_input
    ON CONFLICT (phone) DO NOTHING
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
VALUES (
    '{{ $("WhatsApp Trigger").item.json.from }}',
    NULLIF($n8n${{ $json.client_name || "" }}$n8n$, ''),
    NULLIF($n8n${{ $json.description || "" }}$n8n$, ''),
    NULLIF(BTRIM('{{ $json.service_date || "" }}'), '')::date,
    NULLIF('{{ $json.service_time || "" }}', '')::time,
    {{ $json.value }}::numeric(10,2),
    0,
    'agendado',
    'nao_pago'
FROM service_input
RETURNING id, client_name, service_date, service_time, value, status;
