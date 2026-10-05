import 'package:flutter/material.dart';

/// Reusable brand logo widget for PCSA Web Portal with Flutter Web error fallback.
class PCSABrandLogo extends StatelessWidget {
  final double height;
  final double? width;
  final bool showText;
  final VoidCallback? onTap;

  const PCSABrandLogo({
    super.key,
    this.height = 42,
    this.width,
    this.showText = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget logoWidget = Image.asset(
      'assets/images/logo.png',
      height: height,
      width: width,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback elegant shield badge if image asset fails to load on web
        return Container(
          height: height,
          width: height,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF006633), Color(0xFF004D26)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'PCSA',
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.w900,
                fontSize: 12,
                letterSpacing: 0.8,
              ),
            ),
          ),
        );
      },
    );

    if (showText) {
      logoWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          logoWidget,
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'PCSA',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: 1.1,
                  color: Colors.white,
                ),
              ),
              Text(
                'Pakistan Computer Science Academy',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: logoWidget,
      );
    }

    return logoWidget;
  }
}
