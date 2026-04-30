-- clear_session.sql
-- Clear the current user's pending AI session
DELETE FROM user_sessions
WHERE user_phone = '{{ $("WhatsApp Trigger").item.json.from }}';
