// Copyright (c) 2022 Dewin J. Martínez
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:flutter/material.dart';
import 'package:thumb_slider/src/shape/rectangle_shape.dart';

/// Base class for slider thumb overlay.
class ThumbSliderOverlay extends SliderComponentShape {
  /// This abstract const constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const ThumbSliderOverlay({
    required this.size,
    required this.overlayRadius,
  });

  /// The preferred radius of the round thumb overlay shape.
  final double overlayRadius;

  /// The preferred size of the thumb overlay shape.
  final Size size;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => size;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final radiusTween = Tween<double>(
      begin: 16,
      end: overlayRadius,
    );

    final paint = Paint()
      ..color = sliderTheme.overlayColor ?? Colors.black
      ..style = PaintingStyle.fill;

    final rect = RectangleShape(
      size: size,
      radius: overlayRadius,
      offset: center,
    );

    final round = RRect.fromRectAndRadius(
      rect.outerRect,
      Radius.circular(radiusTween.evaluate(activationAnimation)),
    );

    canvas.drawRRect(round, paint);
  }
}
