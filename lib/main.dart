import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/bhavana_theme.dart';
import 'features/home/screens/home_screen.dart';
import 'features/practice_log/screens/practice_log_screen.dart';
import 'features/unlock/services/unlock_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await UnlockService.instance.load();
  runApp(const BhavanaApp());
}

class BhavanaApp extends StatelessWidget {
  const BhavanaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      builder: AppTheme.builder,
      home: const RootShell(),
    );
  }
}

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  /// Bumped when Log tab gains focus so IndexedStack does not keep a stale Future.
  int _logFocusGen = 0;

  void _selectTab(int i) {
    setState(() {
      if (i == 1 && _index != 1) {
        _logFocusGen++;
      }
      _index = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = BhavanaTheme.colorsOf(context);

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          const HomeScreen(),
          PracticeLogScreen(focusGeneration: _logFocusGen),
        ],
      ),
      bottomNavigationBar: Material(
        color: colors.surfaceRaised,
        child: SafeArea(
          top: false,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: colors.border.withValues(alpha: 0.55)),
              ),
            ),
            child: SizedBox(
              height: 64,
              child: Row(
                children: [
                  _NavItem(
                    selected: _index == 0,
                    icon: Icons.water_rounded,
                    label: 'Practice',
                    onTap: () => _selectTab(0),
                  ),
                  _NavItem(
                    selected: _index == 1,
                    icon: Icons.menu_book_outlined,
                    label: 'Log',
                    onTap: () => _selectTab(1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = BhavanaTheme.colorsOf(context);
    final t = BhavanaTheme.typographyOf(context);
    final s = BhavanaTheme.spacingOf(context);
    final motion = BhavanaTheme.motionOf(context);
    final fg = selected ? c.primary : c.onSurfaceMuted;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: c.primary.withValues(alpha: 0.08),
        highlightColor: c.primary.withValues(alpha: 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: motion.fast,
              curve: motion.curve,
              padding: EdgeInsets.symmetric(
                horizontal: s.sm,
                vertical: s.xxs,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? c.primary.withValues(alpha: 0.14)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(
                  BhavanaTheme.radiiOf(context).pill,
                ),
              ),
              child: Icon(icon, size: 24, color: fg),
            ),
            SizedBox(height: s.xxs),
            Text(
              label,
              style: t.textTheme.labelSmall?.copyWith(
                color: fg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
