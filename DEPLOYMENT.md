# 🚀 Deployment Guide

This guide covers deploying the billing and inventory management system to production.

## 📋 Prerequisites

- Node.js 16+ installed
- Supabase account
- Firebase account (for admin hosting)
- Netlify account (for mobile web hosting)
- Domain name (optional)

## 🗄️ Database Setup

### 1. Create Supabase Project

1. Go to https://supabase.com
2. Create new project
3. Note down:
   - Project URL (e.g., `https://xyz.supabase.co`)
   - Anon public key
   - Service role key (for admin operations)

### 2. Run Database Schema

1. Open Supabase SQL Editor
2. Run `database/supabase_schema.sql`
3. Run `database/company_profile_schema.sql`
4. Verify tables are created

### 3. Configure Authentication

1. Go to Authentication → Settings
2. Enable Email authentication
3. Configure email templates (optional)
4. Set up RLS policies

## 🖥️ Admin Dashboard Deployment

### 1. Configure Environment

```bash
cd admin
cp src/firebaseConfig.example.js src/firebaseConfig.js
```

Update `src/firebaseConfig.js`:
```javascript
export const firebaseConfig = {
  supabaseUrl: 'https://your-project.supabase.co',
  supabaseAnonKey: 'your-anon-key-here',
};
```

### 2. Build and Deploy to Firebase

```bash
# Install dependencies
npm install

# Build for production
npm run build

# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase project
firebase init hosting

# Deploy
firebase deploy --only hosting
```

## 📱 Mobile App Deployment

### 1. Configure Environment

```bash
cd mobile
cp firebaseConfig.example.js firebaseConfig.js
```

Update `firebaseConfig.js`:
```javascript
export const firebaseConfig = {
  supabaseUrl: 'https://your-project.supabase.co',
  supabaseAnonKey: 'your-anon-key-here',
};
```

### 2. Build for Web

```bash
# Install dependencies
npm install

# Build web version
npx expo export:web
```

### 3. Deploy to Netlify

```bash
# Install Netlify CLI
npm install -g netlify-cli

# Login to Netlify
netlify login

# Deploy
netlify deploy --dir=web-build --prod
```

### 4. Native App Deployment (Optional)

For iOS/Android app stores:

```bash
# Build for iOS
expo build:ios

# Build for Android
expo build:android
```

## 📧 Email Setup (Optional)

### 1. Sign up for Resend

1. Go to https://resend.com/signup
2. Get API key
3. Verify domain (optional)

### 2. Deploy Edge Function

```bash
# Install Supabase CLI
npm install -g supabase

# Login and link project
supabase login
supabase link --project-ref your-project-ref

# Set API key
supabase secrets set RESEND_API_KEY=re_your_key_here

# Deploy function
supabase functions deploy send-invoice-email
```

## 🔧 Configuration Files

### Environment Variables

Create `.env` files for each component:

**Admin (.env):**
```
REACT_APP_SUPABASE_URL=https://your-project.supabase.co
REACT_APP_SUPABASE_ANON_KEY=your-anon-key
```

**Mobile (.env):**
```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

### Firebase Configuration

**firebase.json:**
```json
{
  "hosting": {
    "public": "admin/build",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

### Netlify Configuration

**mobile/netlify.toml:**
```toml
[build]
  publish = "web-build"
  command = ""

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

## 🔐 Security Configuration

### 1. Update RLS Policies

For production, update the database policies to be more restrictive:

```sql
-- Remove anon access and require authentication
DROP POLICY IF EXISTS "anon rw products" ON public.products;
CREATE POLICY "Users can manage their products" ON public.products
  FOR ALL TO authenticated 
  USING (auth.uid() = user_id) 
  WITH CHECK (auth.uid() = user_id);
```

### 2. Environment Security

- Store secrets in environment variables
- Use HTTPS only
- Enable CORS properly
- Rotate API keys regularly

## 📊 Monitoring & Analytics

### 1. Supabase Dashboard

- Monitor database performance
- Check function logs
- Track user activity

### 2. Firebase Analytics (Optional)

```bash
# Add Firebase Analytics
firebase init analytics
firebase deploy --only hosting
```

### 3. Error Tracking

Consider adding:
- Sentry for error tracking
- LogRocket for session replay
- Google Analytics for usage

## 🚀 Go Live Checklist

- [ ] Database schema deployed
- [ ] RLS policies configured
- [ ] Admin dashboard deployed
- [ ] Mobile app deployed
- [ ] Email function working
- [ ] Domain configured (optional)
- [ ] SSL certificates active
- [ ] Monitoring setup
- [ ] Backup strategy in place
- [ ] User documentation ready

## 🔄 Updates & Maintenance

### Updating the App

1. Make changes locally
2. Test thoroughly
3. Build new version
4. Deploy to staging first
5. Deploy to production

### Database Migrations

```sql
-- Always backup before migrations
-- Use transactions for safety
BEGIN;
  ALTER TABLE products ADD COLUMN new_field TEXT;
  -- Update existing data if needed
COMMIT;
```

### Monitoring

- Check Supabase dashboard daily
- Monitor email delivery rates
- Track app performance
- Review user feedback

## 📞 Support

For deployment issues:
- Check the docs/ folder for detailed guides
- Review Supabase logs
- Check browser console for errors
- Ensure all environment variables are set

---

**Your billing system is now ready for production! 🎉**