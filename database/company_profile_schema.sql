-- Add company_profile table for storing business information
CREATE TABLE IF NOT EXISTS company_profile (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  company_name TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  address TEXT,
  logo_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id)
);

-- Enable RLS
ALTER TABLE company_profile ENABLE ROW LEVEL SECURITY;

-- RLS Policies for company_profile
DROP POLICY IF EXISTS "Users can read their own profile" ON company_profile;
DROP POLICY IF EXISTS "Users can insert their own profile" ON company_profile;
DROP POLICY IF EXISTS "Users can update their own profile" ON company_profile;

CREATE POLICY "Users can read their own profile" ON company_profile
  FOR SELECT TO authenticated 
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own profile" ON company_profile
  FOR INSERT TO authenticated 
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own profile" ON company_profile
  FOR UPDATE TO authenticated 
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);