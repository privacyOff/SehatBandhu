import 'package:flutter/material.dart';

import '../consultation/video_call_screen.dart';

class AppointmentListScreen extends StatelessWidget {
  const AppointmentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointments = [
      ('Dr. Mehta', 'Today, 4:00 PM', 'sehatbandhu-demo-room'),
      ('Dr. Patil', 'Tomorrow, 11:00 AM', 'sehatbandhu-demo-room-2'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('My Appointments')),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (_, index) {
          final appointment = appointments[index];
          return Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              title: Text(appointment.$1),
              subtitle: Text(appointment.$2),
              trailing: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoCallScreen(
                      meetingLink: appointment.$3,
                      userDisplayName: 'Patient',
                    ),
                  ),
                ),
                child: const Text('Join'),
              ),
            ),
          );
        },
      ),
    );
  }
}
