-- list_pending.sql
-- List all unpaid or partially paid services for the current user
SELECT
    id,
    client_name,
    service_date,
    service_time,
    value,
    paid_amount,
    status,
    payment_status
FROM services
WHERE user_phone = '{{ $("WhatsApp Trigger").item.json.from }}'
  AND payment_status != 'pago'
ORDER BY service_date ASC, service_time ASC NULLS LAST;
