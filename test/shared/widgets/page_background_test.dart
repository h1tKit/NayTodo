import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naytodo/shared/widgets/page_background.dart';
import 'package:naytodo/state/theme_store.dart';

void main() {
  testWidgets('solid mode paints the theme surface behind content', (
    tester,
  ) async {
    const surface = Color(0xff123456);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(colorScheme: const ColorScheme.dark(surface: surface)),
        home: const AppBodyBackground(
          mode: AppBackgroundMode.solid,
          imagePath: null,
          overlayOpacity: 0.35,
          focus: Offset(0.5, 0.5),
          scale: 1,
          child: Text('content'),
        ),
      ),
    );

    expect(find.text('content'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is ColoredBox && widget.color == surface,
      ),
      findsOneWidget,
    );
    expect(find.byType(PositionedBackgroundImage), findsNothing);
  });

  testWidgets('image mode adds image and overlay layers', (tester) async {
    const surface = Color(0xff224466);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(colorScheme: const ColorScheme.dark(surface: surface)),
        home: const AppBodyBackground(
          mode: AppBackgroundMode.image,
          imagePath: 'missing-image.jpg',
          overlayOpacity: 0.4,
          focus: Offset(0.25, 0.75),
          scale: 2,
          child: SizedBox.shrink(),
        ),
      ),
    );

    expect(find.byType(PositionedBackgroundImage), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is ColoredBox &&
            widget.color == surface.withValues(alpha: 0.4),
      ),
      findsOneWidget,
    );
  });
}
