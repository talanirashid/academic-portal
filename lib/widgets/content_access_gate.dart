import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'blur_overlay.dart';
import 'pricing_modal.dart';

/// Gating widget enforcing Freemium value-hook content restrictions across the PCSA web portal.
class ContentAccessGate extends StatelessWidget {
  final Widget child;
  final Widget? previewChild;
  final bool isProRequired;
  final bool isPracticalRequired;
  final UserModel? user;
  final String title;
  final String description;

  const ContentAccessGate({
    super.key,
    required this.child,
    this.previewChild,
    this.isProRequired = true,
    this.isPracticalRequired = false,
    required this.user,
    this.title = 'Unlock Complete FBISE/STBB Step-by-Step Marking Keys',
    this.description = 'Access full ERQ dossiers, high-resolution vector PDF downloads, and 100% exam marking schemes with PCSA Pro.',
  });

  @override
  Widget build(BuildContext context) {
    bool isUnlocked = false;

    if (user != null) {
      if (user!.isAdmin) {
        isUnlocked = true;
      } else if (isPracticalRequired) {
        isUnlocked = user!.isPracticalUnlocked;
      } else if (isProRequired) {
        isUnlocked = user!.isPro;
      } else {
        isUnlocked = true;
      }
    }

    if (isUnlocked) {
      return child;
    }

    return Stack(
      children: [
        if (previewChild != null)
          previewChild!
        else
          Opacity(
            opacity: 0.3,
            child: IgnorePointer(child: child),
          ),
        Positioned.fill(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlurOverlay(
                title: title,
                description: description,
                onUnlockPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const PricingModal(),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
