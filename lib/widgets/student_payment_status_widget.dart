import 'package:flutter/material.dart';

class StudentPaymentStatusWidget extends StatelessWidget {
  final Map<String, dynamic> verificationData;
  final VoidCallback onResubmitRequested;

  const StudentPaymentStatusWidget({
    super.key,
    required this.verificationData,
    required this.onResubmitRequested,
  });

  @override
  Widget build(BuildContext context) {
    final status = verificationData['status'] ?? 'pending';

    if (status == 'rejected') {
      final reason = verificationData['rejectionReason'] ?? 'Details could not be verified.';
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          border: Border.all(color: Colors.red.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.error_outline, color: Colors.red, size: 20),
                SizedBox(width: 8),
                Text('Verification Unsuccessful', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              ],
            ),
            const SizedBox(height: 6),
            Text('Reason: $reason', style: TextStyle(color: Colors.red.shade900, fontSize: 13)),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: onResubmitRequested,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Resubmit Valid Payment Proof'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white),
            ),
          ],
        ),
      );
    }

    if (status == 'pending') {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.amber.shade300),
        ),
        child: Row(
          children: const [
            SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
            SizedBox(width: 12),
            Expanded(child: Text('Payment verification in progress. Verification typically completes within 30 minutes.')),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
