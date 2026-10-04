import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/access_control_service.dart';

/// Admin Management Console for updating global annual board exam session cutoff dates.
class AdminExamSessionManager extends StatefulWidget {
  const AdminExamSessionManager({super.key});

  @override
  State<AdminExamSessionManager> createState() => _AdminExamSessionManagerState();
}

class _AdminExamSessionManagerState extends State<AdminExamSessionManager> {
  final AccessControlService _accessControlService = AccessControlService();

  String _selectedBoard = 'FBISE';
  String _selectedClass = '11th';

  DateTime _theoryDate = DateTime.now().add(const Duration(days: 120));
  DateTime _practicalDate = DateTime.now().add(const Duration(days: 150));
  bool _isSaving = false;

  Future<void> _pickDate(bool isTheory) async {
    final initial = isTheory ? _theoryDate : _practicalDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );

    if (picked != null) {
      setState(() {
        if (isTheory) {
          _theoryDate = picked;
        } else {
          _practicalDate = picked;
        }
      });
    }
  }

  Future<void> _saveSessionConfig() async {
    setState(() => _isSaving = true);
    try {
      await _accessControlService.updateSessionCutoff(
        board: _selectedBoard,
        className: _selectedClass,
        theoryCutoff: _theoryDate,
        practicalCutoff: _practicalDate,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Session deadlines updated for $_selectedBoard Class $_selectedClass!'),
            backgroundColor: const Color(0xFF006633),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating deadlines: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.event, color: Color(0xFF006633)),
                SizedBox(width: 8),
                Text(
                  'Centralized Annual Exam Session Deadline Manager',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004D26)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Updating deadlines here instantly extends access for all enrolled students across Pakistani boards:',
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedBoard,
                    decoration: const InputDecoration(labelText: 'Board', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'FBISE', child: Text('FBISE Federal Board')),
                      DropdownMenuItem(value: 'STBB', child: Text('Sindh Board (STBB)')),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedBoard = v);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedClass,
                    decoration: const InputDecoration(labelText: 'Class', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: '9th', child: Text('Class 9th (SSC-I)')),
                      DropdownMenuItem(value: '10th', child: Text('Class 10th (SSC-II)')),
                      DropdownMenuItem(value: '11th', child: Text('Class 11th (HSSC-I)')),
                      DropdownMenuItem(value: '12th', child: Text('Class 12th (HSSC-II)')),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedClass = v);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Date Pickers
            StreamBuilder<SessionConfigModel?>(
              stream: _accessControlService.getSessionConfigStream(_selectedBoard, _selectedClass),
              builder: (context, snapshot) {
                final cfg = snapshot.data;
                final tDateStr = cfg != null ? '${cfg.theoryCutoffDate.day}/${cfg.theoryCutoffDate.month}/${cfg.theoryCutoffDate.year}' : '${_theoryDate.day}/${_theoryDate.month}/${_theoryDate.year}';
                final pDateStr = cfg != null ? '${cfg.practicalCutoffDate.day}/${cfg.practicalCutoffDate.month}/${cfg.practicalCutoffDate.year}' : '${_practicalDate.day}/${_practicalDate.month}/${_practicalDate.year}';

                return Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pickDate(true),
                        icon: const Icon(Icons.calendar_today, size: 16),
                        label: Text('Theory Cutoff: $tDateStr', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pickDate(false),
                        icon: const Icon(Icons.build_circle, size: 16),
                        label: Text('Practical Cutoff: $pDateStr', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF006633),
                  foregroundColor: Colors.white,
                ),
                onPressed: _isSaving ? null : _saveSessionConfig,
                icon: _isSaving
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.save, size: 18),
                label: Text(_isSaving ? 'Updating...' : 'Update Board Session Deadlines', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
