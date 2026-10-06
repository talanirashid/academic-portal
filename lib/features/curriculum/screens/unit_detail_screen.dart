import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/config/drive_vault_config.dart';
import '../../../widgets/drive_pdf_action_button.dart';
import '../models/chapter_resource_model.dart';

/// Modern Dark-Mode Unit Detail Screen with 4 PDF Action Tiles & DataCenter Folder Launch Button.
class UnitDetailScreen extends StatelessWidget {
  final ChapterResourceModel unit;
  final String screenTitle;

  const UnitDetailScreen({
    super.key,
    required this.unit,
    required this.screenTitle,
  });

  Future<void> _openDataCenterVault(BuildContext context) async {
    final Uri uri = Uri.parse(DriveVaultConfig.masterFolderUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open PCSA DataCenter Vault.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isStbb = unit.curriculumStream.toLowerCase() == 'stbb';
    final streamLabel = isStbb ? 'STBB Sindh Board' : 'FBISE Federal Board';

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark slate
      appBar: AppBar(
        title: Text(screenTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_special, color: Colors.amberAccent),
            tooltip: 'Open PCSA DataCenter Folder',
            onPressed: () => _openDataCenterVault(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unit Header Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF38BDF8)),
                        ),
                        child: Text(
                          'UNIT ${unit.unitNumber}',
                          style: const TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.amber),
                        ),
                        child: Text(
                          streamLabel,
                          style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    unit.unitTitle,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    unit.description,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8), height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Official Syllabus Documents & Lab Artifacts',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),

            // 1. Theory & Chapter Notes PDF Tile
            DrivePdfActionButton(
              driveFileUrl: unit.notesDriveUrl,
              documentTitle: '1. Theory & Chapter Notes (PDF)',
              unitTag: '$streamLabel • Theory',
            ),
            const SizedBox(height: 12),

            // 2. Solved Board Exercises & MCQs PDF Tile
            DrivePdfActionButton(
              driveFileUrl: unit.solvedExercisesDriveUrl,
              documentTitle: '2. Solved Board Exercises & MCQs Dossier',
              unitTag: '$streamLabel • Exercises',
            ),
            const SizedBox(height: 12),

            // 3. Hands-on Lab Experiments & Code Snippets Tile
            DrivePdfActionButton(
              driveFileUrl: unit.labJournalDriveUrl,
              documentTitle: '3. Hands-on Lab Experiments & Code Snippets',
              unitTag: '$streamLabel • Practical Lab',
            ),
            const SizedBox(height: 12),

            // 4. Board Past Papers & Model Solutions Tile
            DrivePdfActionButton(
              driveFileUrl: unit.pastPapersDriveUrl,
              documentTitle: '4. Board Past Papers & Solved Model Solutions',
              unitTag: '$streamLabel • Past Papers',
            ),
          ],
        ),
      ),
    );
  }
}
