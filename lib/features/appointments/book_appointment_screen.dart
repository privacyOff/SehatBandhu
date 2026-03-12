import 'package:flutter/material.dart';

import '../consultation/video_call_screen.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({
    required this.doctorId,
    required this.doctorName,
    super.key,
  });

  final String doctorId;
  final String doctorName;

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.doctorName,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Colors.black26),
              ),
              leading: const Icon(Icons.calendar_month, size: 32),
              title: Text(
                '${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}',
                style: const TextStyle(fontSize: 20),
              ),
              onTap: _pickDate,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: _bookAndNavigate,
                icon: const Icon(Icons.check_circle),
                label: const Text('Book & Join'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _bookAndNavigate() {
    const demoMeetingLink = 'sehatbandhu-demo-room';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const VideoCallScreen(
          meetingLink: demoMeetingLink,
          userDisplayName: 'Patient',
        ),
      ),
    );
  }
}
