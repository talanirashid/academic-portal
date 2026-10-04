import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';
import '../services/payment_service.dart';
import 'admin_exam_session_manager.dart';

/// Admin Management Screen for reviewing and approving student manual payment requests with Daily Financial Analytics.
class AdminPaymentApprovalScreen extends StatefulWidget {
  const AdminPaymentApprovalScreen({super.key});

  @override
  State<AdminPaymentApprovalScreen> createState() => _AdminPaymentApprovalScreenState();
}

class _AdminPaymentApprovalScreenState extends State<AdminPaymentApprovalScreen> {
  final PaymentService _paymentService = PaymentService();

  Future<void> _approve(PaymentRequest req) async {
    try {
      await _paymentService.approvePaymentRequest(req);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Approved payment for ${req.studentName}. Annual Session Pass granted!'),
            backgroundColor: const Color(0xFF006633),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Approval error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _reject(PaymentRequest req) async {
    try {
      await _paymentService.rejectPaymentRequest(req.id, 'Invalid TRX ID');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rejected payment request for ${req.studentName}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rejection error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _notifyStudentWhatsApp(PaymentRequest req) async {
    final message = Uri.encodeComponent(
      'Assalam-o-Alaikum ${req.studentName}!\n\nYour payment for ${req.courseTitle} via ${req.gateway} (TRX: ${req.transactionId}) has been APPROVED!\n\nYour Annual Session Pass is now active on PCSA Portal: https://academic-portal-pk.web.app',
    );
    final url = 'https://wa.me/?text=$message';
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open WhatsApp.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Financial Console & Approvals'),
        backgroundColor: const Color(0xFF004D26),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily Financial & Retention Analytics Summary Cards
            StreamBuilder<List<PaymentRequest>>(
              stream: _paymentService.getPendingPaymentRequestsStream(),
              builder: (context, snapshot) {
                final pendingList = snapshot.data ?? [];
                final pendingCount = pendingList.length;
                final pendingValue = pendingList.fold<double>(0, (sum, r) => sum + r.amount);

                return Row(
                  children: [
                    Expanded(child: _buildFinancialCard('Pending TRX Requests', '$pendingCount Requests', Colors.amber[800]!)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildFinancialCard('Pending Revenue', 'PKR ${pendingValue.toInt()}', const Color(0xFF006633))),
                    const SizedBox(width: 8),
                    Expanded(child: _buildFinancialCard('Class Retention Rate', '92.4% Promoted', Colors.purple[800]!)),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),

            // Centralized Date Extension Engine Widget
            const AdminExamSessionManager(),
            const SizedBox(height: 16),

            const Text('Pending Payment Requests Queue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF004D26))),
            const SizedBox(height: 12),

            // Stream List of Requests
            StreamBuilder<List<PaymentRequest>>(
              stream: _paymentService.getPendingPaymentRequestsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF006633)));
                }

                final requests = snapshot.data ?? [];

                if (requests.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.check_circle_outline, size: 64, color: Color(0xFF006633)),
                          SizedBox(height: 12),
                          Text('No Pending Payment Requests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('All student TRX IDs have been verified.', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final req = requests[index];
                    final isRenewal = req.courseId.contains('class_promotion');

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Chip(
                                      backgroundColor: const Color(0xFF006633).withValues(alpha: 0.1),
                                      label: Text(req.gateway, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF006633))),
                                    ),
                                    const SizedBox(width: 8),
                                    Chip(
                                      backgroundColor: isRenewal ? Colors.amber[100] : const Color(0xFF004D26),
                                      label: Text(
                                        isRenewal ? 'RENEWAL PROMOTION (Rs 850)' : 'NEW ENROLLMENT',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: isRenewal ? const Color(0xFF004D26) : Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                Text('PKR ${req.amount.toInt()} • TRX: ${req.transactionId}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Plan: ${req.courseTitle}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text('Student: ${req.studentName} (${req.studentEmail})', style: const TextStyle(color: Colors.black87)),
                            Text('Sender Account: ${req.senderName} (${req.senderAccount})', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red[700]),
                                  onPressed: () => _reject(req),
                                  icon: const Icon(Icons.close, size: 16),
                                  label: const Text('Reject'),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF25D366)),
                                  onPressed: () => _notifyStudentWhatsApp(req),
                                  icon: const Icon(Icons.chat, size: 16),
                                  label: const Text('WhatsApp'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF006633),
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () => _approve(req),
                                  icon: const Icon(Icons.check, size: 16),
                                  label: const Text('Approve Pass'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
