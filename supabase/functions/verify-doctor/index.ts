import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.49.1';

interface VerifyDoctorPayload {
  doctor_id: string;
  action: 'APPROVE' | 'REJECT';
}

Deno.serve(async (req: Request) => {
  try {
    if (req.method !== 'POST') {
      return new Response('Method not allowed', { status: 405 });
    }

    const authHeader = req.headers.get('Authorization');
    if (!authHeader) {
      return new Response('Missing Authorization header', { status: 401 });
    }

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      { global: { headers: { Authorization: authHeader } } },
    );

    const adminClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
    );

    const {
      data: { user },
      error: authError,
    } = await supabase.auth.getUser();

    if (authError || !user) {
      return new Response('Unauthorized', { status: 401 });
    }

    const { data: profile, error: profileError } = await adminClient
      .from('users')
      .select('role')
      .eq('id', user.id)
      .single();

    if (profileError || profile?.role !== 'admin') {
      return new Response('Admin role required', { status: 403 });
    }

    const payload = (await req.json()) as VerifyDoctorPayload;
    if (!payload?.doctor_id || !payload?.action) {
      return new Response('doctor_id and action are required', { status: 400 });
    }

    const verified = payload.action === 'APPROVE';

    const { error: updateDoctorError } = await adminClient
      .from('doctors')
      .update({ verified_status: verified })
      .eq('id', payload.doctor_id);

    if (updateDoctorError) {
      return new Response(updateDoctorError.message, { status: 400 });
    }

    const { error: updateUserError } = await adminClient
      .from('users')
      .update({ verified_status: verified })
      .eq('id', payload.doctor_id)
      .eq('role', 'doctor');

    if (updateUserError) {
      return new Response(updateUserError.message, { status: 400 });
    }

    return Response.json({
      success: true,
      doctor_id: payload.doctor_id,
      action: payload.action,
      verified_status: verified,
    });
  } catch (error) {
    return new Response(`Unexpected error: ${String(error)}`, { status: 500 });
  }
});
