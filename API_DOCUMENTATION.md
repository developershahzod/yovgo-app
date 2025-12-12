# YuvGo API Documentation

## Base URL

```
http://localhost:8000/api
```

## Authentication

All protected endpoints require JWT authentication:

```
Authorization: Bearer <access_token>
```

## Admin Endpoints

### Authentication

#### POST /admin/auth/login
Login as admin

**Request:**
```json
{
  "email": "admin@yuvgo.uz",
  "password": "Admin@123"
}
```

**Response:**
```json
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "token_type": "bearer"
}
```

### Admin Management

#### POST /admin/admins
Create new admin (requires `admins.write` permission)

**Request:**
```json
{
  "email": "newadmin@yuvgo.uz",
  "password": "SecurePass123",
  "full_name": "John Doe",
  "role": "admin",
  "permissions": ["users.read", "users.write"]
}
```

#### GET /admin/admins
List all admins (requires `admins.read` permission)

**Query Parameters:**
- `skip`: Offset (default: 0)
- `limit`: Limit (default: 20)

#### GET /admin/admins/{admin_id}
Get admin details

#### PUT /admin/admins/{admin_id}
Update admin

#### DELETE /admin/admins/{admin_id}
Deactivate admin

### Analytics

#### GET /admin/analytics/overview
Get analytics overview

**Query Parameters:**
- `period`: day, week, month, year (default: month)

**Response:**
```json
{
  "total_users": 1250,
  "active_subscriptions": 890,
  "total_visits": 3420,
  "revenue": 125000000.00,
  "period": "month"
}
```

#### GET /admin/analytics/users
Get user analytics

#### GET /admin/analytics/revenue
Get revenue analytics

### Partner Management

#### PUT /admin/partners/{partner_id}/approve
Approve partner application

#### PUT /admin/partners/{partner_id}/reject
Reject partner application

**Request:**
```json
{
  "reason": "Incomplete documentation"
}
```

### Promotions

#### POST /admin/promotions
Create promotion

**Request:**
```json
{
  "title": "Summer Special",
  "description": "50% off for new users",
  "discount_percentage": 50.0,
  "code": "SUMMER50",
  "start_date": "2024-06-01T00:00:00Z",
  "end_date": "2024-08-31T23:59:59Z",
  "usage_limit": 1000
}
```

#### GET /admin/promotions
List promotions

**Query Parameters:**
- `skip`: Offset
- `limit`: Limit
- `active_only`: Filter active promotions (boolean)

### Audit Logs

#### GET /admin/audit-logs
Get audit logs

**Query Parameters:**
- `skip`: Offset
- `limit`: Limit
- `entity_type`: Filter by entity type
- `admin_id`: Filter by admin ID

## User Endpoints

### User Management

#### POST /user/users
Create new user

**Request:**
```json
{
  "phone_number": "+998901234567",
  "email": "user@example.com",
  "full_name": "John Smith"
}
```

#### GET /user/users/{user_id}
Get user details (requires authentication)

#### PUT /user/users/{user_id}
Update user profile

**Request:**
```json
{
  "email": "newemail@example.com",
  "full_name": "John Smith Jr."
}
```

#### GET /user/users
List all users (admin only)

### Vehicle Management

#### POST /user/vehicles
Add vehicle

**Request:**
```json
{
  "license_plate": "01A123BC",
  "brand": "Toyota",
  "model": "Camry",
  "color": "White",
  "year": 2020
}
```

#### GET /user/vehicles
List user's vehicles

#### DELETE /user/vehicles/{vehicle_id}
Delete vehicle

## Subscription Endpoints

### Plans

#### GET /subscription/plans
List all subscription plans

**Response:**
```json
[
  {
    "id": "uuid",
    "name": "Basic Monthly",
    "description": "12 car washes per month",
    "price": 99000.00,
    "currency": "UZS",
    "duration_days": 30,
    "visit_limit": 12,
    "is_unlimited": false,
    "is_active": true
  }
]
```

#### POST /subscription/plans
Create subscription plan (admin only)

#### GET /subscription/plans/{plan_id}
Get plan details

### Subscriptions

#### POST /subscription/subscriptions
Create subscription

**Request:**
```json
{
  "plan_id": "uuid",
  "auto_renew": true
}
```

#### GET /subscription/subscriptions/status
Get current subscription status

#### POST /subscription/subscriptions/{subscription_id}/cancel
Cancel subscription

#### GET /subscription/subscriptions
List all subscriptions (admin only)

## Partner Endpoints

### Partner Registration

#### POST /partner/partners
Register new partner

**Request:**
```json
{
  "name": "Premium Car Wash",
  "description": "High-quality car wash services",
  "email": "contact@premiumwash.uz",
  "phone_number": "+998901234567"
}
```

#### GET /partner/partners
List partners

