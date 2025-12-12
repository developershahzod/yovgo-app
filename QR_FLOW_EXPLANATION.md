# ✅ Correct QR Code Flow

## 🔄 How It Actually Works (Correct Implementation)

### The system is already correctly implemented! Here's the flow:

---

## 📱 User Side (User App - localhost:3003)

### Step 1: User Generates QR Code
```
User opens app → Goes to "My QR" tab → Clicks "Generate QR Code"
```

**What happens:**
1. User app calls: `POST /api/visit/qr/generate`
2. Backend creates a unique QR token (valid for 120 seconds)
3. QR code is displayed on user's phone
4. Timer starts counting down (2:00 → 1:59 → 1:58...)

**User sees:**
- Large QR code on their phone screen
- Countdown timer
- Instructions: "Show this to car wash staff"

---

## 🏪 Merchant Side (Merchant Dashboard - localhost:3001)

### Step 2: Merchant Scans User's QR Code
```
Customer arrives → Shows QR code → Staff scans it
```

**What happens:**
1. Merchant opens "QR Scanner" page
2. Customer shows their phone with QR code
3. Staff either:
   - **Scans with barcode scanner** (USB scanner reads QR)
   - **Manually enters the token** (types the code)
4. Staff clicks "Process Check-in"

**Merchant dashboard calls:**
```
POST /api/visit/checkin
{
  "qr_token": "abc123...",  // The token from user's QR
  "location_id": "...",
  "staff_id": "...",
  "notes": ""
}
```

**System validates:**
- ✅ QR token exists and not expired (< 120 seconds)
- ✅ User has active subscription
- ✅ User hasn't exceeded visit limit
- ✅ 4-hour cooldown period passed
- ✅ Token hasn't been used before (single-use)

