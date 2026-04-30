-- increment_session_retry.sql
-- Increment the current user's retry count
UPDATE user_sessions
SET
    retry_count = COALESCE(retry_count, 0) + 1,
    updated_at = now()
WHERE user_phone = '{{ $("WhatsApp Trigger").item.json.from }}'
RETURNING retry_count;
