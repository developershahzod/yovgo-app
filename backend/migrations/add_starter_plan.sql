-- Migration: Add max_users and is_one_time to subscription_plans + seed Starter plan

-- Add new columns
ALTER TABLE subscription_plans
    ADD COLUMN IF NOT EXISTS max_users INTEGER DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS is_one_time BOOLEAN DEFAULT FALSE;

-- Seed: Starter plan — 1 wash, 19,900 UZS, max 1000 users, one-time only
INSERT INTO subscription_plans (
    id,
    name,
    name_ru,
    name_en,
    description,
    description_ru,
    description_en,
    price,
    currency,
    duration_days,
    visit_limit,
    is_unlimited,
    max_users,
    is_one_time,
    is_active
)
VALUES (
    uuid_generate_v4(),
    'Starter',
    'Стартер',
    'Starter',
    '1 ta moyka — 19,900 so''m. Faqat yangi foydalanuvchilar uchun. Jami 1000 ta o''rin.',
    '1 мойка — 19 900 сум. Только для новых пользователей. Всего 1000 мест.',
    '1 wash — 19,900 UZS. New users only. Limited to 1,000 users.',
    19900.00,
    'UZS',
    30,
    1,
    FALSE,
    1000,
    TRUE,
    TRUE
)
ON CONFLICT DO NOTHING;
