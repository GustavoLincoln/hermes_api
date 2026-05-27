import 'package:fluent_ui/fluent_ui.dart';

import '../../../../shared/widgets/panel_card.dart';
import '../../../../shared/widgets/section_title.dart';

class EnvironmentsPage extends StatelessWidget {
  const EnvironmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PanelCard(
      elevated: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SectionTitle(
            title: 'Environments',
            subtitle:
                'Environment variables, scope switching and interpolation are scaffolded for a desktop-first workflow.',
          ),
          SizedBox(height: 18),
          Expanded(
            child: Center(
              child: Text(
                'Next step: add named variables, secure values and collection-level overrides.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
