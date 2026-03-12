-- Enable RLS
alter table public.users enable row level security;
alter table public.doctors enable row level security;
alter table public.appointments enable row level security;
alter table public.medical_records enable row level security;

-- Helpers
create or replace function public.current_user_role()
returns text
language sql
stable
as $$
  select role from public.users where id = auth.uid();
$$;

-- USERS
create policy "users can view own profile"
on public.users for select
using (id = auth.uid() or public.current_user_role() = 'admin');

create policy "users can update own profile"
on public.users for update
using (id = auth.uid() or public.current_user_role() = 'admin')
with check (id = auth.uid() or public.current_user_role() = 'admin');


create policy "users can insert own profile"
on public.users for insert
to authenticated
with check (id = auth.uid());

-- DOCTORS
create policy "doctors profile readable for authenticated"
on public.doctors for select
to authenticated
using (true);

create policy "admin manages doctors"
on public.doctors for all
using (public.current_user_role() = 'admin')
with check (public.current_user_role() = 'admin');

-- APPOINTMENTS
create policy "patients can view own appointments"
on public.appointments for select
using (
  patient_id = auth.uid()
  or public.current_user_role() = 'admin'
  or (doctor_id = auth.uid() and exists (
    select 1 from public.doctors d where d.id = auth.uid() and d.verified_status = true
  ))
);

create policy "patients can create own appointments"
on public.appointments for insert
with check (
  patient_id = auth.uid()
  and exists (
    select 1 from public.doctors d where d.id = doctor_id and d.verified_status = true
  )
);

create policy "doctor updates assigned appointments"
on public.appointments for update
using (
  doctor_id = auth.uid()
  or public.current_user_role() = 'admin'
)
with check (
  doctor_id = auth.uid()
  or public.current_user_role() = 'admin'
);

-- MEDICAL RECORDS
create policy "patients view own medical records"
on public.medical_records for select
using (
  patient_id = auth.uid()
  or public.current_user_role() = 'admin'
  or (
    doctor_id = auth.uid()
    and exists (
      select 1
      from public.appointments a
      where a.patient_id = medical_records.patient_id
      and a.doctor_id = auth.uid()
    )
  )
);

create policy "doctor creates records for own patients"
on public.medical_records for insert
with check (
  (doctor_id = auth.uid() and exists (
    select 1
    from public.appointments a
    where a.patient_id = medical_records.patient_id
    and a.doctor_id = auth.uid()
  ))
  or public.current_user_role() = 'admin'
);

create policy "admin full medical records"
on public.medical_records for all
using (public.current_user_role() = 'admin')
with check (public.current_user_role() = 'admin');

-- Storage RLS for medical-files bucket
create policy "patients read own medical files"
on storage.objects for select
using (
  bucket_id = 'medical-files'
  and (
    auth.uid()::text = (storage.foldername(name))[1]
    or public.current_user_role() = 'admin'
  )
);

create policy "doctor access appointment patient files"
on storage.objects for select
using (
  bucket_id = 'medical-files'
  and public.current_user_role() = 'doctor'
  and exists (
    select 1 from public.appointments a
    where a.doctor_id = auth.uid()
      and a.patient_id::text = (storage.foldername(name))[1]
  )
);

create policy "doctor upload patient files"
on storage.objects for insert
with check (
  bucket_id = 'medical-files'
  and (
    public.current_user_role() = 'admin'
    or (
      public.current_user_role() = 'doctor'
      and exists (
        select 1 from public.appointments a
        where a.doctor_id = auth.uid()
          and a.patient_id::text = (storage.foldername(name))[1]
      )
    )
  )
);
