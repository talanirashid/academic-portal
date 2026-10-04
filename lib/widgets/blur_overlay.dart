import 'dart:ui';
import 'package:flutter/material.dart';

/// Glassmorphic Cliffhanger Blur Overlay widget for gated freemium content.
class BlurOverlay extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onUnlockPressed;

  const BlurOverlay({
    super.key,
    this.title = 'Unlock Complete FBISE/STBB Step-by-Step Marking Keys',
    this.description = 'Access full ERQ dossiers, high-resolution vector PDF downloads, and 100% exam marking schemes with PCSA Pro.',
    required this.onUnlockPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF00381B).withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.withValues(alpha: 0.5), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock, color: Color(0xFF004D26), size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: Colors.white70, height: 1.3),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  foregroundColor: const Color(0xFF004D26),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: onUnlockPressed,
                icon: const Icon(Icons.star, size: 18),
                label: const Text('Upgrade to PCSA Pro', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
