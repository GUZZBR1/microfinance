-- complete_service.sql
-- Mark a service as completed
UPDATE services
SET status = 'feito'
WHERE id = {{ $json.service_id }}::integer
  AND user_phone = '{{ $("WhatsApp Trigger").item.json.from }}'
  AND status != 'feito'
RETURNING id, client_name, status;
