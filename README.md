# SehatBandhu MVP Scaffold

Hackathon-ready Flutter + Supabase scaffold for a rural telemedicine workflow.

## Included
- Supabase SQL migration (`users`, `doctors`, `appointments`, `medical_records`, storage bucket)
- RLS policies for patient / doctor / admin access
- Edge Function: `verify-doctor`
- Feature-first Flutter folder layout with Riverpod services
- Rural-friendly UI screens and Jitsi consultation scaffold

## Flutter structure

```text
lib/
  core/
    network/
    theme/
    storage/
  features/
    auth/
    appointments/
    consultation/
  shared/
    widgets/
    models/
  services/
```

## Setup
1. Add your Supabase URL + anon key in `lib/services/supabase_service.dart`.
2. Run migration SQL and RLS SQL in Supabase.
3. Deploy edge function:
   ```bash
   supabase functions deploy verify-doctor
   ```
4. Install dependencies and run Flutter app.
