import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/styles/radius_app.dart';
import '../../../../core/ui/styles/text_styles.dart';

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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      width: isCollapsed ? 80 : 268,
      decoration: const BoxDecoration(
        color: AppTheme.surfaceLow,
        border: Border(
          right: BorderSide(color: AppTheme.outlineVariant),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final displayCollapsed = constraints.maxWidth < 196;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(
                  displayCollapsed ? 12 : 16,
                  16,
                  displayCollapsed ? 12 : 16,
                  12,
                ),
                child: _SidebarBrand(
                  collapsed: displayCollapsed,
                  onToggle: onToggle,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: displayCollapsed ? 12 : 16,
                ),
                child: Column(
                  children: <Widget>[
                    _SidebarActionButton(
                      icon: FluentIcons.add,
                      label: 'New Request',
                      collapsed: displayCollapsed,
                      highlighted: true,
                      onPressed: () => context.go('/requests'),
                    ),
                    const SizedBox(height: 10),
                    _SidebarActionButton(
                      icon: FluentIcons.code,
                      label: 'Import cURL',
                      collapsed: displayCollapsed,
                      onPressed: () => context.go('/curl'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    displayCollapsed ? 12 : 8,
                    0,
                    displayCollapsed ? 12 : 8,
                    16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      if (!displayCollapsed) ...<Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                          child: Text(
                            'WORKSPACE',
                            style: TextStyles.labelCaps,
                          ),
                        ),
                      ],
                      _SidebarNavItem(
                        icon: FluentIcons.send,
                        label: 'Requests',
                        collapsed: displayCollapsed,
                        selected: currentPath == '/requests',
                        onPressed: () => context.go('/requests'),
                      ),
                      _SidebarNavItem(
                        icon: FluentIcons.fabric_folder,
                        label: 'Collections',
                        collapsed: displayCollapsed,
                        selected: currentPath == '/collections',
                        onPressed: () => context.go('/collections'),
                      ),
                      _SidebarNavItem(
                        icon: FluentIcons.server_enviroment,
                        label: 'Environments',
                        collapsed: displayCollapsed,
                        selected: currentPath == '/environments',
                        onPressed: () => context.go('/environments'),
                      ),
                      _SidebarNavItem(
                        icon: FluentIcons.history,
                        label: 'History',
                        collapsed: displayCollapsed,
                        selected: false,
                        onPressed: () => context.go('/requests'),
                      ),
                      _SidebarNavItem(
                        icon: FluentIcons.cloud,
                        label: 'Mock Servers',
                        collapsed: displayCollapsed,
                        selected: false,
                        onPressed: () => context.go('/requests'),
                      ),
                      const SizedBox(height: 18),
                      if (!displayCollapsed) ...<Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                          child: Text(
                            'ACTIVE SERVICES',
                            style: TextStyles.labelCaps,
                          ),
                        ),
                        _SidebarServiceTile(
                          icon: FluentIcons.plug_connected,
                          label: 'Payments API',
                        ),
                        const SizedBox(height: 8),
                        _SidebarServiceTile(
                          icon: FluentIcons.lock,
                          label: 'Auth Service',
                        ),
                        const SizedBox(height: 18),
                      ],
                      if (displayCollapsed) ...<Widget>[
                        _CollapsedUtilityIcon(icon: FluentIcons.plug_connected),
                        const SizedBox(height: 8),
                        _CollapsedUtilityIcon(icon: FluentIcons.lock),
                        const SizedBox(height: 18),
                      ],
                      const _SidebarDivider(),
                      const SizedBox(height: 14),
                      _SidebarNavItem(
                        icon: FluentIcons.documentation,
                        label: 'Docs',
                        collapsed: displayCollapsed,
                        selected: false,
                        dense: true,
                        onPressed: () {},
                      ),
                      _SidebarNavItem(
                        icon: FluentIcons.help,
                        label: 'Support',
                        collapsed: displayCollapsed,
                        selected: false,
                        dense: true,
                        onPressed: () {},
                      ),
                      _SidebarNavItem(
                        icon: FluentIcons.settings,
                        label: 'Settings',
                        collapsed: displayCollapsed,
                        selected: false,
                        dense: true,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SidebarBrand extends StatelessWidget {
  const _SidebarBrand({
    required this.collapsed,
    required this.onToggle,
  });

  final bool collapsed;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final toggle = HoverButton(
      onPressed: onToggle,
      builder: (context, states) {
        final hovered = states.isHovered;
        return Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: hovered ? AppTheme.surfaceHigh : AppTheme.surfaceContainer,
            borderRadius: BorderRadius.circular(RadiusApp.md),
            border: Border.all(color: AppTheme.outlineVariant),
          ),
          child: Icon(
            collapsed
                ? FluentIcons.global_nav_button
                : FluentIcons.chrome_close,
            size: 15,
            color: AppTheme.onSurfaceVariant,
          ),
        );
      },
    );

    if (collapsed) {
      return Column(
        children: <Widget>[
          const _BrandBadge(size: 44),
          const SizedBox(height: 10),
          toggle,
        ],
      );
    }

    return Row(
      children: <Widget>[
        const _BrandBadge(size: 44),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppConstants.appName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.headlineSm.copyWith(
                  color: AppTheme.secondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Swift Delivery',
                style: TextStyles.labelCaps,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        toggle,
      ],
    );
  }
}

class _BrandBadge extends StatelessWidget {
  const _BrandBadge({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppTheme.secondary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(RadiusApp.md),
        border: Border.all(
          color: AppTheme.secondary.withValues(alpha: 0.26),
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        FluentIcons.lightning_bolt,
        size: size * 0.44,
        color: AppTheme.secondary,
      ),
    );
  }
}

class _SidebarActionButton extends StatelessWidget {
  const _SidebarActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.collapsed,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool collapsed;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return HoverButton(
      onPressed: onPressed,
      builder: (context, states) {
        final hovered = states.isHovered;
        final pressed = states.isPressed;
        final background = highlighted
            ? (pressed
                ? AppTheme.secondaryContainer
                : hovered
                    ? AppTheme.secondary
                    : AppTheme.primaryContainer)
            : (hovered ? AppTheme.surfaceHigh : AppTheme.surfaceContainer);
        final foreground =
            highlighted ? AppTheme.onPrimary : AppTheme.onSurfaceVariant;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: collapsed ? 46 : 44,
          width: double.infinity,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(RadiusApp.base),
            border: Border.all(
              color: highlighted ? Colors.transparent : AppTheme.outlineVariant,
            ),
          ),
          alignment: Alignment.center,
          child: collapsed
              ? Icon(icon, size: 16, color: foreground)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(icon, size: 16, color: foreground),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: TextStyles.bodyMd.copyWith(
                        color: foreground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _SidebarNavItem extends StatelessWidget {
  const _SidebarNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.collapsed,
    required this.onPressed,
    this.dense = false,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool collapsed;
  final bool dense;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: dense ? 6 : 8),
      child: Tooltip(
        message: collapsed ? label : '',
        child: HoverButton(
          onPressed: onPressed,
          builder: (context, states) {
            final hovered = states.isHovered;
            final background = selected
                ? AppTheme.surfaceHigh
                : hovered
                    ? AppTheme.surfaceContainer
                    : Colors.transparent;
            final foreground = selected
                ? AppTheme.secondary
                : hovered
                    ? AppTheme.onSurface
                    : AppTheme.onSurfaceVariant;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              height: dense ? 40 : 44,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(RadiusApp.base),
                border: Border.all(
                  color: selected
                      ? AppTheme.secondary.withValues(alpha: 0.55)
                      : Colors.transparent,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: collapsed ? 0 : 14),
              child: collapsed
                  ? Center(
                      child: Icon(icon, size: 16, color: foreground),
                    )
                  : Row(
                      children: <Widget>[
                        Icon(icon, size: 16, color: foreground),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.bodyMd.copyWith(
                              color: foreground,
                              fontWeight:
                                  selected ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}

class _SidebarServiceTile extends StatelessWidget {
  const _SidebarServiceTile({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(RadiusApp.base),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 16, color: AppTheme.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.bodyMd.copyWith(
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CollapsedUtilityIcon extends StatelessWidget {
  const _CollapsedUtilityIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(RadiusApp.base),
        border: Border.all(color: AppTheme.outlineVariant),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 16, color: AppTheme.onSurfaceVariant),
    );
  }
}

class _SidebarDivider extends StatelessWidget {
  const _SidebarDivider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: AppTheme.outlineVariant);
  }
}
