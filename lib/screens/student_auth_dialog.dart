import 'package:flutter/material.dart';
import '../services/auth_service.dart';

/// Modal dialog for Student Account Registration and Email Sign In.
class StudentAuthDialog extends StatefulWidget {
  const StudentAuthDialog({super.key});

  @override
  State<StudentAuthDialog> createState() => _StudentAuthDialogState();
}

class _StudentAuthDialogState extends State<StudentAuthDialog> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool _isSignUp = false;
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  String _selectedBoard = 'FBISE';
  String _selectedGrade = 'Class 11 / HSSC-I';

  final List<String> _boards = ['FBISE', 'Sindh Board', 'Karachi Board', 'Other Board'];
  final List<String> _grades = ['Class 11 / HSSC-I', 'Class 12 / HSSC-II', 'Matric (9th/10th)'];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submitAuth() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isSignUp) {
        await _authService.signUpWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _nameController.text.trim(),
        );
      } else {
        await _authService.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isSignUp ? 'Student account created successfully!' : 'Signed in successfully!'),
            backgroundColor: const Color(0xFF006633),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authentication error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.school, size: 32, color: Color(0xFF006633)),
                    const SizedBox(width: 10),
                    Text(
                      _isSignUp ? 'Student Account Registration' : 'Student Login',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _isSignUp
                      ? 'Register to access free curriculum lectures, keybooks, and track your board preparation progress.'
                      : 'Sign in to access your enrolled courses and saved study progress.',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),

                if (_isSignUp) ...[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Student Name',
                      prefixIcon: Icon(Icons.person, color: Color(0xFF006633)),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Please enter your name' : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedBoard,
                          decoration: const InputDecoration(
                            labelText: 'Board',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          ),
                          items: _boards.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedBoard = val);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedGrade,
                          decoration: const InputDecoration(
                            labelText: 'Class Grade',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                          ),
                          items: _grades.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedGrade = val);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email, color: Color(0xFF006633)),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || !v.contains('@') ? 'Enter a valid email' : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock, color: Color(0xFF006633)),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.length < 6 ? 'Password must be 6+ characters' : null,
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006633),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _isLoading ? null : _submitAuth,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(_isSignUp ? 'Create Student Account' : 'Sign In', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_isSignUp ? 'Already registered?' : 'New student?'),
                    TextButton(
                      onPressed: () {
                        setState(() => _isSignUp = !_isSignUp);
                      },
                      child: Text(
                        _isSignUp ? 'Sign In Here' : 'Register Account',
                        style: const TextStyle(color: Color(0xFF006633), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
