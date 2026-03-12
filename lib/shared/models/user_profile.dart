class UserProfile {
  final String id;
  final String email;
  final String? phone;
  final String role;
  final bool verifiedStatus;

  const UserProfile({
    required this.id,
    required this.email,
    required this.role,
    required this.verifiedStatus,
    this.phone,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String?,
        role: json['role'] as String,
        verifiedStatus: json['verified_status'] as bool? ?? false,
      );
}
