import 'package:fluent_ui/fluent_ui.dart';

import '../../../../shared/widgets/panel_card.dart';
import '../../../../shared/widgets/section_title.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PanelCard(
      elevated: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SectionTitle(
            title: 'Collections',
            subtitle:
                'The collections module is ready for folder hierarchies, grouped requests and import/export workflows.',
          ),
          SizedBox(height: 18),
          Expanded(
            child: Center(
              child: Text(
                'Next step: CRUD for collections with persistent local storage and a tree-style explorer.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
