import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naytodo/state/theme_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('image mode cannot be enabled without an image', () {
    final store = ThemeStore();

    store.setBackgroundMode(AppBackgroundMode.image);

    expect(store.backgroundMode, AppBackgroundMode.solid);
  });

  test('Android route transitions keep the app background visible', () {
    final builder = ThemeStore()
        .lightTheme
        .pageTransitionsTheme
        .builders[TargetPlatform.android];

    expect(builder, isA<FadeForwardsPageTransitionsBuilder>());
    expect(
      (builder! as FadeForwardsPageTransitionsBuilder).backgroundColor,
      Colors.transparent,
    );
  });

  test('overlay preview clamps values and persists on demand', () async {
    final store = ThemeStore();

    store.previewBackgroundOverlayOpacity(2);
    expect(store.backgroundOverlayOpacity, 1);

    await store.persistBackgroundOverlayOpacity();
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getDouble('background_overlay_opacity'), 1);
  });

  test('load ignores missing background image and uses solid mode', () async {
    SharedPreferences.setMockInitialValues({
      'background_mode': AppBackgroundMode.image.index,
      'background_image_path': 'missing-image.jpg',
      'background_overlay_opacity': -1.0,
      'background_focus_x': 2.0,
      'background_focus_y': -1.0,
      'background_scale': 10.0,
    });
    final store = ThemeStore();

    await store.load();

    expect(store.backgroundMode, AppBackgroundMode.solid);
    expect(store.backgroundImagePath, isNull);
    expect(store.backgroundOverlayOpacity, 0);
    expect(store.backgroundFocusX, 1);
    expect(store.backgroundFocusY, 0);
    expect(store.backgroundScale, 4);
  });
}
