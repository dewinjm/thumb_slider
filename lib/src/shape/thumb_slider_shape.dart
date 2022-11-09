// Copyright (c) 2022 Dewin J. Martínez
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:flutter/material.dart';
import 'package:thumb_slider/src/shape/rectangle_shape.dart';

/// Base class for slider thumb value indicator shapes.
class ThumbSliderShape extends SliderComponentShape {
  /// This abstract const constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const ThumbSliderShape({
    required this.sliderValue,
    required this.size,
    this.thumbRadius = 16.0,
    this.strokeWidth = 8.0,
    this.roundValue = true,
    this.thumbStrokeColor,
    this.prefix = '',
    this.suffix = '',
  });

  /// The value tha will be show on thumb indicator
  final double sliderValue;

  /// The preferred size of the thumb shape.
  final Size size;

  /// The preferred radius of the round thumb shape.
  ///
  /// If it is not provided, then the default of 16 is used.
  final double thumbRadius;

  /// The stroke width of thumb.
  ///
  /// The default is 8.
  ///
  /// Use 0 for no stroke.
  final double strokeWidth;

  ///Set if value is round, when is true the values use value.round()
  ///and when is false use value.toStringAsFixed(2)
  ///
  /// If it is not provided, then the default value is true.
  final bool roundValue;

  /// The color to use for the slider thumb stroke.
  ///
  /// Defaults to [SliderThemeData.activeTrackColor] of the current
  /// [SliderTheme].
  final Color? thumbStrokeColor;

  /// The prefix that will be used on value indicator.
  final String? prefix;

  ///The suffix that will be used on value indicator
  final String? suffix;

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

    final borderPaint = Paint()
      ..strokeWidth = strokeWidth
      ..color = thumbStrokeColor ?? Colors.black
      ..style = PaintingStyle.stroke;

    final rect = RectangleShape(
      size: size,
      radius: thumbRadius,
      offset: center,
    );

    canvas.drawRRect(rect, borderPaint);

    final innerPathColor = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawRRect(rect, innerPathColor);

    final value = roundValue
        ? sliderValue.round().toString()
        : sliderValue.toStringAsFixed(2);

    final textSpan = TextSpan(
      style: sliderTheme.valueIndicatorTextStyle,
      text: '$prefix$value$suffix',
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();

    final textCenter = Offset(
      center.dx - (textPainter.width / 2),
      center.dy - (textPainter.height / 2),
    );

    textPainter.paint(canvas, textCenter);
  }

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.fromRadius(thumbRadius);
}
