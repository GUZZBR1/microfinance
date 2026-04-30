-- create_service.sql
-- Insert a new service for the current user
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
    {{ $json.user_phone }},
    {{ $json.client_name }},
    {{ $json.description || null }},
    {{ $json.service_date || 'CURRENT_DATE' }},
    {{ $json.service_time || null }},
    {{ $json.value }},
    0,
    'agendado',
    'nao_pago'
)
RETURNING id, client_name, service_date, service_time, value, status;
