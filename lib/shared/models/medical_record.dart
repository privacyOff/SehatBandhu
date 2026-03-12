class MedicalRecord {
  final String id;
  final String patientId;
  final String doctorId;
  final String fileUrl;

  const MedicalRecord({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.fileUrl,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) => MedicalRecord(
        id: json['id'] as String,
        patientId: json['patient_id'] as String,
        doctorId: json['doctor_id'] as String,
        fileUrl: json['file_url'] as String,
      );
}
