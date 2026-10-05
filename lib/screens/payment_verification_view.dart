import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/student_payment_service.dart';

class AdminPaymentVerificationView extends StatefulWidget {
  final String currentAdminUid;
  const AdminPaymentVerificationView({super.key, required this.currentAdminUid});

  @override
  State<AdminPaymentVerificationView> createState() => _AdminPaymentVerificationViewState();
}

class _AdminPaymentVerificationViewState extends State<AdminPaymentVerificationView> {
  final PaymentTransactionService _service = PaymentTransactionService();
  String _selectedFilter = 'pending'; // 'pending', 'approved', 'rejected'
  final TextEditingController _rejectionController = TextEditingController();

  @override
  void dispose() {
    _rejectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilterPills(),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('payment_verifications')
                    .where('status', isEqualTo: _selectedFilter)
                    .orderBy('submittedAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return Center(child: Text('No $_selectedFilter payment records.'));
                  }

                  return isMobile ? _buildCardList(docs) : _buildDesktopTable(docs);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPills() {
    return Wrap(
      spacing: 8,
      children: ['pending', 'approved', 'rejected'].map((status) {
        final isSelected = _selectedFilter == status;
        return ChoiceChip(
          label: Text(status.toUpperCase()),
          selected: isSelected,
          onSelected: (val) => setState(() => _selectedFilter = status),
        );
      }).toList(),
    );
  }

  Widget _buildCardList(List<QueryDocumentSnapshot> docs) {
    return ListView.builder(
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final data = docs[index].data() as Map<String, dynamic>;
        final docId = docs[index].id;
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['studentEmail'] ?? 'No Email', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('TID: ${data['tid']} | ${data['provider']}'),
                Text('Board: ${data['boardId']} | Class: ${data['targetGrade']}'),
                if (_selectedFilter == 'pending') ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _handleApprove(docId, data),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: const Text('Approve'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () => _showRejectDialog(docId),
                        child: const Text('Reject', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  )
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopTable(List<QueryDocumentSnapshot> docs) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Student Email')),
          DataColumn(label: Text('TID / Provider')),
          DataColumn(label: Text('Board & Grade')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Actions')),
        ],
        rows: docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final docId = doc.id;
          return DataRow(cells: [
            DataCell(Text(data['studentEmail'] ?? '')),
            DataCell(Text('${data['tid']} (${data['provider']})')),
            DataCell(Text('${data['boardId']} - ${data['targetGrade']}')),
            DataCell(Text(data['status'])),
            DataCell(
              _selectedFilter == 'pending'
                  ? Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check_circle, color: Colors.green),
                          onPressed: () => _handleApprove(docId, data),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          onPressed: () => _showRejectDialog(docId),
                        ),
                      ],
                    )
                  : const Text('-'),
            ),
          ]);
        }).toList(),
      ),
    );
  }

  Future<void> _handleApprove(String docId, Map<String, dynamic> data) async {
    await _service.approvePaymentPass(
      verificationId: docId,
      studentUid: data['uid'],
      boardId: data['boardId'],
      targetGrade: data['targetGrade'],
      adminUid: widget.currentAdminUid,
    );
  }

  void _showRejectDialog(String docId) {
    _rejectionController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Transaction'),
        content: TextField(
          controller: _rejectionController,
          decoration: const InputDecoration(labelText: 'Reason for rejection (e.g. Invalid TID)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await _service.rejectPaymentPass(
                verificationId: docId,
                adminUid: widget.currentAdminUid,
                reason: _rejectionController.text.trim(),
              );
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Confirm Reject'),
          )
        ],
      ),
    );
  }
}
