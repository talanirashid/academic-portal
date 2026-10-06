import 'package:flutter/material.dart';
import '../../curriculum/models/curriculum_stream.dart';
import '../repositories/auth_repository.dart';

/// Dark Luxury Student Registration Screen (/register).
class StudentRegisterScreen extends StatefulWidget {
  const StudentRegisterScreen({super.key});

  @override
  State<StudentRegisterScreen> createState() => _StudentRegisterScreenState();
}

class _StudentRegisterScreenState extends State<StudentRegisterScreen> {
  final AuthRepository _repository = AuthRepository();
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  BoardStream _selectedBoard = BoardStream.stbb;
  AcademicClass _selectedClass = AcademicClass.class11;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _repository.signUpStudent(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _fullNameController.text.trim(),
        board: _selectedBoard,
        targetClass: _selectedClass,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account registered successfully! Welcome to PCSA Academy.'),
            backgroundColor: Color(0xFF006633),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark slate
      appBar: AppBar(
        title: const Text('Student Account Registration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              color: const Color(0xFF1E293B),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF334155)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.school, color: Colors.amberAccent, size: 32),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('PCSA Student Portal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                              Text('Mehrzaad Technologies Educational Hub', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                      const Divider(color: Color(0xFF334155), height: 32),

                      // Full Name Input
                      TextFormField(
                        controller: _fullNameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Full Student Name',
                          labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                          prefixIcon: Icon(Icons.person, color: Color(0xFF38BDF8)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF38BDF8))),
                        ),
                        validator: (v) => v == null || v.trim().length < 3 ? 'Name must be at least 3 characters' : null,
                      ),
                      const SizedBox(height: 14),

                      // Email Input
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Student Email Address',
                          labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                          prefixIcon: Icon(Icons.email, color: Color(0xFF38BDF8)),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF38BDF8))),
                        ),
                        validator: (v) => v == null || !v.contains('@') ? 'Enter a valid email address' : null,
                      ),
                      const SizedBox(height: 14),

                      // Password Input
                      TextFormField(
                        controller: _passwordController,
                        style: const TextStyle(color: Colors.white),
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Create Password',
                          labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
                          prefixIcon: const Icon(Icons.lock, color: Color(0xFF38BDF8)),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF38BDF8))),
                        ),
                        validator: (v) => v == null || v.length < 6 ? 'Password must be 6+ characters' : null,
                      ),
                      const SizedBox(height: 16),

                      // Strict Board Segment Selector
                      const Text('Select Educational Board Authority:', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ChoiceChip(
                              label: const Text('Sindh Board (STBB)'),
                              selected: _selectedBoard == BoardStream.stbb,
                              selectedColor: const Color(0xFF004D26),
                              labelStyle: TextStyle(color: _selectedBoard == BoardStream.stbb ? Colors.white : Colors.white70, fontWeight: FontWeight.bold, fontSize: 12),
                              onSelected: (_) => setState(() => _selectedBoard = BoardStream.stbb),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ChoiceChip(
                              label: const Text('Federal Board (FBISE)'),
                              selected: _selectedBoard == BoardStream.fbise,
                              selectedColor: const Color(0xFF0284C7),
                              labelStyle: TextStyle(color: _selectedBoard == BoardStream.fbise ? Colors.white : Colors.white70, fontWeight: FontWeight.bold, fontSize: 12),
                              onSelected: (_) => setState(() => _selectedBoard = BoardStream.fbise),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Class Stream Chips
                      const Text('Select Target Class Grade:', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: AcademicClass.values.map((c) {
                          final isSelected = _selectedClass == c;
                          return ChoiceChip(
                            label: Text(c.uiLabel),
                            selected: isSelected,
                            selectedColor: Colors.amber[800],
                            labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.white70, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 11),
                            onSelected: (_) => setState(() => _selectedClass = c),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Submit Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF006633),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: _isLoading ? null : _handleRegister,
                          child: _isLoading
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text('Create Student Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Center(
                        child: Text(
                          'Protected under Mehrzaad Tech Data Safeguards • Privacy Policy',
                          style: TextStyle(color: Color(0xFF64748B), fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
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
