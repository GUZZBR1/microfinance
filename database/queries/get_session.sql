-- get_session.sql
-- Get the current user's pending AI session
SELECT
    user_phone,
    pending_intent,
    missing_fields,
    retry_count,
    updated_at
FROM user_sessions
WHERE user_phone = '{{ $("WhatsApp Trigger").item.json.from }}';
