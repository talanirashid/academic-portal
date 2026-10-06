import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../../core/constants/payment_config.dart';

/// Modal dialog for submitting manual payment proof bound to student UID.
class PackageCheckoutModal extends StatefulWidget {
  final String packageId;
  final String packageName;
  final double amount;

  const PackageCheckoutModal({
    super.key,
    required this.packageId,
    required this.packageName,
    required this.amount,
  });

  @override
  State<PackageCheckoutModal> createState() => _PackageCheckoutModalState();
}

class _PackageCheckoutModalState extends State<PackageCheckoutModal> {
  final _formKey = GlobalKey<FormState>();

  PaymentAccountDetails _selectedChannel = PaymentConfig.jazzCash;
  final _senderPhoneController = TextEditingController();
  final _tidController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _senderPhoneController.dispose();
    _tidController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final callable = FirebaseFunctions.instance.httpsCallable('submitEnrollmentRequest');
      await callable.call({
        'packageId': widget.packageId,
        'packageName': widget.packageName,
        'amount': widget.amount,
        'paymentMethod': _selectedChannel.providerName.toLowerCase(),
        'transactionId': _tidController.text.trim().toUpperCase(),
        'senderPhoneNumber': _senderPhoneController.text.trim(),
      });

      if (mounted) {
        Navigator.pop(context); // Close checkout modal

        // Show green confirmation dialog
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF0F172A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFF006633)),
            ),
            title: const Row(
              children: [
                Icon(Icons.verified, color: Colors.greenAccent, size: 28),
                SizedBox(width: 10),
                Text('Request Submitted!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            content: Text(
              'Thank you! Your transaction ID (${_tidController.text.trim().toUpperCase()}) has been submitted.\n\nOur administration will verify your deposit within 2-4 hours and activate your Pro Pass access automatically.',
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, height: 1.4),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF006633), foregroundColor: Colors.white),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK, Got It!'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Submission Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF334155)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Banner
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.packageName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                          Text('Package Amount: PKR ${widget.amount.toInt()}', style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFF334155), height: 24),

                  // Student Identity Locked Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.lock, color: Colors.amber, size: 14),
                            SizedBox(width: 6),
                            Text('Verified Student Identity (Read-Only)', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('Name: ${user?.displayName ?? "Student"}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                        Text('Email: ${user?.email ?? ""}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                        Text('UID: ${user?.uid ?? ""}', style: const TextStyle(color: Color(0xFF64748B), fontSize: 10)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Payment Method Tabs
                  const Text('Select Payment Channel:', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: PaymentConfig.allChannels.map((channel) {
                      final isSelected = _selectedChannel.providerName == channel.providerName;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: InkWell(
                            onTap: () => setState(() => _selectedChannel = channel),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? channel.brandColor.withValues(alpha: 0.2) : const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: isSelected ? channel.brandColor : const Color(0xFF334155)),
                              ),
                              child: Column(
                                children: [
                                  Icon(channel.icon, color: isSelected ? channel.brandColor : Colors.grey, size: 20),
                                  const SizedBox(height: 4),
                                  Text(
                                    channel.providerName,
                                    style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontWeight: FontWeight.bold, fontSize: 10),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Account Details Display with Copy Button
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _selectedChannel.brandColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _selectedChannel.brandColor.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${_selectedChannel.providerName} Details', style: TextStyle(color: _selectedChannel.brandColor, fontWeight: FontWeight.bold, fontSize: 12)),
                              Text('Title: ${_selectedChannel.accountTitle}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                              Text('Number: ${_selectedChannel.accountNumber}', style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 14)),
                              if (_selectedChannel.iban != null) Text('IBAN: ${_selectedChannel.iban}', style: const TextStyle(color: Colors.white70, fontSize: 10)),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedChannel.brandColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                          onPressed: () => PaymentConfig.copyToClipboard(context, _selectedChannel.accountNumber, '${_selectedChannel.providerName} Number'),
                          icon: const Icon(Icons.copy, size: 14),
                          label: const Text('Copy', style: TextStyle(fontSize: 11)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sender Phone Input
                  TextFormField(
                    controller: _senderPhoneController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Sender Mobile / Account Number',
                      labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                      prefixIcon: Icon(Icons.phone, color: Color(0xFF38BDF8)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF38BDF8))),
                    ),
                    validator: (v) => v == null || v.trim().length < 11 ? 'Enter valid 11-digit sender number' : null,
                  ),
                  const SizedBox(height: 12),

                  // Transaction TID Input
                  TextFormField(
                    controller: _tidController,
                    style: const TextStyle(color: Colors.white),
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: 'Transaction ID / Reference TID',
                      hintText: 'e.g. 012345678912',
                      labelStyle: TextStyle(color: Color(0xFF94A3B8)),
                      prefixIcon: Icon(Icons.receipt_long, color: Color(0xFF38BDF8)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF38BDF8))),
                    ),
                    validator: (v) => v == null || v.trim().length < 6 ? 'Enter valid Transaction ID (TID)' : null,
                  ),
                  const SizedBox(height: 20),

                  // Submit Action
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006633),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _isSubmitting ? null : _submitRequest,
                      child: _isSubmitting
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Submit Enrollment Verification', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
