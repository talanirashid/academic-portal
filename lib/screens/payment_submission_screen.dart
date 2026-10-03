import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/course_model.dart';
import '../models/payment_request_model.dart';
import '../services/auth_service.dart';
import '../services/payment_service.dart';

/// Full-page Payment Submission Screen for URL routing (/payment).
class PaymentSubmissionScreen extends StatefulWidget {
  final Course? course;

  const PaymentSubmissionScreen({super.key, this.course});

  @override
  State<PaymentSubmissionScreen> createState() => _PaymentSubmissionScreenState();
}

class _PaymentSubmissionScreenState extends State<PaymentSubmissionScreen> {
  final AuthService _authService = AuthService();
  final PaymentService _paymentService = PaymentService();
  final _formKey = GlobalKey<FormState>();

  String _selectedGateway = 'EasyPaisa';
  final _senderNameController = TextEditingController();
  final _senderAccountController = TextEditingController();
  final _trxIdController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _senderNameController.dispose();
    _senderAccountController.dispose();
    _trxIdController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard!'),
        backgroundColor: const Color(0xFF006633),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _submitPayment() async {
    if (!_formKey.currentState!.validate()) return;

    final user = _authService.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in or register before submitting payment.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final req = PaymentRequest(
        id: '',
        studentUid: user.uid,
        studentEmail: user.email ?? 'guest@academicportal.pk',
        studentName: user.displayName ?? _senderNameController.text.trim(),
        courseId: widget.course?.id ?? 'cs_xi_fbise',
        courseTitle: widget.course?.title ?? 'FBISE Class 11 CS Full Access',
        gateway: _selectedGateway,
        senderName: _senderNameController.text.trim(),
        senderAccount: _senderAccountController.text.trim(),
        transactionId: _trxIdController.text.trim(),
        amount: 1500.0,
        status: 'pending',
      );

      await _paymentService.submitPaymentRequest(req);

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFF006633)),
                SizedBox(width: 8),
                Text('Payment Verification Sent'),
              ],
            ),
            content: const Text(
              'Your TRX ID and payment details have been submitted to our administration team. Course access will be unlocked automatically upon verification (usually within 1-2 hours).',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF006633))),
              )
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Submission error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual Payment Verification'),
        backgroundColor: const Color(0xFF004D26),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
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
                          const Icon(Icons.verified_user, color: Color(0xFF006633), size: 32),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.course != null
                                      ? 'Unlock ${widget.course!.title}'
                                      : 'Unlock Premium Course Access',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                                ),
                                const Text(
                                  'EasyPaisa & HBL Bank Verification',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Send payment to either EasyPaisa or HBL Bank account below and submit your TRX ID for instant access verification:',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                      const SizedBox(height: 16),

                      // EasyPaisa Account Details
                      _buildAccountCard(
                        gatewayName: 'EasyPaisa Account',
                        title: PaymentService.easyPaisaTitle,
                        number: PaymentService.easyPaisaNumber,
                        color: const Color(0xFF25D366),
                      ),
                      const SizedBox(height: 10),

                      // HBL Bank Account Details
                      _buildAccountCard(
                        gatewayName: 'HBL Bank Account',
                        title: PaymentService.hblTitle,
                        number: PaymentService.hblAccountNumber,
                        color: const Color(0xFF004D26),
                      ),

                      const Divider(height: 32, thickness: 1),

                      // Submission Form
                      DropdownButtonFormField<String>(
                        initialValue: _selectedGateway,
                        decoration: const InputDecoration(
                          labelText: 'Selected Payment Method',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'EasyPaisa', child: Text('EasyPaisa Transfer')),
                          DropdownMenuItem(value: 'HBL Bank', child: Text('HBL Bank Transfer')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedGateway = val);
                        },
                      ),
                      const SizedBox(height: 14),

                      TextFormField(
                        controller: _senderNameController,
                        decoration: const InputDecoration(
                          labelText: 'Sender Account Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Enter sender name' : null,
                      ),
                      const SizedBox(height: 14),

                      TextFormField(
                        controller: _senderAccountController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Sender Mobile/Account Number',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Enter account number' : null,
                      ),
                      const SizedBox(height: 14),

                      TextFormField(
                        controller: _trxIdController,
                        decoration: const InputDecoration(
                          labelText: 'Transaction ID / TRX ID',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Enter transaction ID' : null,
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF006633),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: _isSubmitting ? null : _submitPayment,
                          icon: _isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Icon(Icons.send),
                          label: Text(_isSubmitting ? 'Submitting...' : 'Submit TRX ID for Verification', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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

  Widget _buildAccountCard({
    required String gatewayName,
    required String title,
    required String number,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(gatewayName, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13)),
              const SizedBox(height: 2),
              Text('Title: $title', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              Text('No: $number', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 20),
            tooltip: 'Copy Number',
            onPressed: () => _copyToClipboard(number, gatewayName),
          ),
        ],
      ),
    );
  }
}
