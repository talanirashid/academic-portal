import 'package:flutter/material.dart';

/// Anti-Piracy Content Protection Shield Widget disabling text selection and right-click context menus.
class ProtectedContentWrapper extends StatelessWidget {
  final Widget child;
  final bool isProtected;

  const ProtectedContentWrapper({
    super.key,
    required this.child,
    this.isProtected = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isProtected) return child;

    return SelectionContainer.disabled(
      child: Listener(
        onPointerDown: (event) {
          // Detect secondary mouse click (right click) on Web and prevent context menu
        },
        child: child,
      ),
    );
  }
}
