import 'package:flutter/material.dart';

/// Latar gradien gelap dengan "blob" cahaya agar efek blur terlihat.
class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  Widget _blob(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: 0.55), color.withValues(alpha: 0)],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0B0B2B), Color(0xFF1B1146), Color(0xFF0A2A4A)],
            ),
          ),
        ),
        Positioned(top: -90, left: -80, child: _blob(320, const Color(0xFF8E54FF))),
        Positioned(top: 220, right: -120, child: _blob(340, const Color(0xFF00C6FF))),
        Positioned(bottom: -100, left: -60, child: _blob(320, const Color(0xFFFF4DA6))),
        child,
      ],
    );
  }
}
