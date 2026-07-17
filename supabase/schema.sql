-- Visit App Schema (Supabase)

-- Enable UUID
create extension if not exists "uuid-ossp";

-- Destination Packs
create table packs (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id) on delete cascade,
  title text not null,
  subtitle text,
  cover_emoji text default '📍',
  is_public boolean default false,
  share_code text unique,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Places
create table places (
  id uuid primary key default uuid_generate_v4(),
  pack_id uuid references packs(id) on delete cascade not null,
  name text not null,
  note text,
  url text,
  maps_url text,
  tabelog_url text,
  image_url text,
  rating numeric(2,1),
  price_level int check (price_level between 1 and 4),
  tags text[] default '{}',
  pillar text not null check (pillar in ('Activities', 'Eating', 'Sightseeing')),
  "order" int default 0,
  created_at timestamptz default now()
);

-- Indexes
create index places_pack_id_idx on places(pack_id);
create index packs_share_code_idx on packs(share_code);
create index packs_user_id_idx on packs(user_id);

-- RLS
alter table packs enable row level security;
alter table places enable row level security;

-- Policies (simple for MVP)
create policy "Public packs are viewable by everyone"
  on packs for select
  using (is_public = true);

create policy "Users can manage their own packs"
  on packs for all
  using (auth.uid() = user_id);

create policy "Places of public packs are viewable"
  on places for select
  using (
    exists (
      select 1 from packs
      where packs.id = places.pack_id
      and packs.is_public = true
    )
  );

create policy "Users can manage places in their packs"
  on places for all
  using (
    exists (
      select 1 from packs
      where packs.id = places.pack_id
      and packs.user_id = auth.uid()
    )
  );
