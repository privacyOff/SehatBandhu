import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/appointment_service.dart';
import '../consultation/video_call_screen.dart';

class BookAppointmentScreen extends ConsumerStatefulWidget {
  const BookAppointmentScreen({
    required this.doctorId,
    required this.doctorName,
    super.key,
  });

  final String doctorId;
  final String doctorName;

  @override
  ConsumerState<BookAppointmentScreen> createState() =>
      _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends ConsumerState<BookAppointmentScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.doctorName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Choose a date and confirm your visit.',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 18),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.black26),
              ),
              tileColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: const Icon(Icons.calendar_month, size: 32),
              title: const Text('Appointment Date'),
              subtitle: Text(
                '${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              onTap: _pickDate,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: _loading ? null : _bookAndNavigate,
                icon: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_circle),
                label: Text(_loading ? 'Booking...' : 'Book & Join'),
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

  Future<void> _bookAndNavigate() async {
    setState(() => _loading = true);
    try {
      final appointment = await ref.read(appointmentServiceProvider).bookAppointment(
            doctorId: widget.doctorId,
            scheduledAt: _selectedDate,
          );

      if (appointment == null) {
        _showMessage('Please login first to create an appointment.');
        return;
      }

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoCallScreen(
            meetingLink: appointment.meetingLink,
            userDisplayName: 'Patient',
          ),
        ),
      );
    } catch (error) {
      _showMessage('Booking failed: $error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
