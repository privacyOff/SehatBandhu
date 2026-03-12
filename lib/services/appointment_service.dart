import 'package:flutter/foundation.dart';
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
    if (userId == null) {
      debugPrint('[Appointments] fetch skipped: no authenticated user');
      return const [];
    }

    try {
      debugPrint('[Appointments] fetching for user=$userId');
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
      debugPrint('[Appointments] fetched=${appointments.length} cached=true');
      return appointments;
    } on PostgrestException catch (error, stackTrace) {
      debugPrint('[Appointments] fetch failed: ${error.message} ${error.details}');
      debugPrintStack(stackTrace: stackTrace);
      return _cachedAppointments();
    } catch (error, stackTrace) {
      debugPrint('[Appointments] unexpected fetch error: $error');
      debugPrintStack(stackTrace: stackTrace);
      return _cachedAppointments();
    }
  }

  Future<Appointment?> bookAppointment({
    required String doctorId,
    required DateTime scheduledAt,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      debugPrint('[Appointments] booking blocked: no authenticated user');
      return null;
    }

    try {
      final meetingLink = 'sehatbandhu-${DateTime.now().millisecondsSinceEpoch}';
      debugPrint(
        '[Appointments] booking patient=$userId doctor=$doctorId date=${scheduledAt.toIso8601String()}',
      );

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

      final appointment = Appointment.fromJson(data as Map<String, dynamic>);
      debugPrint('[Appointments] booking success id=${appointment.id}');
      return appointment;
    } on PostgrestException catch (error, stackTrace) {
      debugPrint('[Appointments] booking failed: ${error.message} ${error.details}');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    } catch (error, stackTrace) {
      debugPrint('[Appointments] unexpected booking error: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  List<Appointment> _cachedAppointments() {
    final box = HiveService.appointmentCache;
    return box.values
        .map((item) => Appointment.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
