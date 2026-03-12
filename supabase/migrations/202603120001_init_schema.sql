-- Rural Telemedicine MVP schema
create extension if not exists "pgcrypto";

create table if not exists public.users (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null unique,
  phone text,
  role text not null check (role in ('patient', 'doctor', 'admin')) default 'patient',
  verified_status boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.doctors (
  id uuid primary key references public.users(id) on delete cascade,
  specialization text,
  bio text,
  license_no text,
  verified_status boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.appointments (
  id uuid primary key default gen_random_uuid(),
  patient_id uuid not null references public.users(id) on delete cascade,
  doctor_id uuid not null references public.doctors(id) on delete cascade,
  scheduled_at timestamptz not null,
  status text not null default 'pending' check (status in ('pending', 'confirmed', 'completed')),
  meeting_link text,
  created_at timestamptz not null default now()
);

create table if not exists public.medical_records (
  id uuid primary key default gen_random_uuid(),
  patient_id uuid not null references public.users(id) on delete cascade,
  doctor_id uuid not null references public.doctors(id) on delete cascade,
  file_url text not null,
  created_at timestamptz not null default now()
);

create index if not exists appointments_patient_id_idx on public.appointments(patient_id);
create index if not exists appointments_doctor_id_idx on public.appointments(doctor_id);
create index if not exists medical_records_patient_id_idx on public.medical_records(patient_id);
create index if not exists medical_records_doctor_id_idx on public.medical_records(doctor_id);

-- Storage bucket for medical files
insert into storage.buckets (id, name, public)
values ('medical-files', 'medical-files', false)
on conflict (id) do nothing;
