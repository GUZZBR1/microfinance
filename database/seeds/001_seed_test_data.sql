-- Seed test data for WhatsApp MVP
-- Cleanup first (safe to re-run)
DELETE FROM services;
DELETE FROM user_sessions;
DELETE FROM users;

-- ============================================
-- USERS
-- ============================================
INSERT INTO users (phone, name) VALUES
    ('5511999998888', 'Carlos Silva'),
    ('5511988887777', 'Ana Oliveira'),
    ('5511977776666', 'Pedro Santos')
ON CONFLICT (phone) DO NOTHING;

-- ============================================
-- SERVICES
-- ============================================
INSERT INTO services (user_phone, client_name, description, service_date, service_time, value, paid_amount, status, payment_status) VALUES

-- AGENDADO / NAO_PAGO (futuro, não pago)
-- 1: Eletricista - Carlos
('5511999998888', 'João Mendes', 'Troca de disjuntor', CURRENT_DATE + 3, '09:00', 150.00, 0, 'agendado', 'nao_pago'),

-- 2: Eletricista - Carlos
('5511999998888', 'Maria Souza', 'Instalação de ventilador de teto', CURRENT_DATE + 7, '14:30', 200.00, 0, 'agendado', 'nao_pago'),

-- 3: Técnico - Ana
('5511988887777', 'Roberto Lima', 'Manutenção ar condicionado split', CURRENT_DATE + 5, '10:00', 350.00, 0, 'agendado', 'nao_pago'),

-- 4: Técnica - Ana (sem horário)
('5511988887777', 'Fernanda Costa', 'Conserto de geladeira', CURRENT_DATE + 10, NULL, 280.00, 0, 'agendado', 'nao_pago'),

-- FEITO / NAO_PAGO (passado, não pago)
-- 5: Eletricista - Carlos
('5511999998888', 'Paulo Henrique', 'Conserto de tomada', CURRENT_DATE - 5, '08:00', 80.00, 0, 'feito', 'nao_pago'),

-- 6: Técnico - Ana
('5511988887777', 'Lucia Ferreira', 'Instalação de câmera', CURRENT_DATE - 3, '15:00', 450.00, 0, 'feito', 'nao_pago'),

-- FEITO / PARCIAL (pago parcialmente)
-- 7: Eletricista - Carlos
('5511999998888', 'Marcos Vinícius', 'Troca de fiação geral', CURRENT_DATE - 10, '07:30', 500.00, 250.00, 'feito', 'parcial'),

-- 8: Técnica - Ana
('5511988887777', 'Juliana Rocha', 'Manutenção preventiva', CURRENT_DATE - 7, '13:00', 180.00, 90.00, 'feito', 'parcial'),

-- FEITO / PAGO (pago totalmente)
-- 9: Eletricista - Carlos
('5511999998888', 'Tiago Pereira', 'Instalação de luminária', CURRENT_DATE - 15, '09:30', 120.00, 120.00, 'feito', 'pago'),

-- 10: Técnico - Ana
('5511988887777', 'Beatriz Lopes', 'Conserto de máquinas', CURRENT_DATE - 20, '08:00', 600.00, 600.00, 'feito', 'pago'),

-- 11: Limpador - Pedro
('5511977776666', 'Sandra Cristina', 'Limpeza pesada pós-obra', CURRENT_DATE - 2, '07:00', 350.00, 350.00, 'feito', 'pago'),

-- 12: Limpador - Pedro
('5511977776666', 'Renato Alves', 'Limpeza de vidros externos', CURRENT_DATE - 1, NULL, 180.00, 180.00, 'feito', 'pago'),

-- HOJE
-- 13: Eletricista - Carlos (hoje, não pago)
('5511999998888', 'Claudia Miranda', 'Troca de interruptor', CURRENT_DATE, '11:00', 90.00, 0, 'agendado', 'nao_pago'),

-- 14: Limpador - Pedro (hoje, pago)
('5511977776666', 'André Luis', 'Limpeza mensal escritório', CURRENT_DATE, '08:00', 250.00, 250.00, 'feito', 'pago');
