import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({
    required this.currentPath,
    required this.isCollapsed,
    required this.onToggle,
    super.key,
  });

  final String currentPath;
  final bool isCollapsed;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final sectionLabelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
          color: const Color(0xFF8F897B),
          letterSpacing: 1.1,
        );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      width: isCollapsed ? 88 : 272,
      padding: EdgeInsets.fromLTRB(isCollapsed ? 12 : 20, 20, isCollapsed ? 12 : 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFF1C1B1B),
            Color(0xFF141414),
          ],
        ),
        border: Border(
          right: BorderSide(color: Color(0xFF333333)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (isCollapsed)
            Center(
              child: Column(
                children: <Widget>[
                  _BrandMark(),
                  const SizedBox(height: 12),
                  IconButton(
                    onPressed: onToggle,
                    tooltip: 'Expandir menu',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 40,
                      height: 40,
                    ),
                    icon: const Icon(
                      Icons.menu_open_rounded,
                      color: Color(0xFFD0C6AB),
                    ),
                  ),
                ],
              ),
            )
          else
            Row(
              children: <Widget>[
                const _BrandMark(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppConstants.appName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: const Color(0xFFFFD700),
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      Text(
                        'Swift Delivery',
                        style: sectionLabelStyle,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onToggle,
                  tooltip: 'Recolher menu',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 40,
                    height: 40,
                  ),
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: Color(0xFFD0C6AB),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 20),
          _SidebarActionButton(
            icon: Icons.add_rounded,
            label: 'New Request',
            highlighted: true,
            collapsed: isCollapsed,
            onTap: () => context.go('/requests'),
          ),
          const SizedBox(height: 10),
          _SidebarActionButton(
            icon: Icons.terminal_rounded,
            label: 'Import cURL',
            collapsed: isCollapsed,
            onTap: () => context.go('/curl'),
          ),
          const SizedBox(height: 20),
          if (!isCollapsed)
            Padding(
              padding: const EdgeInsets.only(left: 6, bottom: 8),
              child: Text('WORKSPACE', style: sectionLabelStyle),
            ),
          _SidebarItem(
            icon: Icons.send_rounded,
            label: 'Requests',
            selected: currentPath == '/requests',
            collapsed: isCollapsed,
            onTap: () => context.go('/requests'),
          ),
          _SidebarItem(
            icon: Icons.folder_open_rounded,
            label: 'Collections',
            selected: currentPath == '/collections',
            collapsed: isCollapsed,
            onTap: () => context.go('/collections'),
          ),
          _SidebarItem(
            icon: Icons.storage_rounded,
            label: 'Environments',
            selected: currentPath == '/environments',
            collapsed: isCollapsed,
            onTap: () => context.go('/environments'),
          ),
          _SidebarItem(
            icon: Icons.history_rounded,
            label: 'History',
            selected: false,
            collapsed: isCollapsed,
            onTap: () => context.go('/requests'),
          ),
          _SidebarItem(
            icon: Icons.code_rounded,
            label: 'cURL Tools',
            selected: currentPath == '/curl',
            collapsed: isCollapsed,
            onTap: () => context.go('/curl'),
          ),
          const Spacer(),
          if (!isCollapsed)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF333333)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Active Services',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: Color(0xFF8F897B),
                    ),
                  ),
                  SizedBox(height: 12),
                  _FooterRow(icon: Icons.api_rounded, label: 'Payments API'),
                  SizedBox(height: 10),
                  _FooterRow(icon: Icons.lock_rounded, label: 'Auth Service'),
                ],
              ),
            )
          else
            const Column(
              children: <Widget>[
                _CollapsedFooterIcon(icon: Icons.api_rounded),
                SizedBox(height: 10),
                _CollapsedFooterIcon(icon: Icons.lock_rounded),
                SizedBox(height: 10),
                _CollapsedFooterIcon(icon: Icons.settings_rounded),
              ],
            ),
        ],
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFFFD700),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.air_rounded,
        color: Color(0xFF3A3000),
      ),
    );
  }
}

class _SidebarActionButton extends StatelessWidget {
  const _SidebarActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlighted = false,
    this.collapsed = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool highlighted;
  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    final child = collapsed
        ? Icon(icon, color: highlighted ? const Color(0xFF3A3000) : const Color(0xFFFFD700))
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 18, color: highlighted ? const Color(0xFF3A3000) : const Color(0xFFFFD700)),
              const SizedBox(width: 8),
              Text(label),
            ],
          );

    if (highlighted) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: onTap,
          style: FilledButton.styleFrom(
            minimumSize: Size(double.infinity, collapsed ? 52 : 48),
          ),
          child: child,
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          minimumSize: Size(double.infinity, collapsed ? 52 : 48),
        ),
        child: child,
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.collapsed,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool collapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Tooltip(
        message: collapsed ? label : '',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onTap,
            child: Ink(
              padding: EdgeInsets.symmetric(horizontal: collapsed ? 0 : 16, vertical: 14),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF2A260D) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: selected ? const Color(0xFFFFD700) : const Color(0xFF333333),
                ),
              ),
              child: collapsed
                  ? Center(
                      child: Icon(
                        icon,
                        color: selected ? const Color(0xFFFFD700) : const Color(0xFFD0C6AB),
                      ),
                    )
                  : Row(
                      children: <Widget>[
                        Icon(
                          icon,
                          color: selected ? const Color(0xFFFFD700) : const Color(0xFFD0C6AB),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(label)),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterRow extends StatelessWidget {
  const _FooterRow({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 18, color: const Color(0xFFD0C6AB)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFD0C6AB),
                ),
          ),
        ),
      ],
    );
  }
}

class _CollapsedFooterIcon extends StatelessWidget {
  const _CollapsedFooterIcon({
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF333333)),
      ),
      child: Icon(icon, color: const Color(0xFFD0C6AB), size: 18),
    );
  }
}
