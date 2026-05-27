import 'package:fluent_ui/fluent_ui.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

class HermesApp extends StatelessWidget {
  const HermesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp.router(
      title: 'Hermes',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      routerConfig: AppRouter.router,
    );
  }
}
