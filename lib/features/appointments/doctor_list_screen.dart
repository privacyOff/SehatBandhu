import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../shared/models/doctor.dart';
import 'book_appointment_screen.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  late final Future<List<Doctor>> _doctorsFuture;

  @override
  void initState() {
    super.initState();
    _doctorsFuture = _fetchDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Doctor')),
      body: FutureBuilder<List<Doctor>>(
        future: _doctorsFuture,
        builder: (context, snapshot) {
          final doctors = snapshot.data ?? const <Doctor>[];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (doctors.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No verified doctors available right now.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (_, index) {
              final doctor = doctors[index];
              return _DoctorCard(
                doctor: doctor,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookAppointmentScreen(
                      doctorId: doctor.id,
                      doctorName:
                          'Dr. ${doctor.specialization.split(' ').isNotEmpty ? doctor.specialization.split(' ').first : 'Doctor'}',
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemCount: doctors.length,
          );
        },
      ),
    );
  }

  Future<List<Doctor>> _fetchDoctors() async {
    try {
      debugPrint('[Doctors] fetching verified doctors');
      final response = await Supabase.instance.client
          .from('doctors')
          .select('id,specialization,bio,verified_status')
          .eq('verified_status', true)
          .limit(50);

      final doctors = (response as List)
          .map((item) => Doctor.fromJson(item as Map<String, dynamic>))
          .toList();
      debugPrint('[Doctors] fetched=${doctors.length}');
      return doctors;
    } catch (error, stackTrace) {
      debugPrint('[Doctors] fetch failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      return const [];
    }
  }
}

class _DoctorCard extends StatelessWidget {
  const _DoctorCard({required this.doctor, required this.onTap});

  final Doctor doctor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: const Icon(Icons.medical_services, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Doctor',
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        Chip(label: Text(doctor.specialization)),
                        const Chip(label: Text('⭐ 4.8')),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor.bio.isEmpty ? 'Trusted specialist' : doctor.bio,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