**If valid:**
- ✅ Visit recorded
- ✅ Visit counter incremented
- ✅ QR token deleted (can't be reused)
- ✅ Success message shown

---

## 🔐 Security Features

### QR Token Properties
- **Lifetime:** 120 seconds (2 minutes)
- **Single-use:** Deleted after first scan
- **Unique:** Each generation creates new token
- **Secure:** Stored in Redis, not in database
- **Validated:** Checks subscription, limits, cooldown

### Why This is Secure
1. **Short expiration** - Can't be reused later
2. **Single-use** - Can't scan twice
3. **Server-side validation** - Can't be faked
4. **Cooldown period** - Prevents abuse (4 hours between washes)
5. **Subscription check** - Must have active subscription

---

## 📊 Complete Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    USER'S PHONE                              │
│                                                              │
│  1. User opens app                                          │
│  2. Goes to "My QR" tab                                     │
│  3. Clicks "Generate QR Code"                               │
│                                                              │
│  ┌──────────────────────────────────────┐                  │
│  │                                       │                  │
│  │         ████████████████              │                  │
│  │         ██          ████              │                  │
│  │         ██  QR CODE ████              │                  │
│  │         ██          ████              │                  │
│  │         ████████████████              │                  │
│  │                                       │                  │
│  │         Timer: 1:45                   │                  │
│  │                                       │                  │
│  └──────────────────────────────────────┘                  │
│                                                              │
│  4. Shows this QR to merchant staff                         │
└─────────────────────────────────────────────────────────────┘
                          │
                          │ Customer shows phone
                          ▼
┌─────────────────────────────────────────────────────────────┐
│              MERCHANT'S COMPUTER/TABLET                      │
│                                                              │
│  5. Staff opens "QR Scanner" page                           │
│  6. Staff scans QR code (or enters token)                   │
│  7. Clicks "Process Check-in"                               │
│                                                              │
│  ┌──────────────────────────────────────┐                  │
│  │  QR Scanner                           │                  │
│  │  ┌────────────────────────────────┐  │                  │
│  │  │ Enter QR Token:                │  │                  │
│  │  │ [abc123def456...]              │  │                  │
│  │  └────────────────────────────────┘  │                  │
│  │                                       │                  │
│  │  [Process Check-in]                   │                  │
│  └──────────────────────────────────────┘                  │
│                                                              │
│  8. System validates and processes                          │
│  9. ✅ Check-in successful!                                 │
└─────────────────────────────────────────────────────────────┘
                          │
                          │ API calls
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                    BACKEND SERVER                            │
│                                                              │
│  Validates:                                                  │
│  ✅ QR token exists in Redis                                │
│  ✅ Token not expired (< 120 seconds)                       │
│  ✅ User has active subscription                            │
│  ✅ Visit limit not exceeded                                │
│  ✅ 4-hour cooldown passed                                  │
│  ✅ Token not used before                                   │
│                                                              │
│  If valid:                                                   │
│  ✅ Create visit record                                     │
│  ✅ Increment visit counter                                 │
│  ✅ Delete QR token (single-use)                            │
│  ✅ Return success                                          │
└─────────────────────────────────────────────────────────────┘
```

---

## ✅ Current Implementation is Correct!

### User App (localhost:3003)
**File:** `frontend/user-app/src/pages/MyQR.js`

```javascript
// User generates QR code
const generateQR = async () => {
  const response = await axios.post(`${API_URL}/api/visit/qr/generate`);
  setQrData(response.data);  // Shows QR on user's screen
  setTimeLeft(response.data.expires_in);  // Starts countdown
};
```

**User sees:**
- QR code displayed on their phone
- 2-minute countdown timer
- Instructions to show to staff

---

### Merchant Dashboard (localhost:3001)
**File:** `frontend/merchant-dashboard/src/pages/QRScanner.js`

```javascript
// Merchant scans user's QR code
const handleScan = async () => {
  const response = await axios.post(`${API_URL}/api/visit/checkin`, {
    qr_token: qrToken,  // Token from user's QR
    location_id: merchant.location?.id,
    staff_id: merchant.id,
    notes: ''
  });
  // Shows success or error
};
```

**Merchant sees:**
- Input field to enter/scan QR token
- "Process Check-in" button
- Success/error feedback

---

## 🎯 Key Points

### ✅ Correct Flow (Already Implemented)
1. **User generates** QR code on their phone
2. **User shows** QR code to merchant
3. **Merchant scans** user's QR code
4. **System validates** and processes check-in

### ❌ Wrong Flow (NOT Implemented)
1. ~~Merchant generates QR code~~
2. ~~User scans merchant's QR code~~
3. ~~This would be insecure and wrong~~

---

## 🔍 How to Test

### Test the Correct Flow:

**1. As User (localhost:3003)**
```
1. Login to user app
2. Go to "My QR" tab
3. Click "Generate QR Code"
4. See QR code with timer
5. Note the token or take screenshot
```

**2. As Merchant (localhost:3001)**
```
1. Login to merchant dashboard
2. Go to "QR Scanner"
3. Enter the token from user's QR
4. Click "Process Check-in"
5. See success message
```

**3. Verify in Database**
```sql
-- Check visit was recorded
SELECT * FROM visits ORDER BY check_in_time DESC LIMIT 1;

-- Check subscription counter incremented
SELECT visits_used FROM subscriptions WHERE user_id = '...';
```

---

## 📱 User Experience

### User Side
```
User: "I want to wash my car"
      ↓
Opens app → My QR → Generate
      ↓
Shows QR code to staff
      ↓
"Thank you! Enjoy your wash!"
```

### Merchant Side
```
Customer arrives with phone
      ↓
Staff: "Please show your QR code"
      ↓
Scans QR code
      ↓
System: "✅ Check-in successful!"
      ↓
Customer proceeds to car wash
```

---

## 🔐 Security Validation

### Backend Checks (backend/services/visit/main.py)

```python
@app.post("/checkin")
async def check_in(visit_data: VisitCreate, db: Session = Depends(get_db)):
    # 1. Validate QR token exists
    token_data = RedisCache.get(f"qr_token:{visit_data.qr_token}")
    if not token_data:
        raise HTTPException(400, "Invalid or expired QR token")
    
    # 2. Verify subscription is active
    subscription = db.query(Subscription).filter(
        Subscription.id == subscription_id,
        Subscription.status == "active"
    ).first()
    
    # 3. Check visit limit
    if not plan.is_unlimited and subscription.visits_used >= plan.visit_limit:
        raise HTTPException(403, "Visit limit reached")
    
    # 4. Create visit record
    visit = Visit(...)
    db.add(visit)
    
    # 5. Increment counter
    subscription.visits_used += 1
    
    # 6. Delete token (single-use)
    RedisCache.delete(f"qr_token:{visit_data.qr_token}")
    
    return visit
```

---

## ✅ Summary

### The System is Already Correct!

**✅ Users generate QR codes** (on their phones)
**✅ Merchants scan QR codes** (from user's phone)
**✅ System validates** (subscription, limits, cooldown)
**✅ Visit recorded** (in database)
**✅ Counter incremented** (visits_used++)
**✅ Token deleted** (single-use security)

### No Changes Needed!

The QR flow is already implemented correctly:
- Users don't scan anything
- Users only show their QR code
- Merchants do the scanning
- System handles validation

---

## 🎉 It's Working Correctly!

Your concern is valid, but the system is already built the right way:
- **User generates** → **Merchant scans** → **System validates**

This is the secure and correct flow for a subscription-based car wash system!

---

**Test it now:**
1. Run `./TEST_NOW.sh`
2. Login to user app (localhost:3003)
3. Generate QR code
4. Login to merchant dashboard (localhost:3001)
5. Scan the QR code
6. See it work! ✅
