# 🛍️ Billing & Inventory Management System

A complete billing and inventory management solution with React Admin dashboard and React Native mobile app, powered by Supabase backend.

## 🌟 Features

### 📱 Mobile App (React Native/Expo)
- **Inventory Management**: Add, edit, delete products with SKU tracking
- **Sales Processing**: Shopping cart with editable prices and quantities
- **Automatic Discounts**: Calculate and display percentage discounts
- **PDF Invoice Generation**: Professional invoices with company branding
- **Email Integration**: Send invoices to customers via email
- **Authentication**: Secure login with Supabase Auth
- **Real-time Sync**: Live inventory updates across devices
- **Company Profiles**: Manage business information and logo

### 💻 Admin Dashboard (React)
- **Product Management**: CSV import/export, bulk operations
- **Sales Analytics**: Revenue tracking and reporting
- **Responsive Design**: Works on desktop and mobile
- **Real-time Data**: Live sync with mobile app

### 🔧 Technical Stack
- **Frontend**: React 18.3.1, React Native (Expo 48.0)
- **Backend**: Supabase (PostgreSQL + Auth + Edge Functions)
- **UI**: React Native Paper, Material Design
- **PDF**: expo-print for invoice generation
- **Email**: Supabase Edge Functions + Resend API
- **Deployment**: Firebase Hosting (admin), Netlify (mobile web)

## 🚀 Live Demo

- **Mobile App**: https://whimsical-stardust-73c687.netlify.app
- **Admin Dashboard**: https://billing-software-108c1.web.app

## 📋 Database Schema

```sql
-- Products table
CREATE TABLE products (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users DEFAULT auth.uid(),
  name TEXT NOT NULL,
  sku TEXT NOT NULL,
  stock INTEGER DEFAULT 0,
  price DECIMAL(10,2) DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Sales table
CREATE TABLE sales (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users DEFAULT auth.uid(),
  customer TEXT,
  email TEXT,
  phone TEXT,
  total DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Sale items table
CREATE TABLE sale_items (
  id BIGSERIAL PRIMARY KEY,
  sale_id BIGINT REFERENCES sales(id) ON DELETE CASCADE,
  product_id BIGINT REFERENCES products(id),
  qty INTEGER NOT NULL,
  price_each DECIMAL(10,2) NOT NULL
);

-- Company profile table
CREATE TABLE company_profile (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users UNIQUE,
  company_name TEXT,
  email TEXT,
  phone TEXT,
  address TEXT,
  logo_url TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);
```

## 🛠️ Installation & Setup

### Prerequisites
- Node.js 16+
- npm or yarn
- Supabase account
- Firebase account (for hosting)
- Netlify account (for mobile web deployment)

### 1. Clone Repository
```bash
git clone https://github.com/LUCIFER14144/Netlify.git
cd Netlify
```

### 2. Setup Supabase Backend
1. Create project at https://supabase.com
2. Copy project URL and anon key
3. Run the SQL schema in Supabase SQL Editor
4. Update configuration files with your credentials

### 3. Admin Dashboard Setup
```bash
cd admin
npm install
# Update src/firebaseConfig.js with Supabase credentials
npm start
```

### 4. Mobile App Setup
```bash
cd mobile
npm install
# Update firebaseConfig.js with Supabase credentials
npx expo start
```

### 5. Email Setup (Optional)
1. Sign up at https://resend.com
2. Create Supabase Edge Function
3. Add Resend API key to secrets
4. Deploy function

## 📱 Mobile App Features

### Sales Screen
- Product search and filtering
- Shopping cart with real-time totals
- Editable quantities and prices
- Automatic discount calculation
- Customer contact information
- PDF invoice generation
- Email invoice sending

### Inventory Screen
- Add/edit/delete products
- Stock level tracking
- SKU management
- Bulk import via CSV
- Real-time sync

### Sales Records
- Transaction history
- Revenue analytics
- Expandable sale details
- Daily/weekly/monthly reports

### Profile Management
- Company information
- Logo upload
- Contact details
- Invoice branding

## 🎨 UI Components

The app uses React Native Paper for consistent Material Design:
- Cards for product display
- DataTables for sales history
- Modals for cart and receipts
- Chips for status indicators
- Snackbars for notifications

## 🔐 Security Features

- Row Level Security (RLS) policies
- User authentication required
- Data isolation per user
- Secure API endpoints
- CORS protection

## 📧 Email Integration

### Automatic Email Sending
- Professional HTML invoices
- Company branding
- Itemized product lists
- Discount calculations
- Customer details

### Email Services Supported
- Supabase Edge Functions + Resend
- Mailto fallback for manual sending
- EmailJS integration option

## 📊 Analytics & Reporting

- Daily revenue tracking
- Product performance metrics
- Sales history with search
- Inventory level monitoring
- Customer database

## 🚀 Deployment

### Admin Dashboard (Firebase)
```bash
cd admin
npm run build
firebase deploy --only hosting
```

### Mobile Web (Netlify)
```bash
cd mobile
npx expo export:web
netlify deploy --dir=web-build --prod
```

### Edge Functions (Supabase)
```bash
supabase functions deploy send-invoice-email
supabase secrets set RESEND_API_KEY=your_key
```

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and questions:
- Open an issue on GitHub
- Check the documentation in `/docs`
- Review setup guides in project root

## 🎯 Roadmap

- [ ] Multi-currency support
- [ ] Advanced reporting dashboard
- [ ] Barcode scanning
- [ ] Multi-warehouse inventory
- [ ] Customer loyalty program
- [ ] Integration with payment gateways
- [ ] Mobile app for iOS/Android stores

---

**Built with ❤️ for small businesses and entrepreneurs**