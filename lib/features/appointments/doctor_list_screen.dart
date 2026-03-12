import 'package:flutter/material.dart';

import 'book_appointment_screen.dart';

class DoctorListScreen extends StatelessWidget {
  const DoctorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doctors = [
      ('doc-1', 'Dr. Mehta', 'General Medicine'),
      ('doc-2', 'Dr. Patil', 'Pediatrics'),
      ('doc-3', 'Dr. Khan', 'Dermatology'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Select Doctor')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (_, index) {
          final doctor = doctors[index];
          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const CircleAvatar(child: Icon(Icons.medical_services)),
              title: Text(doctor.$2, style: const TextStyle(fontSize: 20)),
              subtitle: Text(doctor.$3),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BookAppointmentScreen(
                    doctorId: doctor.$1,
                    doctorName: doctor.$2,
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: doctors.length,
      ),
    );
  }
}
