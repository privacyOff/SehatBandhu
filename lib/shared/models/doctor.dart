class Doctor {
  final String id;
  final String specialization;
  final String bio;
  final bool verifiedStatus;

  const Doctor({
    required this.id,
    required this.specialization,
    required this.bio,
    required this.verifiedStatus,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        id: json['id'] as String,
        specialization: json['specialization'] as String? ?? 'General Physician',
        bio: json['bio'] as String? ?? '',
        verifiedStatus: json['verified_status'] as bool? ?? false,
      );
}
