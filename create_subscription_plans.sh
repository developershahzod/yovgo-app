#!/bin/bash

echo "📋 Creating Subscription Plans"
echo "=============================="

docker-compose exec postgres psql -U yuvgo -d yuvgo_db << EOF

-- Delete old plans
DELETE FROM subscription_plans;

-- Create Basic Plan
INSERT INTO subscription_plans (
    id,
    name,
    description,
    price,
    currency,
    duration_days,
    visit_limit,
    is_unlimited,
    is_active,
    created_at,
    updated_at
) VALUES (
    'basic-plan',
    'Базовый',
    '10 визитов в месяц',
    50000,
    'UZS',
    30,
    10,
    false,
    true,
    NOW(),
    NOW()
);

-- Create Standard Plan
INSERT INTO subscription_plans (
    id,
    name,
    description,
    price,
    currency,
    duration_days,
    visit_limit,
    is_unlimited,
    is_active,
    created_at,
    updated_at
) VALUES (
    'standard-plan',
    'Стандарт',
    '20 визитов в месяц',
    90000,
    'UZS',
    30,
    20,
    false,
    true,
    NOW(),
    NOW()
);

-- Create Premium Plan
INSERT INTO subscription_plans (
    id,
    name,
    description,
    price,
    currency,
    duration_days,
    visit_limit,
    is_unlimited,
    is_active,
    created_at,
    updated_at
) VALUES (
    'premium-plan',
    'Премиум',
    'Безлимитные визиты',
    150000,
    'UZS',
    30,
    999,
    true,
    true,
    NOW(),
    NOW()
);

-- Show created plans
\echo ''
\echo 'Created plans:'
SELECT 
    id,
    name,
    description,
    price,
    visit_limit,
    is_unlimited
FROM subscription_plans
ORDER BY price;

EOF

echo ""
echo "✅ Plans created!"
echo ""
echo "Now refresh: http://localhost:3003/subscriptions"
echo ""
