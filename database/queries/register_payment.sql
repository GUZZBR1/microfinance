-- register_payment.sql
-- Register a payment for a service owned by the current user
WITH payment_input AS (
    SELECT
        {{ $json.data.id }}::integer AS service_id,
        {{ $json.data.amount }}::numeric(10,2) AS payment_amount,
        {{ $("WhatsApp Trigger").item.json.from }}::text AS user_phone
),
calculated_payment AS (
    SELECT
        s.id,
        s.user_phone,
        s.value,
        LEAST(s.value, COALESCE(s.paid_amount, 0) + p.payment_amount) AS new_paid_amount
    FROM services s
    JOIN payment_input p
      ON p.service_id = s.id
     AND p.user_phone = s.user_phone
    WHERE p.payment_amount > 0
)
UPDATE services s
SET
    paid_amount = c.new_paid_amount,
    payment_status = CASE
        WHEN c.new_paid_amount = 0 THEN 'nao_pago'
        WHEN c.new_paid_amount > 0 AND c.new_paid_amount < c.value THEN 'parcial'
        WHEN c.new_paid_amount = c.value THEN 'pago'
    END
FROM calculated_payment c
WHERE s.id = c.id
  AND s.user_phone = c.user_phone
RETURNING
    s.id,
    s.client_name,
    s.value,
    s.paid_amount,
    s.payment_status;
