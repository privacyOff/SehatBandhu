import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../appointments/doctor_dashboard_screen.dart';
import '../appointments/doctor_list_screen.dart';

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
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Text(
                'Welcome',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Enter your details to continue',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.alternate_email_rounded),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                ),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _role,
                decoration: const InputDecoration(
                  labelText: 'Role',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                items: const [
                  DropdownMenuItem(value: 'patient', child: Text('Patient')),
                  DropdownMenuItem(value: 'doctor', child: Text('Doctor')),
                ],
                onChanged: (value) => setState(() => _role = value ?? 'patient'),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _continue,
                  icon: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.login_rounded),
                  label: Text(_loading ? 'Signing in...' : 'Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _continue() async {
    setState(() => _loading = true);
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        _showMessage('Please enter email and password.');
        return;
      }

      debugPrint('[Auth] signIn attempt email=$email role=$_role');
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final userId = Supabase.instance.client.auth.currentUser?.id;
      debugPrint('[Auth] signIn success user=$userId');
    } on AuthException catch (error, stackTrace) {
      debugPrint('[Auth] signIn failed: ${error.message}');
      debugPrintStack(stackTrace: stackTrace);
      _showMessage(error.message);
      return;
    } catch (error, stackTrace) {
      debugPrint('[Auth] unexpected signIn error: $error');
      debugPrintStack(stackTrace: stackTrace);
      _showMessage('Login failed. Please try again.');
      return;
    } finally {
      if (mounted) setState(() => _loading = false);
    }

    if (!mounted) return;
    if (_role == 'doctor') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DoctorDashboardScreen()),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DoctorListScreen()),
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
