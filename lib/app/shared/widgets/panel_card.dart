import 'package:fluent_ui/fluent_ui.dart';

import '../../core/theme/app_theme.dart';

class PanelCard extends StatelessWidget {
  const PanelCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(20),
    this.elevated = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppTheme.panelDecoration(
        elevated: elevated,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
