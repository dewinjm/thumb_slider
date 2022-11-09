// Copyright (c) 2022 Dewin J. Martínez
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:flutter/material.dart';
import 'package:thumb_slider/src/shape/shape.dart';

/// {@template thumb_slider}
/// A custom slider that supports thumb text and icons
/// {@endtemplate}
class ThumbSlider extends StatelessWidget {
  /// {@macro thumb_slider}
  const ThumbSlider({
    required this.value,
    required this.onChanged,
    required this.thumbWidth,
    required this.thumbHeight,
    this.label,
    this.minValue = 0.0,
    this.maxValue = 1.0,
    this.activeColor,
    this.inactiveColor,
    this.roundValue = true,
    this.trackHeight = 8,
    this.thumbColor,
    this.thumbRadius,
    this.thumbStrokeColor,
    this.thumbTextStyle,
    this.indicatorPrefix = '',
    this.indicatorSuffix = '',
    this.overlayRadius,
    Key? key,
  }) : super(key: key);

  /// The currently selected value for this slider.
  ///
  /// The slider's thumb is drawn at a position that corresponds to this value.
  final double value;

  /// Called during a drag when the user is selecting a new value for the slider
  /// by dragging.
  ///
  /// The slider passes the new value to the callback but does not actually
  /// change state until the parent widget rebuilds the slider with the new
  /// value.
  ///
  /// If null, the slider will be displayed as disabled.
  ///
  /// The callback provided to onChanged should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// ThumbSlider(
  ///   value: _duelCommandment.toDouble(),
  ///   min: 1.0,
  ///   max: 10.0,
  ///   divisions: 10,
  ///   label: '$_duelCommandment',
  ///   onChanged: (double newValue) {
  ///     setState(() {
  ///       _duelCommandment = newValue.round();
  ///     });
  ///   },
  /// )
  /// ```
  /// {@end-tool}
  final ValueChanged<double> onChanged;

  /// A label to show above the slider when the slider is active and
  /// [SliderThemeData.showValueIndicator] is satisfied.
  ///
  /// It is used to display the value of a discrete slider, and it is displayed
  /// as part of the value indicator shape.
  ///
  /// The label is rendered using the active [ThemeData]'s [TextTheme.bodyText1]
  /// text style, with the theme data's [ColorScheme.onPrimary] color. The
  /// label's text style can be overridden with
  /// [SliderThemeData.valueIndicatorTextStyle].
  ///
  /// If null, then the value indicator will not be displayed.
  ///
  /// Ignored if this slider is created with [Slider.adaptive].
  ///
  /// See also:
  ///
  ///  * [SliderComponentShape] for how to create a custom value indicator
  ///    shape.
  final String? label;

  /// The minimum value the user can select.
  ///
  /// Defaults to 0.0. Must be less than or equal to [maxValue].
  ///
  /// If the [maxValue] is equal to the [minValue], then the slider is disabled.
  final double minValue;

  /// The maximum value the user can select.
  ///
  /// Defaults to 1.0. Must be greater than or equal to [minValue].
  ///
  /// If the [maxValue] is equal to the [minValue], then the slider is disabled.
  final double maxValue;

  ///Set if value is round, when is true the values use value.round()
  ///and when is false use value.toStringAsFixed(2)
  ///
  /// If it is not provided, then the default value is true.
  final bool roundValue;

  /// The color to use for the portion of the slider track that is active.
  ///
  /// The "active" side of the slider is the side between the thumb and the
  /// minimum value.
  ///
  /// Defaults to [SliderThemeData.activeTrackColor] of the current
  /// [SliderTheme].
  ///
  /// Using a [SliderTheme] gives much more fine-grained control over the
  /// appearance of various components of the slider.
  final Color? activeColor;

  /// The color for the inactive portion of the slider track.
  ///
  /// The "inactive" side of the slider is the side between the thumb and the
  /// maximum value.
  ///
  /// Defaults to the [SliderThemeData.inactiveTrackColor] of the current
  /// [SliderTheme].
  ///
  /// Using a [SliderTheme] gives much more fine-grained control over the
  /// appearance of various components of the slider.
  ///
  /// Ignored if this slider is created with [Slider.adaptive].
  final Color? inactiveColor;

  /// The height of the [Slider] track.
  /// Defaults to 8.
  final double trackHeight;

  /// Width of Slider thumb
  final double thumbWidth;

  /// Width of Slider thumb
  final double thumbHeight;

  /// The color to use for the slider thumb.
  ///
  /// Defaults to [SliderThemeData.activeTrackColor] of the current
  /// [SliderTheme].
  final Color? thumbColor;

  /// The color to use for the slider thumb stroke.
  ///
  /// Defaults to [SliderThemeData.activeTrackColor] of the current
  /// [SliderTheme].
  final Color? thumbStrokeColor;

  /// The preferred radius of the round thumb.
  ///
  /// If it is not provided, then half of the [trackHeight] is
  /// used.
  final double? thumbRadius;

  /// The text style for the thumb text on the value indicator.
  final TextStyle? thumbTextStyle;

  /// The preferred radius of the round thumb overlay shape.
  ///
  /// If it is not provided, then half of the [trackHeight] is
  /// used.
  final double? overlayRadius;

  /// The prefix that will be used on value indicator.
  final String? indicatorPrefix;

  ///The suffix that will be used on value indicator
  final String? indicatorSuffix;

  @override
  Widget build(BuildContext context) {
    final thumbSize = Size(thumbWidth, thumbHeight);
    final theme = SliderTheme.of(context);

    return SliderTheme(
      data: theme.copyWith(
        trackHeight: trackHeight,
        trackShape: const RoundedRectSliderTrackShape(),
        thumbShape: ThumbSliderShape(
          thumbRadius: thumbRadius ?? trackHeight,
          thumbStrokeColor: thumbStrokeColor,
          sliderValue: value,
          size: thumbSize,
          roundValue: roundValue,
          prefix: indicatorPrefix,
          suffix: indicatorSuffix,
        ),
        overlayShape: ThumbSliderOverlay(
          overlayRadius: overlayRadius ?? trackHeight,
          size: Size(thumbSize.width + 16, thumbSize.height + 16),
        ),
        showValueIndicator: ShowValueIndicator.never,
        valueIndicatorTextStyle: thumbTextStyle ??
            const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
      ),
      child: Slider(
        min: minValue,
        max: maxValue,
        value: value,
        label: '${roundValue ? value.round() : value.toStringAsFixed(2)}',
        onChanged: (double value) {
          onChanged(
            roundValue
                ? value.roundToDouble()
                : double.parse(value.toStringAsFixed(2)),
          );
        },
        activeColor: activeColor,
        inactiveColor: inactiveColor,
        thumbColor: thumbColor ?? theme.thumbColor,
      ),
    );
  }
}
