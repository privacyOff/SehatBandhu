import 'package:flutter/material.dart';

import '../consultation/video_call_screen.dart';

class DoctorDashboardScreen extends StatelessWidget {
  const DoctorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final assignedAppointments = [
      ('Patient A', '10:00 AM', 'sehatbandhu-demo-room'),
      ('Patient B', '11:30 AM', 'sehatbandhu-demo-room-2'),
      ('Patient C', '2:00 PM', 'sehatbandhu-demo-room-3'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Schedule',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text('${assignedAppointments.length} consultations planned'),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text('Assigned Appointments',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                itemCount: assignedAppointments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, index) {
                  final item = assignedAppointments[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondaryContainer,
                            child: const Icon(Icons.person),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.$1,
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 3),
                                Text('Time: ${item.$2}'),
                              ],
                            ),
                          ),
                          ElevatedButton.icon(
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
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Upload flow scaffolded for integration.')),
                  );
                },
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
