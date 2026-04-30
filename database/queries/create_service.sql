-- create_service.sql
-- Insert a new service for the current user
-- Not idempotent: each execution creates a new service row
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
    COALESCE(NULLIF('{{ $json.service_date || "" }}', '')::date, CURRENT_DATE),
    NULLIF('{{ $json.service_time || "" }}', '')::time,
    {{ $json.value }}::numeric(10,2),
    0,
    'agendado',
    'nao_pago'
)
RETURNING id, client_name, service_date, service_time, value, status;
