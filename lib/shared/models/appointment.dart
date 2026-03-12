class Appointment {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime scheduledAt;
  final String status;
  final String meetingLink;

  const Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.scheduledAt,
    required this.status,
    required this.meetingLink,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        id: json['id'] as String,
        patientId: json['patient_id'] as String,
        doctorId: json['doctor_id'] as String,
        scheduledAt: DateTime.parse(json['scheduled_at'] as String),
        status: json['status'] as String,
        meetingLink: json['meeting_link'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'patient_id': patientId,
        'doctor_id': doctorId,
        'scheduled_at': scheduledAt.toIso8601String(),
        'status': status,
        'meeting_link': meetingLink,
      };
}
