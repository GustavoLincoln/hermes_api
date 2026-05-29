import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;

import '../../core/theme/app_theme.dart';

class TabBarItem {
  const TabBarItem({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;
}

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({
    super.key,
    required this.items,
  });

  final List<TabBarItem> items;

  @override
  Widget build(BuildContext context) {
    return material.DefaultTabController(
      length: items.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          material.TabBar(
            isScrollable: true,
            tabAlignment: material.TabAlignment.start,
            labelColor: AppTheme.secondary,
            unselectedLabelColor: AppTheme.onSurfaceVariant,
            indicatorColor: AppTheme.secondary,
            dividerColor: AppTheme.outlineVariant,
            indicatorSize: material.TabBarIndicatorSize.label,
            tabs: items
                .map(
                  (item) => material.Tab(text: item.label),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: material.TabBarView(
              children: items.map((item) => item.child).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
