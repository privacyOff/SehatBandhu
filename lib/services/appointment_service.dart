import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/storage/hive_service.dart';
import '../shared/models/appointment.dart';
import 'supabase_service.dart';

final appointmentServiceProvider = Provider<AppointmentService>((ref) {
  return AppointmentService(ref.read(supabaseClientProvider));
});

class AppointmentService {
  AppointmentService(this._client);

  final SupabaseClient _client;

  Future<List<Appointment>> fetchAppointmentsForCurrentUser() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return const [];

    final response = await _client
        .from('appointments')
        .select()
        .or('patient_id.eq.$userId,doctor_id.eq.$userId')
        .order('scheduled_at', ascending: true);

    final appointments = (response as List)
        .map((item) => Appointment.fromJson(item as Map<String, dynamic>))
        .toList();

    final box = HiveService.appointmentCache;
    await box.clear();
    for (final appt in appointments) {
      await box.put(appt.id, appt.toJson());
    }

    return appointments;
  }

  Future<Appointment?> bookAppointment({
    required String doctorId,
    required DateTime scheduledAt,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final meetingLink = 'sehatbandhu-${DateTime.now().millisecondsSinceEpoch}';

    final data = await _client
        .from('appointments')
        .insert({
          'patient_id': userId,
          'doctor_id': doctorId,
          'scheduled_at': scheduledAt.toIso8601String(),
          'meeting_link': meetingLink,
          'status': 'pending',
        })
        .select()
        .single();

    return Appointment.fromJson(data as Map<String, dynamic>);
  }
}
