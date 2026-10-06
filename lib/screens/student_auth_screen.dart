import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

/// Full-page Student Authentication Screen for URL routing (/login and /register).
class StudentAuthScreen extends StatefulWidget {
  final bool initialIsSignUp;

  const StudentAuthScreen({super.key, this.initialIsSignUp = false});

  @override
  State<StudentAuthScreen> createState() => _StudentAuthScreenState();
}

class _StudentAuthScreenState extends State<StudentAuthScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  late bool _isSignUp;
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otherBoardController = TextEditingController();

  String _selectedBoard = 'Federal Board (FBISE - Islamabad)';
  String _selectedClass = 'Class 11th (HSSC Part-I / 1st Year / ICS)';

  final List<String> _boards = [
    'Federal Board (FBISE - Islamabad)',
    'Sindh Board (STBB - All Sindh BISEs)',
    'Other Boards (Punjab / KPK / Balochistan / AJK)',
  ];

  final List<String> _classes = [
    'Class 9th (SSC Part-I / Matric)',
    'Class 10th (SSC Part-II / Matric)',
    'Class 11th (HSSC Part-I / 1st Year / ICS)',
    'Class 12th (HSSC Part-II / 2nd Year / ICS)',
  ];

  @override
  void initState() {
    super.initState();
    _isSignUp = widget.initialIsSignUp;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _otherBoardController.dispose();
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isSignUp ? 'Student account registered successfully!' : 'Signed in successfully!'),
            backgroundColor: const Color(0xFF006633),
          ),
        );
        Navigator.pop(context);
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

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      await AuthService.signInWithGoogleWeb(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google Sign-In failed: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _sendPasswordReset() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address first.')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset email sent to ${_emailController.text.trim()}!'),
            backgroundColor: const Color(0xFF006633),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reset error: ${e.toString()}')),
        );
      }
    }
  }

  List<Widget> _buildSignUpFormFields() {
    if (!_isSignUp) return [];

    return [
      TextFormField(
        controller: _nameController,
        decoration: const InputDecoration(
          labelText: 'Full Student Name',
          prefixIcon: Icon(Icons.person, color: Color(0xFF006633)),
          border: OutlineInputBorder(),
        ),
        validator: (v) => v == null || v.trim().length < 3 ? 'Enter valid name (3+ chars)' : null,
      ),
      const SizedBox(height: 14),
      TextFormField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
          labelText: 'WhatsApp Mobile Number (e.g. 03001234567)',
          prefixIcon: Icon(Icons.phone, color: Color(0xFF006633)),
          border: OutlineInputBorder(),
        ),
        validator: (v) => v == null || v.trim().length < 11 ? 'Enter valid 11-digit mobile number' : null,
      ),
      const SizedBox(height: 14),
      DropdownButtonFormField<String>(
        initialValue: _selectedBoard,
        decoration: const InputDecoration(
          labelText: 'Educational Board',
          border: OutlineInputBorder(),
        ),
        items: _boards.map((b) => DropdownMenuItem(value: b, child: Text(b, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)))).toList(),
        onChanged: (val) {
          if (val != null) setState(() => _selectedBoard = val);
        },
      ),
      const SizedBox(height: 4),
      if (_selectedBoard.contains('Sindh Board'))
        Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(6)),
          child: const Text(
            'ℹ️ Covers Karachi, Hyderabad, Sukkur, Larkana, Mirpurkhas, and SBA under the standardized provincial STBB curriculum.',
            style: TextStyle(fontSize: 11, color: Colors.blue),
          ),
        ),
      if (_selectedBoard.contains('Other Boards'))
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: TextFormField(
            controller: _otherBoardController,
            decoration: const InputDecoration(
              labelText: 'Specify Board Name (e.g. BISE Lahore, BISE Peshawar)',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      DropdownButtonFormField<String>(
        initialValue: _selectedClass,
        decoration: const InputDecoration(
          labelText: 'Class / Academic Stream',
          border: OutlineInputBorder(),
        ),
        items: _classes.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)))).toList(),
        onChanged: (val) {
          if (val != null) setState(() => _selectedClass = val);
        },
      ),
      const SizedBox(height: 14),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSignUp ? 'Student Registration' : 'Student Sign In'),
        backgroundColor: const Color(0xFF004D26),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF006633),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.school, color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _isSignUp ? 'Student Account Registration' : 'Welcome Back Student',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                                ),
                                const Text(
                                  'Pakistan Computer Science Academy',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),

                      ..._buildSignUpFormFields(),

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
                      const SizedBox(height: 14),

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

                      if (!_isSignUp)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _sendPasswordReset,
                            child: const Text('Forgot Password?', style: TextStyle(color: Color(0xFF006633), fontSize: 12)),
                          ),
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
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : Text(_isSignUp ? 'Register Account' : 'Sign In', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 14),

                      const Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('OR', style: TextStyle(color: Colors.grey, fontSize: 12))),
                          Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 14),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: _isLoading ? null : _handleGoogleSignIn,
                          icon: const Icon(Icons.g_mobiledata, color: Colors.red, size: 30),
                          label: const Text('Continue with Google Account', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_isSignUp ? 'Already registered?' : 'New student?'),
                          TextButton(
                            onPressed: () => setState(() => _isSignUp = !_isSignUp),
                            child: Text(_isSignUp ? 'Sign In Here' : 'Register Free Account', style: const TextStyle(color: Color(0xFF006633), fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
