import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart' hide FluentApp;
import 'package:flutter_acrylic/flutter_acrylic.dart';

import 'app/app.dart';
import 'app/core/di/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();

  if (Platform.isWindows) {
    await Window.hideWindowControls();
    await Window.setEffect(
      effect: WindowEffect.mica,
      dark: true,
    );
  }

  await configureDependencies();
  runApp(const HermesApp());

  doWhenWindowReady(() {
    const initialSize = Size(1440, 900);
    const minSize = Size(1280, 820);

    final window = appWindow;
    window
      ..minSize = minSize
      ..size = initialSize
      ..alignment = Alignment.center
      ..title = 'Hermes'
      ..show();
  });
}
