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
import '../../shared/widgets/panel_card.dart';

class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/requests',
    routes: <RouteBase>[
      ShellRoute(
        builder: (context, state, child) {
          return _HermesShell(currentPath: state.uri.path, child: child);
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
  const _HermesShell({required this.currentPath, required this.child});

  final String currentPath;
  final Widget child;

  @override
  State<_HermesShell> createState() => _HermesShellState();
}

class _HermesShellState extends State<_HermesShell> {
  bool _isCompact = false;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndex(widget.currentPath);

    return WindowBorder(
      color: const Color(0x443D434C),
      width: 1,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0x8814171B), Color(0xCC101215)],
          ),
        ),
        child: NavigationView(
          clipBehavior: Clip.antiAlias,
          titleBar: _HermesTitleBar(
            currentPath: widget.currentPath,
            isCompact: _isCompact,
            onTogglePane: () {
              setState(() {
                _isCompact = !_isCompact;
              });
            },
          ),
          pane: NavigationPane(
            selected: selectedIndex,
            displayMode: _isCompact
                ? PaneDisplayMode.compact
                : PaneDisplayMode.expanded,
            size: const NavigationPaneSize(openWidth: 290, compactWidth: 72),
            onChanged: (index) => _onPaneChanged(index, context),
            header: const _PaneHeader(),
            items: <NavigationPaneItem>[
              PaneItemHeader(header: const Text('WORKSPACE')),
              PaneItem(
                icon: const Icon(FluentIcons.send),
                title: const Text('Requests'),
                body: widget.child,
              ),
              PaneItem(
                icon: const Icon(FluentIcons.fabric_folder),
                title: const Text('Collections'),
                body: widget.child,
              ),
              PaneItem(
                icon: const Icon(FluentIcons.server_enviroment),
                title: const Text('Environments'),
                body: widget.child,
              ),
              PaneItemSeparator(),
            ],
            footerItems: <NavigationPaneItem>[
              PaneItem(
                icon: const Icon(FluentIcons.code),
                title: const Text('cURL Tools'),
                body: widget.child,
              ),
            ],
          ),
          paneBodyBuilder: (item, body) => _ShellBody(child: widget.child),
        ),
      ),
    );
  }

  int _selectedIndex(String path) {
    switch (path) {
      case '/collections':
        return 1;
      case '/environments':
        return 2;
      case '/curl':
        return 3;
      default:
        return 0;
    }
  }

  void _onPaneChanged(int index, BuildContext context) {
    switch (index) {
      case 1:
        context.go('/collections');
      case 2:
        context.go('/environments');
      case 3:
        context.go('/curl');
      default:
        context.go('/requests');
    }
  }
}

class _HermesTitleBar extends StatelessWidget {
  const _HermesTitleBar({
    required this.currentPath,
    required this.isCompact,
    required this.onTogglePane,
  });

  final String currentPath;
  final bool isCompact;
  final VoidCallback onTogglePane;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    return WindowTitleBarBox(
      child: Container(
        height: 56,
        padding: const EdgeInsets.only(left: 12, right: 8),
        decoration: BoxDecoration(
          color: const Color(0x44181B20),
          border: Border(bottom: BorderSide(color: const Color(0x443D434C))),
        ),
        child: Row(
          children: <Widget>[
            Button(
              onPressed: onTogglePane,
              style: ButtonStyle(
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return const Color(0x221A1D21);
                  }
                  return Colors.transparent;
                }),
              ),
              child: Icon(
                isCompact ? FluentIcons.global_nav_button : FluentIcons.back,
                size: 14,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(
                FluentIcons.send,
                size: 14,
                color: Color(0xFF3A3000),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Hermes',
              style: theme.typography.title?.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              _titleForPath(currentPath),
              style: theme.typography.caption?.copyWith(
                color: const Color(0xFFB7BEC8),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MoveWindow(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: const TextBox(
                      placeholder:
                          'Search requests, collections or environments',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const _WindowCaptionButtons(),
          ],
        ),
      ),
    );
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
}

class _PaneHeader extends StatelessWidget {
  const _PaneHeader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(14, 8, 14, 14),
      child: PanelCard(
        padding: EdgeInsets.all(14),
        elevated: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Swift Delivery',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: Color(0xFFB7BEC8),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Offline-first API client with cURL import at the center of the workflow.',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: Color(0xFFB7BEC8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShellBody extends StatelessWidget {
  const _ShellBody({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const Positioned(top: -120, right: -60, child: _GlowOrb(size: 340)),
        const Positioned(bottom: -120, left: 120, child: _GlowOrb(size: 280)),
        Positioned.fill(
          child: Padding(padding: const EdgeInsets.all(20), child: child),
        ),
      ],
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
            colors: <Color>[Color(0x22FFD700), Color(0x00FFD700)],
          ),
        ),
      ),
    );
  }
}

class _WindowCaptionButtons extends StatelessWidget {
  const _WindowCaptionButtons();

  @override
  Widget build(BuildContext context) {
    final buttonColors = WindowButtonColors(
      iconNormal: const Color(0xFFB7BEC8),
      mouseOver: const Color(0x221A1D21),
      mouseDown: const Color(0x441A1D21),
      iconMouseOver: Colors.white,
      iconMouseDown: Colors.white,
    );

    final closeColors = WindowButtonColors(
      iconNormal: const Color(0xFFB7BEC8),
      mouseOver: const Color(0xFFD13438),
      mouseDown: const Color(0xFFA4262C),
      iconMouseOver: Colors.white,
      iconMouseDown: Colors.white,
    );

    return Row(
      children: <Widget>[
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeColors),
      ],
    );
  }
}