**Query Parameters:**
- `skip`: Offset
- `limit`: Limit
- `status`: Filter by status (pending, approved, rejected)

#### GET /partner/partners/{partner_id}
Get partner details

#### PUT /partner/partners/{partner_id}
Update partner

### Locations

#### POST /partner/locations
Add location

**Request:**
```json
{
  "partner_id": "uuid",
  "name": "Downtown Branch",
  "address": "123 Main Street, Tashkent",
  "city": "Tashkent",
  "latitude": 41.2995,
  "longitude": 69.2401,
  "working_hours": {
    "monday": "09:00-20:00",
    "tuesday": "09:00-20:00",
    "wednesday": "09:00-20:00",
    "thursday": "09:00-20:00",
    "friday": "09:00-20:00",
    "saturday": "10:00-18:00",
    "sunday": "10:00-18:00"
  }
}
```

#### GET /partner/locations
List locations

**Query Parameters:**
- `partner_id`: Filter by partner
- `city`: Filter by city

### Staff

#### POST /partner/staff
Add staff member

**Request:**
```json
{
  "partner_id": "uuid",
  "location_id": "uuid",
  "full_name": "Staff Member",
  "phone_number": "+998901234567",
  "pin_code": "123456",
  "role": "staff"
}
```

#### GET /partner/staff
List staff

## Visit Endpoints

### QR Code

#### POST /visit/qr/generate
Generate QR token for check-in (requires authentication)

**Response:**
```json
{
  "qr_token": "abc123def456...",
  "expires_in": 120,
  "user_id": "uuid",
  "subscription_id": "uuid"
}
```

### Check-in

#### POST /visit/checkin
Process check-in with QR token

**Request:**
```json
{
  "qr_token": "abc123def456...",
  "location_id": "uuid",
  "staff_id": "uuid",
  "notes": "Regular wash"
}
```

**Response:**
```json
{
  "id": "uuid",
  "user_id": "uuid",
  "subscription_id": "uuid",
  "vehicle_id": "uuid",
  "partner_id": "uuid",
  "location_id": "uuid",
  "staff_id": "uuid",
  "check_in_time": "2024-01-15T10:30:00Z",
  "status": "completed"
}
```

### Visit History

#### GET /visit/visits
Get user's visit history (requires authentication)

**Query Parameters:**
- `skip`: Offset
- `limit`: Limit

#### GET /visit/visits/{visit_id}
Get visit details

#### GET /visit/partner/{partner_id}/visits
Get partner visit history

**Query Parameters:**
- `start_date`: Filter by start date
- `end_date`: Filter by end date
- `skip`: Offset
- `limit`: Limit

## Payment Endpoints

### Payments

#### POST /payment/payments
Create payment

**Request:**
```json
{
  "subscription_id": "uuid",
  "amount": 99000.00,
  "provider": "payme",
  "payment_method": "card",
  "card_token": "token_abc123"
}
```

#### GET /payment/payments
List user's payments

#### GET /payment/payments/{payment_id}
Get payment details

### Webhooks

#### POST /payment/webhook/payme
Payme payment webhook

#### POST /payment/webhook/click
Click payment webhook

#### POST /payment/webhook/paynet
Paynet payment webhook

### Refunds

#### POST /payment/payments/{payment_id}/refund
Refund payment (admin only)

## Notification Endpoints

#### POST /notification/notifications/send
Send notification

**Request:**
```json
{
  "user_id": "uuid",
  "title": "Subscription Expiring",
  "message": "Your subscription expires in 3 days",
  "notification_type": "subscription_expiry",
  "channel": "push"
}
```

#### GET /notification/notifications
Get user's notifications

**Query Parameters:**
- `skip`: Offset
- `limit`: Limit
- `unread_only`: Filter unread (boolean)

#### PUT /notification/notifications/{notification_id}/read
Mark notification as read

#### PUT /notification/notifications/read-all
Mark all notifications as read

#### POST /notification/notifications/broadcast
Broadcast notification to all users (admin only)

## Error Responses

All endpoints return standard error responses:

```json
{
  "detail": "Error message description"
}
```

### HTTP Status Codes

- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `429` - Too Many Requests (Rate Limit)
- `500` - Internal Server Error
- `503` - Service Unavailable

## Rate Limiting

- Default: 60 requests per minute per IP
- Configurable via `RATE_LIMIT_PER_MINUTE` environment variable

## Permissions

Admin permissions:
- `all` - Super admin (all permissions)
- `users.read` - View users
- `users.write` - Create/update users
- `partners.read` - View partners
- `partners.write` - Approve/reject partners
- `subscriptions.read` - View subscriptions
- `payments.read` - View payments
- `payments.write` - Process refunds
- `analytics.read` - View analytics
- `admins.read` - View admins
- `admins.write` - Create/update admins
- `promotions.read` - View promotions
- `promotions.write` - Create promotions
- `audit.read` - View audit logs
