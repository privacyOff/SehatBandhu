import 'package:flutter/material.dart';

import '../appointments/doctor_list_screen.dart';
import '../appointments/doctor_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({required this.languageCode, super.key});

  final String languageCode;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _role = 'patient';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _role,
              items: const [
                DropdownMenuItem(value: 'patient', child: Text('Patient')),
                DropdownMenuItem(value: 'doctor', child: Text('Doctor')),
              ],
              onChanged: (value) => setState(() => _role = value ?? 'patient'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: _continue,
                icon: const Icon(Icons.login),
                label: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _continue() {
    if (_role == 'doctor') {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const DoctorDashboardScreen()));
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DoctorListScreen()),
    );
  }
}
