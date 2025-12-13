# Admin Dashboard & Merchant Dashboard UI Update Plan

## Overview
Updating both dashboards with shadcn/ui for modern, beautiful design

## Installation Steps

### 1. Admin Dashboard
```bash
cd frontend/admin-dashboard
npm install class-variance-authority clsx tailwind-merge lucide-react
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p
```

### 2. Merchant Dashboard
```bash
cd frontend/merchant-dashboard
npm install class-variance-authority clsx tailwind-merge lucide-react
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p
```

## Components to Create

### shadcn/ui Components
- Card (with Header, Title, Description, Content, Footer)
- Button (with variants: default, destructive, outline, secondary, ghost, link)
- Badge
- Table
- Dialog/Modal
- Tabs
- Avatar
- Input
- Select
- Chart (using recharts)

## Design Features

### Admin Dashboard
1. **Modern Sidebar Navigation**
   - Collapsible sidebar
   - Icon-based navigation
   - Active state indicators
   - User profile section

2. **Dashboard Overview**
   - Stats cards with icons and trends
   - Revenue charts (line/bar charts)
   - Recent activity feed
   - Quick actions

3. **User Management**
   - Data table with search/filter
   - User cards with avatars
   - Quick actions (edit, delete, view)
   - Pagination

4. **Partner Management**
   - Approval workflow
   - Status badges
   - Location mapping
   - Analytics per partner

5. **Analytics Page**
   - Revenue charts
   - User growth charts
   - Visit statistics
   - Export functionality

### Merchant Dashboard
1. **Modern Header**
   - Partner branding
   - Staff info
   - Quick stats

2. **QR Scanner**
   - Large scan area
   - Recent scans list
   - Success/error feedback
   - Manual entry option

3. **Visit History**
   - Timeline view
   - Filter by date/status
   - Export functionality
   - Customer details

4. **Earnings Dashboard**
   - Daily/weekly/monthly views
   - Charts and graphs
   - Commission breakdown
   - Payment history

5. **Staff Management**
   - Staff list with roles
   - Activity logs
   - Performance metrics

## Color Scheme

### Admin Dashboard
- Primary: Blue (#3B82F6)
- Secondary: Slate (#64748B)
- Success: Green (#10B981)
- Warning: Yellow (#F59E0B)
- Danger: Red (#EF4444)

### Merchant Dashboard
- Primary: Purple (#8B5CF6)
- Secondary: Indigo (#6366F1)
- Success: Emerald (#059669)
- Warning: Amber (#D97706)
- Danger: Rose (#E11D48)

## Implementation Status

✅ Dependencies installed
✅ Utils created
✅ Card component created
✅ Button component created
⏳ Dashboard redesign in progress
⏳ Merchant dashboard redesign pending

## Next Steps

1. Update tailwind.config.js with shadcn theme
2. Create remaining UI components
3. Redesign Dashboard.js with new components
4. Redesign all admin pages
5. Redesign merchant dashboard pages
6. Add animations and transitions
7. Test responsiveness
8. Deploy updates

## Files Modified

- `frontend/admin-dashboard/src/lib/utils.js` - Created
- `frontend/admin-dashboard/src/components/ui/card.jsx` - Created
- `frontend/admin-dashboard/src/components/ui/button.jsx` - Created
- More components to be added...

