-- Create Test Subscription for User

-- 1. Find user by phone
SELECT id, full_name, phone_number FROM users WHERE phone_number = '+998901234567';

-- 2. Create subscription (replace USER_ID with actual user id from step 1)
INSERT INTO subscriptions (
    id,
    user_id,
    plan_id,
    status,
    start_date,
    end_date,
    visits_remaining,
    is_unlimited,
    auto_renew,
    created_at,
    updated_at
) VALUES (
    gen_random_uuid(),
    'USER_ID_HERE',  -- REPLACE WITH ACTUAL USER ID!
    'basic-plan',
    'active',
    NOW(),
    NOW() + INTERVAL '30 days',
    10,
    false,
    true,
    NOW(),
    NOW()
);

-- 3. Verify subscription was created
SELECT 
    s.id,
    u.phone_number,
    s.plan_id,
    s.status,
    s.visits_remaining,
    s.start_date,
    s.end_date
FROM subscriptions s
JOIN users u ON s.user_id = u.id
WHERE u.phone_number = '+998901234567'
ORDER BY s.created_at DESC
LIMIT 1;
