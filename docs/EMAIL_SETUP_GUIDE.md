# Quick Setup Guide: Email Invoices with Supabase + Resend

## Step 1: Sign Up for Resend (2 minutes)

1. Go to https://resend.com/signup
2. Create free account (100 emails/day)
3. Verify your email
4. Go to **API Keys** section
5. Click **Create API Key**
6. Copy the key (starts with `re_...`)

## Step 2: Set Up Supabase Edge Function (5 minutes)

### Install Supabase CLI

**Windows (PowerShell):**
```powershell
npm install -g supabase
```

### Login and Link Project

```powershell
# Login to Supabase
supabase login

# Navigate to project folder
cd path/to/your/project

# Link to your Supabase project
supabase link --project-ref YOUR_PROJECT_REF
```

### Set API Key Secret

```powershell
# Replace YOUR_RESEND_API_KEY with the key from Step 1
supabase secrets set RESEND_API_KEY=re_YOUR_KEY_HERE
```

### Deploy the Function

```powershell
supabase functions deploy send-invoice-email
```

## Step 3: Configure From Email

### Option A: Use Resend Test Email (Quick)
Already configured in the function:
```
from: 'onboarding@resend.dev'
```

### Option B: Use Your Domain (Professional)
1. Add your domain in Resend dashboard
2. Add DNS records (Resend will show you)
3. Update `functions/send-invoice-email/index.ts` line 21:
```typescript
from: 'invoices@yourdomain.com',
```
4. Redeploy:
```powershell
supabase functions deploy send-invoice-email
```

## Step 4: Test Email Sending

1. Open your deployed app
2. Go to Sales → Add products → View Cart
3. Enter customer **email address**
4. Complete checkout
5. Check customer inbox for invoice!

## Troubleshooting

### "Function not found" error
```powershell
# Check function is deployed
supabase functions list
```

### "Authentication error"
```powershell
# Verify secret is set
supabase secrets list
```

### "Email not received"
1. Check Resend dashboard for delivery status
2. Check spam folder
3. Check Supabase function logs
4. Verify API key is correct

## Email Features

✅ Professional HTML invoices
✅ Company branding (logo, name, contact info)
✅ Itemized product list with SKUs
✅ Discount calculations shown
✅ Customer contact information
✅ Invoice number and date
✅ Total amount with breakdown

## Limits & Pricing

**Resend Free Tier:**
- 100 emails per day
- 3,000 emails per month
- Perfect for small businesses

**Paid Plans Available:**
- Pro: $20/month for 50,000 emails
- Business: Custom pricing

## Alternative: Manual Email

If you prefer not to set up automatic emails, the app also supports:
- Mailto links that open your email client
- Pre-filled invoice details
- You can attach the generated PDF
- More control over what gets sent