-- list_today.sql
-- List today's services for the current user
SELECT
    id,
    client_name,
    service_date,
    service_time,
    value,
    status,
    payment_status
FROM services
WHERE user_phone = '{{ $("WhatsApp Trigger").item.json.from }}'
  AND service_date = CURRENT_DATE
ORDER BY service_time ASC NULLS LAST;
