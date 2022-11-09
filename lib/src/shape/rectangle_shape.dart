// Copyright (c) 2022 Dewin J. Martínez
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:flutter/material.dart';

/// A custom rounded rectangle
class RectangleShape extends RRect {
  /// Construct a rounded rectangle from its size, radius and offset
  RectangleShape({
    required Size size,
    required double radius,
    required Offset offset,
  }) : super.fromRectAndRadius(
          Rect.fromLTWH(
            offset.dx - (size.width / 2),
            offset.dy - (size.height / 2),
            size.width,
            size.height,
          ),
          Radius.circular(radius),
        );
}
