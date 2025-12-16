#!/bin/bash

echo "🔧 Creating Subscription for User"
echo "=================================="

USER_ID="d5dc8608-1e75-4c8b-b1a1-b5906bb06bc3"
PHONE="+998971025595"

echo "User ID: $USER_ID"
echo "Phone: $PHONE"
echo ""

# Create subscription in database
docker-compose exec postgres psql -U yuvgo -d yuvgo_db << EOF

-- Delete old subscriptions
DELETE FROM subscriptions WHERE user_id = '$USER_ID';

-- Create new subscription
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
    '$USER_ID',
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

-- Show result
SELECT 
    s.id,
    s.status,
    s.visits_remaining,
    s.end_date::DATE as valid_until
FROM subscriptions s
WHERE s.user_id = '$USER_ID' AND s.status = 'active';

EOF

echo ""
echo "✅ Subscription created!"
echo ""
echo "Now try:"
echo "1. Refresh page: http://localhost:3003/home"
echo "2. Scan QR code"
echo ""
