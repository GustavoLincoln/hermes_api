import 'package:fluent_ui/fluent_ui.dart';

import '../../../../shared/widgets/panel_card.dart';
import '../../../../shared/widgets/section_title.dart';

class CurlPage extends StatelessWidget {
  const CurlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PanelCard(
      elevated: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SectionTitle(
            title: 'cURL Tools',
            subtitle:
                'The parser and generator are connected to the workbench and ready for a dedicated tooling screen.',
          ),
          SizedBox(height: 18),
          Expanded(
            child: Center(
              child: Text(
                'Next step: multiline parsing, advanced flags and language snippets for exports.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
