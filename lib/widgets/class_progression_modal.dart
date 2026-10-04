import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';
import '../services/payment_service.dart';
import '../services/session_lifecycle_service.dart';

/// Celebratory Upgrade Modal for Returning Students transitioning to their next class.
class ClassProgressionModal extends StatefulWidget {
  final UserModel user;

  const ClassProgressionModal({super.key, required this.user});

  @override
  State<ClassProgressionModal> createState() => _ClassProgressionModalState();
}

class _ClassProgressionModalState extends State<ClassProgressionModal> {
  final PaymentService _paymentService = PaymentService();
  final _formKey = GlobalKey<FormState>();

  late String _nextClass;
  late String _selectedBoard;
  String _selectedGateway = 'EasyPaisa';

  final _senderNameController = TextEditingController();
  final _senderAccountController = TextEditingController();
  final _trxIdController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nextClass = SessionLifecycleService.getNextClass(widget.user.currentClass);
    _selectedBoard = widget.user.registeredBoard;
  }

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
    final uid = widget.user.uid.substring(0, 8);
    final tid = _trxIdController.text.trim();

    final message = Uri.encodeComponent(
      'Assalam-o-Alaikum PCSA Admin!\n\nI am a Returning Student upgrading my class:\n• Student: ${widget.user.displayName} (UID: $uid)\n• Class Promotion: Class ${widget.user.currentClass} -> Class $_nextClass ($_selectedBoard)\n• Returning Student Discount Price: Rs. 850\n• Gateway: $_selectedGateway\n• TRX ID: ${tid.isNotEmpty ? tid : "[Pending Submission]"}',
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

  Future<void> _submitPromotionPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final req = PaymentRequest(
        id: '',
        studentUid: widget.user.uid,
        studentEmail: widget.user.email,
        studentName: widget.user.displayName,
        courseId: 'class_promotion_${_selectedBoard}_$_nextClass',
        courseTitle: 'Renewal Class Promotion: Class ${widget.user.currentClass} -> $_nextClass ($_selectedBoard)',
        gateway: _selectedGateway,
        senderName: _senderNameController.text.trim(),
        senderAccount: _senderAccountController.text.trim(),
        transactionId: _trxIdController.text.trim(),
        amount: 850.0, // Returning Student Continuity Discount
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
                Icon(Icons.school, color: Color(0xFF006633)),
                SizedBox(width: 8),
                Text('Class Promotion Submitted'),
              ],
            ),
            content: Text(
              'Congratulations ${widget.user.displayName}! Your Class $_nextClass enrollment request has been submitted. Access will be activated automatically within 1-2 hours, or tap "Verify via WhatsApp" for instant activation.',
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
        constraints: const BoxConstraints(maxWidth: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Celebratory Header Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF004D26),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                        child: const Icon(Icons.stars, color: Color(0xFF004D26), size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Congratulations on Completing Class ${widget.user.currentClass}!',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Welcome to Class $_nextClass 2026–2027 Annual Session',
                              style: const TextStyle(fontSize: 12, color: Colors.amber, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Returning Student Continuity Discount Badge
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber[800]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.card_giftcard, color: Color(0xFF004D26)),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Exclusive Returning Student Continuity Discount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF004D26))),
                            Text('Special Renewal Price: Rs. 850 (Save Rs. 150 off regular price)', style: TextStyle(fontSize: 11, color: Colors.black87)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Gateway Accounts
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('EasyPaisa: Muhammad Rashid (03123656361)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          IconButton(icon: const Icon(Icons.copy, size: 16), onPressed: () => _copyToClipboard('03123656361', 'EasyPaisa')),
                        ],
                      ),
                      const Divider(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('HBL Bank: Muhammad Rashid (00717918821503)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          IconButton(icon: const Icon(Icons.copy, size: 16), onPressed: () => _copyToClipboard('00717918821503', 'HBL Bank')),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Inputs
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedGateway,
                        decoration: const InputDecoration(labelText: 'Gateway', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
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
                        decoration: const InputDecoration(labelText: 'Sender Name', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
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
                        decoration: const InputDecoration(labelText: 'Sender Account No', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _trxIdController,
                        decoration: const InputDecoration(labelText: 'Transaction TRX ID', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
                        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

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
                        onPressed: _isSubmitting ? null : _submitPromotionPayment,
                        icon: _isSubmitting
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.send, size: 18),
                        label: Text(_isSubmitting ? 'Submitting...' : 'Submit Rs. 850 Renewal', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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
