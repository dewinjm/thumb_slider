// Copyright (c) 2022 Dewin J. Martínez
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thumb_slider/thumb_slider.dart';

import '../helpers/helpers.dart';

void main() {
  group('ThumbSlider', () {
    test('can be instantiated', () {
      expect(
        ThumbSlider(
          value: 0,
          onChanged: (value) {},
          thumbHeight: 40,
          thumbWidth: 20,
        ),
        isNotNull,
      );
    });

    testWidgets('should renders', (tester) async {
      var value = 1.0;

      await tester.pumpApp(
        ThumbSlider(
          value: value,
          thumbHeight: 32,
          thumbWidth: 40,
          minValue: 1,
          maxValue: 100,
          onChanged: (valueChanged) {
            value = valueChanged;
          },
        ),
      );

      expect(find.byType(Slider), findsOneWidget);
      expect(value, equals(1.0));

      await tester.drag(find.byType(Slider), const Offset(40, 0));
      expect(value, equals(56.0));
    });

    testWidgets('should present slider with unrounded value', (tester) async {
      var value = 10.0;

      await tester.pumpApp(
        ThumbSlider(
          value: value,
          thumbHeight: 32,
          thumbWidth: 40,
          minValue: 1,
          maxValue: 100,
          onChanged: (valueChanged) {
            value = valueChanged;
          },
          roundValue: false,
          overlayRadius: 32,
        ),
      );

      await tester.drag(find.byType(Slider), const Offset(100, 0));
      expect(value, equals(63.81));
    });

    testWidgets(
      'should render overlay shape when mouse is over the slider',
      (tester) async {
        tester.binding.focusManager.highlightStrategy =
            FocusHighlightStrategy.alwaysTraditional;

        final thumbSlider = ThumbSlider(
          value: 10,
          thumbHeight: 32,
          thumbWidth: 40,
          minValue: 1,
          maxValue: 100,
          onChanged: (value) {},
        );

        await tester.pumpApp(thumbSlider);
        await tester.pumpAndSettle();

        // Start hovering.
        final gesture = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        await gesture.addPointer();
        await gesture.moveTo(tester.getCenter(find.byType(ThumbSlider)));

        // Slider has overlay when enabled and hovered.
        await tester.pumpApp(thumbSlider);
        await tester.pumpAndSettle();

        final sliderTheme = tester.widget<SliderTheme>(
          find.byType(SliderTheme),
        );

        expect(
          sliderTheme.data.overlayShape!.getPreferredSize(false, false),
          const Size(56, 48),
        );
      },
    );
  });
}
