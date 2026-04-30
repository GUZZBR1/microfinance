-- Initial schema for WhatsApp MVP operational assistant
-- Tables: users, services, user_sessions

-- 1. users
CREATE TABLE users (
    id serial primary key,
    phone text unique not null,
    name text,
    created_at timestamptz default now()
);

-- 2. services
CREATE TABLE services (
    id serial primary key,
    user_phone text not null,
    client_name text not null,
    description text,
    service_date date not null,
    service_time time,
    value numeric(10,2) not null default 0,
    paid_amount numeric(10,2) default 0,
    status text default 'agendado',
    payment_status text default 'nao_pago',
    created_at timestamptz default now()
);

-- 3. user_sessions
CREATE TABLE user_sessions (
    user_phone text primary key,
    pending_intent text,
    missing_fields text[],
    retry_count integer default 0,
    updated_at timestamptz default now()
);

-- Foreign key
ALTER TABLE services
    ADD CONSTRAINT fk_services_user_phone
    FOREIGN KEY (user_phone)
    REFERENCES users(phone)
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

-- Constraints
ALTER TABLE users
    ADD CONSTRAINT chk_users_phone_not_empty
    CHECK (btrim(phone) <> '');

ALTER TABLE services
    ADD CONSTRAINT chk_services_user_phone_not_empty
    CHECK (btrim(user_phone) <> '');

ALTER TABLE services
    ADD CONSTRAINT chk_services_client_name_not_empty
    CHECK (btrim(client_name) <> '');

ALTER TABLE services
    ADD CONSTRAINT chk_services_description_valid
    CHECK (description IS NULL OR btrim(description) <> '');

ALTER TABLE services
    ADD CONSTRAINT chk_services_value_non_negative
    CHECK (value >= 0);

ALTER TABLE services
    ADD CONSTRAINT chk_services_paid_amount_valid
    CHECK (paid_amount >= 0 AND paid_amount <= value);

ALTER TABLE services
    ADD CONSTRAINT chk_services_status_valid
    CHECK (status IN ('agendado', 'feito'));

ALTER TABLE services
    ADD CONSTRAINT chk_services_payment_status_valid
    CHECK (payment_status IN ('nao_pago', 'parcial', 'pago'));

-- Indexes
CREATE INDEX idx_services_user_phone ON services(user_phone);
CREATE INDEX idx_services_user_date ON services(user_phone, service_date);
CREATE INDEX idx_services_user_date_time ON services(user_phone, service_date, service_time);
CREATE INDEX idx_services_payment_status ON services(payment_status);
CREATE INDEX idx_services_status ON services(status);
