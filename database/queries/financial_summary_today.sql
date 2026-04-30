-- financial_summary_today.sql
-- Today's financial summary for the current user
SELECT
    COUNT(*) AS total_services,
    COALESCE(SUM(value), 0) AS total_value,
    COALESCE(SUM(COALESCE(paid_amount, 0)), 0) AS total_received,
    COALESCE(SUM(value - COALESCE(paid_amount, 0)), 0) AS total_pending,
    COUNT(*) FILTER (WHERE status = 'feito') AS completed_services,
    COUNT(*) FILTER (WHERE payment_status IN ('nao_pago', 'parcial')) AS pending_payment_services
FROM services
WHERE user_phone = {{ $("WhatsApp Trigger").item.json.from }}
  AND service_date = CURRENT_DATE;
