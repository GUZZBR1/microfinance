-- upsert_session.sql
-- Create or update the current user's pending AI session
WITH session_input AS (
    SELECT
        '{{ $("WhatsApp Trigger").item.json.from }}'::text AS user_phone,
        NULLIF($${{ $json.pending_intent || "" }}$$, '')::text AS pending_intent,
        ARRAY(
            SELECT jsonb_array_elements_text($${{ JSON.stringify($json.missing_fields || []) }}$$::jsonb)
        )::text[] AS missing_fields,
        {{ $json.reset_retry || false }}::boolean AS reset_retry
)
INSERT INTO user_sessions (
    user_phone,
    pending_intent,
    missing_fields,
    retry_count,
    updated_at
)
SELECT
    user_phone,
    pending_intent,
    missing_fields,
    1,
    now()
FROM session_input
ON CONFLICT (user_phone) DO UPDATE
SET
    pending_intent = EXCLUDED.pending_intent,
    missing_fields = EXCLUDED.missing_fields,
    retry_count = CASE
        WHEN (SELECT reset_retry FROM session_input) THEN 1
        ELSE user_sessions.retry_count
    END,
    updated_at = now()
RETURNING
    user_phone,
    pending_intent,
    missing_fields,
    retry_count,
    updated_at;
