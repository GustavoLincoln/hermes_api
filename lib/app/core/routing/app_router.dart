import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../modules/collections/presentation/pages/collections_page.dart';
import '../../modules/curl/presentation/pages/curl_page.dart';
import '../../modules/environments/presentation/pages/environments_page.dart';
import '../../modules/requests/presentation/cubit/request_workbench_cubit.dart';
import '../../modules/requests/presentation/pages/request_page.dart';
import '../../modules/requests/presentation/widgets/sidebar_widget.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/window_bar/widgets/app_window_title_bar.dart';

class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/requests',
    routes: <RouteBase>[
      ShellRoute(
        builder: (context, state, child) {
          return _HermesShell(
            currentPath: state.uri.path,
            sectionTitle: _titleForPath(state.uri.path),
            child: child,
          );
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/requests',
            builder: (context, state) {
              return BlocProvider<RequestWorkbenchCubit>(
                create: (_) => GetIt.I<RequestWorkbenchCubit>()..initialize(),
                child: const RequestPage(),
              );
            },
          ),
          GoRoute(
            path: '/collections',
            builder: (context, state) => const CollectionsPage(),
          ),
          GoRoute(
            path: '/environments',
            builder: (context, state) => const EnvironmentsPage(),
          ),
          GoRoute(path: '/curl', builder: (context, state) => const CurlPage()),
        ],
      ),
    ],
  );
}

class _HermesShell extends StatefulWidget {
  const _HermesShell({
    required this.currentPath,
    required this.sectionTitle,
    required this.child,
  });

  final String currentPath;
  final String sectionTitle;
  final Widget child;

  @override
  State<_HermesShell> createState() => _HermesShellState();
}

class _HermesShellState extends State<_HermesShell> {
  bool _isCompact = false;

  @override
  Widget build(BuildContext context) {
    return WindowBorder(
      color: AppTheme.outlineVariant,
      width: 1,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[AppTheme.surfaceLowest, AppTheme.surface],
          ),
        ),
        child: Column(
          children: <Widget>[
            AppWindowTitleBar(
              sectionTitle: widget.sectionTitle,
              isMenuOpen: _isCompact,
              onToggleMenu: () {
                setState(() {
                  _isCompact = !_isCompact;
                });
              },
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  SidebarWidget(
                    currentPath: widget.currentPath,
                    isCollapsed: _isCompact,
                    onToggle: () {
                      setState(() {
                        _isCompact = !_isCompact;
                      });
                    },
                  ),
                  Expanded(
                    child: _ShellBody(
                      currentPath: widget.currentPath,
                      sectionTitle: widget.sectionTitle,
                      child: widget.child,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShellBody extends StatelessWidget {
  const _ShellBody({
    required this.currentPath,
    required this.sectionTitle,
    required this.child,
  });

  final String currentPath;
  final String sectionTitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      child: DecoratedBox(
        decoration: AppTheme.panelDecoration(opacity: 0.96),
        child: Column(
          children: <Widget>[
            _WorkspaceHeader(
              currentPath: currentPath,
              sectionTitle: sectionTitle,
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  const Positioned(
                    top: -120,
                    right: -60,
                    child: _GlowOrb(size: 340),
                  ),
                  const Positioned(
                    bottom: -120,
                    left: 120,
                    child: _GlowOrb(size: 280),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                      child: child,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkspaceHeader extends StatelessWidget {
  const _WorkspaceHeader({
    required this.currentPath,
    required this.sectionTitle,
  });

  final String currentPath;
  final String sectionTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceDim,
        border: Border(
          bottom: BorderSide(color: AppTheme.outlineVariant),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Wrap(
              spacing: 18,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                _WorkspaceLink(
                  label: 'Requests',
                  active: currentPath == '/requests',
                  onPressed: () => context.go('/requests'),
                ),
                _WorkspaceLink(
                  label: 'Collections',
                  active: currentPath == '/collections',
                  onPressed: () => context.go('/collections'),
                ),
                _WorkspaceLink(
                  label: 'Environments',
                  active: currentPath == '/environments',
                  onPressed: () => context.go('/environments'),
                ),
                _WorkspaceLink(
                  label: 'cURL Tools',
                  active: currentPath == '/curl',
                  onPressed: () => context.go('/curl'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainer,
              borderRadius: BorderRadius.circular(AppTheme.radiusXl),
              border: Border.all(color: AppTheme.outlineVariant),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(
                  FluentIcons.status_circle_checkmark,
                  size: 12,
                  color: AppTheme.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  sectionTitle,
                  style: AppTheme.bodyMdStyle.copyWith(
                    color: AppTheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkspaceLink extends StatelessWidget {
  const _WorkspaceLink({
    required this.label,
    required this.active,
    required this.onPressed,
  });

  final String label;
  final bool active;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return HoverButton(
      onPressed: onPressed,
      builder: (context, states) {
        final hovered = states.isHovered;
        final color = active
            ? AppTheme.secondary
            : hovered
                ? AppTheme.onSurface
                : AppTheme.onSurfaceVariant;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.only(bottom: 4),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: active ? AppTheme.secondary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            label,
            style: AppTheme.bodyMdStyle.copyWith(
              color: color,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        );
      },
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: <Color>[Color(0x22E9C400), Color(0x00E9C400)],
          ),
        ),
      ),
    );
  }
}

String _titleForPath(String path) {
  switch (path) {
    case '/collections':
      return 'Collections';
    case '/environments':
      return 'Environments';
    case '/curl':
      return 'cURL Tools';
    default:
      return 'Request Workbench';
  }
}
