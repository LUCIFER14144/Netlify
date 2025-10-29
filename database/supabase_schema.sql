-- Run this in Supabase SQL Editor (free tier). It creates tables, RLS, and an atomic checkout.

-- Enable pgcrypto for UUID generation if not already
create extension if not exists pgcrypto;

-- Products table
create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  sku text unique,
  stock integer not null default 0,
  price numeric not null default 0,
  created_at timestamptz not null default now()
);

-- Sales table
create table if not exists public.sales (
  id uuid primary key default gen_random_uuid(),
  total numeric not null,
  customer text,
  created_at timestamptz not null default now()
);

-- Sale items table
create table if not exists public.sale_items (
  id uuid primary key default gen_random_uuid(),
  sale_id uuid not null references public.sales(id) on delete cascade,
  product_id uuid not null references public.products(id) on delete restrict,
  qty integer not null,
  price_each numeric not null
);

-- RLS
alter table public.products enable row level security;
alter table public.sales enable row level security;
alter table public.sale_items enable row level security;

-- Dev policy: allow anon read/write (tighten later for auth)
drop policy if exists "anon rw products" on public.products;
create policy "anon rw products" on public.products for all using (true) with check (true);

drop policy if exists "anon rw sales" on public.sales;
create policy "anon rw sales" on public.sales for all using (true) with check (true);

drop policy if exists "anon rw sale_items" on public.sale_items;
create policy "anon rw sale_items" on public.sale_items for all using (true) with check (true);

-- Atomic checkout function: decrements stock and creates sale + items in a transaction
create or replace function public.checkout_sale(
  items jsonb,
  customer text default null
) returns void language plpgsql security definer as $$
declare
  v_total numeric := 0;
  v_sale_id uuid := gen_random_uuid();
  v_item jsonb;
  v_product_id uuid;
  v_qty int;
  v_price_each numeric;
  v_stock int;
begin
  -- check stock and compute total
  for v_item in select * from jsonb_array_elements(items)
  loop
    v_product_id := (v_item->>'product_id')::uuid;
    v_qty := (v_item->>'qty')::int;
    v_price_each := (v_item->>'price_each')::numeric;

    select stock into v_stock from public.products where id = v_product_id for update;
    if v_stock is null then
      raise exception 'Product % not found', v_product_id;
    end if;
    if v_stock < v_qty then
      raise exception 'Not enough stock for product % (have % need %)', v_product_id, v_stock, v_qty;
    end if;
    update public.products set stock = stock - v_qty where id = v_product_id;
    v_total := v_total + v_price_each * v_qty;
  end loop;

  insert into public.sales(id, total, customer) values (v_sale_id, v_total, customer);
  insert into public.sale_items(sale_id, product_id, qty, price_each)
  select v_sale_id,
         (v->>'product_id')::uuid,
         (v->>'qty')::int,
         (v->>'price_each')::numeric
  from jsonb_array_elements(items) as v;
end;
$$;

-- Allow anon to execute checkout_sale in dev
grant usage on schema public to anon;
grant execute on function public.checkout_sale(jsonb, text) to anon;