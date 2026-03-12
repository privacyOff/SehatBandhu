import 'package:flutter/material.dart';

import '../consultation/video_call_screen.dart';

class DoctorDashboardScreen extends StatelessWidget {
  const DoctorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final assignedAppointments = [
      ('Patient A', '10:00 AM', 'sehatbandhu-demo-room'),
      ('Patient B', '11:30 AM', 'sehatbandhu-demo-room-2'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: assignedAppointments.length,
                itemBuilder: (_, index) {
                  final item = assignedAppointments[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.people),
                      title: Text(item.$1),
                      subtitle: Text(item.$2),
                      trailing: ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VideoCallScreen(
                              meetingLink: item.$3,
                              userDisplayName: 'Doctor',
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.video_call),
                        label: const Text('Start'),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.upload_file),
                label: const Text('Upload Prescription'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
