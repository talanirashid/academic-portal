import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/payment_request_model.dart';
import '../services/auth_service.dart';
import '../services/payment_service.dart';

/// High-converting "Upgrade to PCSA Pro" Pricing Modal & Local Payment Gateway.
class PricingModal extends StatefulWidget {
  const PricingModal({super.key});

  @override
  State<PricingModal> createState() => _PricingModalState();
}

class _PricingModalState extends State<PricingModal> {
  final AuthService _authService = AuthService();
  final PaymentService _paymentService = PaymentService();
  final _formKey = GlobalKey<FormState>();

  String _selectedPlan = 'semesterPass'; // 'semesterPass' (Rs 999) or 'practicalPass' (Rs 499)
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

  Future<void> _launchWhatsAppActivation() async {
    final user = _authService.currentUser;
    final uid = user?.uid.substring(0, 8) ?? 'GUEST';
    final planName = _selectedPlan == 'semesterPass' ? 'Rs. 999 Single Subject Semester Pass' : 'Rs. 499 Emergency Practical Pass';
    final tid = _trxIdController.text.trim();

    final message = Uri.encodeComponent(
      'Assalam-o-Alaikum PCSA Admin!\n\nI want 5-Min Instant Activation for my Pro Pass:\n• Student UID: $uid\n• Selected Plan: $planName\n• Payment Gateway: $_selectedGateway\n• TRX ID: ${tid.isNotEmpty ? tid : "[Pending Submission]"}',
    );

    final url = 'https://wa.me/923123656361?text=$message';
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open WhatsApp.')),
        );
      }
    }
  }

  Future<void> _submitPayment() async {
    if (!_formKey.currentState!.validate()) return;

    final user = _authService.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please register or log in before submitting payment.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final double price = _selectedPlan == 'semesterPass' ? 999.0 : 499.0;
      final planTitle = _selectedPlan == 'semesterPass' ? 'Semester Pro Pass (Rs 999)' : 'Practical & Viva Pass (Rs 499)';

      final req = PaymentRequest(
        id: '',
        studentUid: user.uid,
        studentEmail: user.email ?? 'guest@academicportal.pk',
        studentName: user.displayName ?? _senderNameController.text.trim(),
        courseId: _selectedPlan,
        courseTitle: planTitle,
        gateway: _selectedGateway,
        senderName: _senderNameController.text.trim(),
        senderAccount: _senderAccountController.text.trim(),
        transactionId: _trxIdController.text.trim(),
        amount: price,
        status: 'pending',
      );

      await _paymentService.submitPaymentRequest(req);

      if (mounted) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFF006633)),
                SizedBox(width: 8),
                Text('TRX Verification Sent'),
              ],
            ),
            content: const Text(
              'Your TRX ID has been submitted to PCSA Administration. Access will be unlocked automatically upon verification within 1-2 hours, or tap "Verify via WhatsApp" for instant 5-min activation.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.star, color: Color(0xFF004D26), size: 24),
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Upgrade to PCSA Pro', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF004D26))),
                            Text('FBISE & STBB High-Converting Freemium Pass', style: TextStyle(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Pricing Cards Selector
                Row(
                  children: [
                    Expanded(
                      child: _buildPricingCard(
                        id: 'semesterPass',
                        title: 'Semester Pro Pass',
                        price: 'Rs. 999',
                        subtitle: 'Full Class XI/XII Access until 2026 Board Exams',
                        isBestValue: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildPricingCard(
                        id: 'practicalPass',
                        title: 'Emergency Practical Pass',
                        price: 'Rs. 499',
                        subtitle: 'Practical Hub, Lab Code Vault & 100 Viva Q&As',
                        isBestValue: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Payment Account Details
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF004D26).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF004D26).withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('EasyPaisa Account: Muhammad Rashid', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF004D26))),
                              Text('03123656361', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 18),
                            onPressed: () => _copyToClipboard('03123656361', 'EasyPaisa Number'),
                          ),
                        ],
                      ),
                      const Divider(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('HBL Bank Account: Muhammad Rashid', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF004D26))),
                              Text('00717918821503', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 18),
                            onPressed: () => _copyToClipboard('00717918821503', 'HBL Account Number'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Form Fields
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedGateway,
                        decoration: const InputDecoration(labelText: 'Gateway', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
                        items: const [
                          DropdownMenuItem(value: 'EasyPaisa', child: Text('EasyPaisa')),
                          DropdownMenuItem(value: 'HBL Bank', child: Text('HBL Bank')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedGateway = val);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _senderNameController,
                        decoration: const InputDecoration(labelText: 'Sender Name', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _senderAccountController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(labelText: 'Sender Account No', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _trxIdController,
                        decoration: const InputDecoration(labelText: 'Transaction TRX ID', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF25D366),
                          side: const BorderSide(color: Color(0xFF25D366)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: _launchWhatsAppActivation,
                        icon: const Icon(Icons.chat, size: 18),
                        label: const Text('Verify via WhatsApp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF006633),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: _isSubmitting ? null : _submitPayment,
                        icon: _isSubmitting
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.send, size: 18),
                        label: Text(_isSubmitting ? 'Submitting...' : 'Submit TRX ID', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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

  Widget _buildPricingCard({
    required String id,
    required String title,
    required String price,
    required String subtitle,
    required bool isBestValue,
  }) {
    final isSelected = _selectedPlan == id;
    return InkWell(
      onTap: () => setState(() => _selectedPlan = id),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF004D26) : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.amber : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isSelected ? Colors.white : Colors.black87),
                ),
                if (isBestValue)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(4)),
                    child: const Text('BEST VALUE', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black)),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(price, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isSelected ? Colors.amber : const Color(0xFF004D26))),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(fontSize: 10, color: isSelected ? Colors.white70 : Colors.grey[700])),
          ],
        ),
      ),
    );
  }
}
