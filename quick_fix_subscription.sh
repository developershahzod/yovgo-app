#!/bin/bash

echo "🔧 Quick Fix - Creating Test Subscription"
echo "=========================================="

PHONE="+998901234567"

echo "Creating subscription for user: $PHONE"

# Execute SQL in Docker container
docker exec -i yuvgo_postgres psql -U yuvgo_user -d yuvgo_db << EOF

-- Find user
\echo 'Finding user...'
DO \$\$
DECLARE
    v_user_id UUID;
    v_user_name TEXT;
    v_sub_id UUID;
BEGIN
    -- Get user ID
    SELECT id, full_name INTO v_user_id, v_user_name
    FROM users 
    WHERE phone_number = '$PHONE';
    
    IF v_user_id IS NULL THEN
        RAISE NOTICE 'User not found with phone: $PHONE';
        RETURN;
    END IF;
    
    RAISE NOTICE 'Found user: % (ID: %)', v_user_name, v_user_id;
    
    -- Delete existing active subscriptions
    DELETE FROM subscriptions 
    WHERE user_id = v_user_id AND status = 'active';
    
    RAISE NOTICE 'Deleted old subscriptions';
    
    -- Create new subscription
    v_sub_id := gen_random_uuid();
    
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
        v_sub_id,
        v_user_id,
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
    
    RAISE NOTICE 'Created subscription: %', v_sub_id;
    RAISE NOTICE 'Status: active';
    RAISE NOTICE 'Visits: 10';
    RAISE NOTICE 'Valid until: %', (NOW() + INTERVAL '30 days')::DATE;
    
END \$\$;

-- Show result
\echo ''
\echo 'Current subscription:'
SELECT 
    s.id,
    u.full_name,
    u.phone_number,
    s.status,
    s.visits_remaining,
    s.end_date::DATE as valid_until
FROM subscriptions s
JOIN users u ON s.user_id = u.id
WHERE u.phone_number = '$PHONE'
  AND s.status = 'active';

EOF

echo ""
echo "✅ Done!"
echo ""
echo "Now try scanning QR code:"
echo "MERCHANT_452f6116-fb1e-43ce-b9b8-1060cfdaa6b3_1765803829"
echo ""
