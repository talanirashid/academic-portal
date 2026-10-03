import 'package:flutter/material.dart';
import '../models/payment_request_model.dart';
import '../services/payment_service.dart';

/// Admin Management Screen for reviewing and approving student manual payment requests (EasyPaisa & HBL).
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
            content: Text('Approved payment for ${req.studentName}. Access granted!'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Payment Approval Console'),
        backgroundColor: const Color(0xFF004D26),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<PaymentRequest>>(
        stream: _paymentService.getPendingPaymentRequestsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF006633)));
          }

          final requests = snapshot.data ?? [];

          if (requests.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline, size: 64, color: Color(0xFF006633)),
                    SizedBox(height: 12),
                    Text('No Pending Payment Requests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Text('All student TRX IDs have been processed.', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final req = requests[index];
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
                          Chip(
                            backgroundColor: const Color(0xFF006633).withValues(alpha: 0.1),
                            label: Text(req.gateway, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF006633))),
                          ),
                          Text('TRX: ${req.transactionId}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Course: ${req.courseTitle}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('Student: ${req.studentName} (${req.studentEmail})', style: const TextStyle(color: Colors.black87)),
                      Text('Sender: ${req.senderName} (${req.senderAccount})', style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF006633),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => _approve(req),
                            icon: const Icon(Icons.check, size: 16),
                            label: const Text('Approve & Unlock Course'),
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
    );
  }
}
