-- Seed test data for WhatsApp MVP
-- Cleanup first (safe to re-run in development/test only).
-- Ordered explicitly to avoid TRUNCATE ... CASCADE: services depends on users; user_sessions has no foreign keys.
TRUNCATE TABLE services, user_sessions, users RESTART IDENTITY;

-- ============================================
-- USERS
-- ============================================
INSERT INTO users (phone, name) VALUES
    ('5500000000001', 'Cliente Teste 1'),
    ('5500000000002', 'Cliente Teste 2'),
    ('5500000000003', 'Cliente Teste 3')
ON CONFLICT (phone) DO NOTHING;

-- ============================================
-- SERVICES
-- ============================================
INSERT INTO services (user_phone, client_name, description, service_date, service_time, value, paid_amount, status, payment_status) VALUES

-- AGENDADO / NAO_PAGO (futuro, não pago)
-- 1: Usuario Teste 1
('5500000000001', 'Cliente Teste 1', 'Troca de disjuntor', CURRENT_DATE + 3, '09:00', 150.00, 0, 'agendado', 'nao_pago'),

-- 2: Usuario Teste 1
('5500000000001', 'Cliente Teste 1', 'Instalação de ventilador de teto', CURRENT_DATE + 7, '14:30', 200.00, 0, 'agendado', 'nao_pago'),

-- 3: Usuario Teste 2
('5500000000002', 'Cliente Teste 2', 'Manutenção ar condicionado split', CURRENT_DATE + 5, '10:00', 350.00, 0, 'agendado', 'nao_pago'),

-- 4: Usuario Teste 2 (sem horario)
('5500000000002', 'Cliente Teste 2', 'Conserto de geladeira', CURRENT_DATE + 10, NULL, 280.00, 0, 'agendado', 'nao_pago'),

-- FEITO / NAO_PAGO (passado, não pago)
-- 5: Usuario Teste 1
('5500000000001', 'Cliente Teste 1', 'Conserto de tomada', CURRENT_DATE - 5, '08:00', 80.00, 0, 'feito', 'nao_pago'),

-- 6: Usuario Teste 2
('5500000000002', 'Cliente Teste 2', 'Instalação de câmera', CURRENT_DATE - 3, '15:00', 450.00, 0, 'feito', 'nao_pago'),

-- FEITO / PARCIAL (pago parcialmente)
-- 7: Usuario Teste 1
('5500000000001', 'Cliente Teste 1', 'Troca de fiação geral', CURRENT_DATE - 10, '07:30', 500.00, 250.00, 'feito', 'parcial'),

-- 8: Usuario Teste 2
('5500000000002', 'Cliente Teste 2', 'Manutenção preventiva', CURRENT_DATE - 7, '13:00', 180.00, 90.00, 'feito', 'parcial'),

-- FEITO / PAGO (pago totalmente)
-- 9: Usuario Teste 1
('5500000000001', 'Cliente Teste 1', 'Instalação de luminária', CURRENT_DATE - 15, '09:30', 120.00, 120.00, 'feito', 'pago'),

-- 10: Usuario Teste 2
('5500000000002', 'Cliente Teste 2', 'Conserto de máquinas', CURRENT_DATE - 20, '08:00', 600.00, 600.00, 'feito', 'pago'),

-- 11: Usuario Teste 3
('5500000000003', 'Cliente Teste 3', 'Limpeza pesada pós-obra', CURRENT_DATE - 2, '07:00', 350.00, 350.00, 'feito', 'pago'),

-- 12: Usuario Teste 3
('5500000000003', 'Cliente Teste 3', 'Limpeza de vidros externos', CURRENT_DATE - 1, NULL, 180.00, 180.00, 'feito', 'pago'),

-- HOJE
-- 13: Usuario Teste 1 (hoje, não pago)
('5500000000001', 'Cliente Teste 1', 'Troca de interruptor', CURRENT_DATE, '11:00', 90.00, 0, 'agendado', 'nao_pago'),

-- 14: Usuario Teste 3 (hoje, pago)
('5500000000003', 'Cliente Teste 3', 'Limpeza mensal escritório', CURRENT_DATE, '08:00', 250.00, 250.00, 'feito', 'pago');
