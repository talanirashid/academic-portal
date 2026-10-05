import 'package:flutter/material.dart';
import '../utils/google_drive_helper.dart';

/// Reusable UI PDF action button providing clean responsive styling for chapter lecture notes and lab copies.
class DrivePdfActionButton extends StatelessWidget {
  final String? driveFileUrl;
  final String documentTitle;
  final String? unitTag;
  final bool isCompact;

  const DrivePdfActionButton({
    super.key,
    required this.driveFileUrl,
    required this.documentTitle,
    this.unitTag,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasValidFile = GoogleDriveHelper.extractFileId(driveFileUrl) != null;

    if (!hasValidFile) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A).withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          mainAxisSize: isCompact ? MainAxisSize.min : MainAxisSize.max,
          children: const [
            Icon(Icons.hourglass_empty_rounded, size: 18, color: Colors.amberAccent),
            SizedBox(width: 8),
            Text(
              'PDF Notes Upload Pending',
              style: TextStyle(color: Colors.white60, fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 0,
      color: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color(0xFF334155)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => GoogleDriveHelper.launchDocumentViewer(context, driveFileUrl!),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: isCompact ? 10 : 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (unitTag != null) ...[
                      Text(
                        unitTag!.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF38BDF8),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                    Text(
                      documentTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.file_download_outlined, color: Color(0xFF94A3B8), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
