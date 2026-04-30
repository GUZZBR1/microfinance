-- complete_service.sql
-- Mark a service as completed
UPDATE services
SET status = 'feito'
WHERE id = {{ $json.service_id }}
  AND user_phone = {{ $json.user_phone }}
  AND status != 'feito'
RETURNING id, client_name, status;
