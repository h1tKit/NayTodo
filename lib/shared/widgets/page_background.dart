import 'dart:io';

import 'package:flutter/material.dart';
import 'package:naytodo/state/theme_store.dart';

class AppBodyBackground extends StatelessWidget {
  final Widget child;
  final AppBackgroundMode mode;
  final String? imagePath;
  final double overlayOpacity;
  final Offset focus;
  final double scale;

  const AppBodyBackground({
    super.key,
    required this.child,
    required this.mode,
    required this.imagePath,
    required this.overlayOpacity,
    required this.focus,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    final path = imagePath;
    final showImage = mode == AppBackgroundMode.image && path != null;

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: surface),
        if (showImage)
          Positioned.fill(
            child: PositionedBackgroundImage(
              imagePath: path,
              focus: focus,
              scale: scale,
            ),
          ),
        if (showImage)
          Positioned.fill(
            child: IgnorePointer(
              child: ColoredBox(
                color: surface.withValues(
                  alpha: overlayOpacity.clamp(0.0, 1.0),
                ),
              ),
            ),
          ),
        child,
      ],
    );
  }
}

class PositionedBackgroundImage extends StatelessWidget {
  final String imagePath;
  final Offset focus;
  final double scale;

  const PositionedBackgroundImage({
    super.key,
    required this.imagePath,
    required this.focus,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    final alignment = Alignment(
      focus.dx.clamp(0.0, 1.0) * 2 - 1,
      focus.dy.clamp(0.0, 1.0) * 2 - 1,
    );
    return Transform.scale(
      scale: scale.clamp(1.0, 4.0),
      alignment: alignment,
      child: Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        alignment: alignment,
        gaplessPlayback: true,
        errorBuilder: (_, _, _) => const SizedBox.shrink(),
      ),
    );
  }
}
