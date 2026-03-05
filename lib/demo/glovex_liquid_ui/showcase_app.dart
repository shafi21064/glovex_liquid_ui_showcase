import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glovex_liquid_ui/glovex_liquid_ui.dart';

class GlovexLiquidUiDemoPage extends StatelessWidget {
  const GlovexLiquidUiDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      color: Colors.transparent,
      child: ShowcaseHome(),
    );
  }
}

class ShowcaseHome extends StatefulWidget {
  const ShowcaseHome({super.key});

  @override
  State<ShowcaseHome> createState() => _ShowcaseHomeState();
}

class _ShowcaseHomeState extends State<ShowcaseHome> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LiquidBottomNavScaffold(
      currentIndex: _currentIndex,
      onTap: (i) => setState(() => _currentIndex = i),
      background: const _GradientBackground(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      items: const [
        LiquidGlassBottomNavItem(
          icon: CupertinoIcons.house,
          activeIcon: CupertinoIcons.house_fill,
          label: 'Home',
        ),
        LiquidGlassBottomNavItem(
          icon: CupertinoIcons.layers,
          activeIcon: CupertinoIcons.layers_fill,
          label: 'Widgets',
        ),
        LiquidGlassBottomNavItem(
          icon: CupertinoIcons.gear,
          activeIcon: CupertinoIcons.gear_solid,
          label: 'Actions',
        ),
      ],
      children: const [
        _HomeTab(),
        _WidgetsTab(),
        _ActionsTab(),
      ],
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final scaledTitle = const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)
        .liquidScale(context);
    final sidePadding = context.liquidValue<double>(mobile: 0, tablet: 10, desktop: 28);

    return SafeArea(
      child: ListView(
        padding: EdgeInsets.fromLTRB(sidePadding, 14, sidePadding, 10),
        children: [
          const LiquidGlassTopBar(title: 'glovex_liquid_ui • Full Showcase'),
          const SizedBox(height: 12),
          LiquidGlassSection(
            title: 'Responsive + Theme',
            subtitle:
                'screen: ${context.liquidScreenType.name} • textScale presets: '
                '${LiquidTextScaleTokens.textScaleMobile}/'
                '${LiquidTextScaleTokens.textScaleTablet}/'
                '${LiquidTextScaleTokens.textScaleDesktop}',
            children: [
              LiquidGlassSurface(
                padding: const EdgeInsets.all(14),
                child: Text(
                  'This text uses TextStyle.liquidScale(context)',
                  style: scaledTitle.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              const LiquidGlassCard(
                child: Text(
                  'LiquidGlassCard (real blur)',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const LiquidGlassProfileHeader(
            name: 'Glovex Creator',
            email: 'hello@glovency.com',
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                child: LiquidGlassStatsCard(
                  label: 'Downloads',
                  value: '46+',
                  trend: '+today',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: LiquidGlassStatsCard(
                  label: 'Widgets',
                  value: '20+',
                  trend: 'ready',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WidgetsTab extends StatefulWidget {
  const _WidgetsTab();

  @override
  State<_WidgetsTab> createState() => _WidgetsTabState();
}

class _WidgetsTabState extends State<_WidgetsTab> {
  final _searchController = TextEditingController();
  final _inputController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _switchValue = true;
  bool _checkValue = false;
  String _dropdownValue = 'One';
  String _radioValue = 'A';

  @override
  void dispose() {
    _searchController.dispose();
    _inputController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(top: 14, bottom: 12),
        children: [
          const LiquidGlassTopBar(title: 'Inputs & Controls'),
          const SizedBox(height: 12),
          LiquidGlassSearchBar(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),
          LiquidGlassInput(
            controller: _inputController,
            placeholder: 'Name',
            prefix: const Icon(Icons.person_outline, color: Colors.white),
          ),
          const SizedBox(height: 10),
          LiquidGlassInput(
            controller: _passwordController,
            placeholder: 'Password',
            obscureText: true,
            showPasswordToggle: true,
            suffix: const Icon(Icons.lock_outline, color: Colors.white70),
          ),
          const SizedBox(height: 12),
          LiquidGlassSection(
            title: 'Interactive widgets',
            children: [
              LiquidGlassDropdown<String>(
                value: _dropdownValue,
                items: const [
                  DropdownMenuItem(value: 'One', child: Text('One')),
                  DropdownMenuItem(value: 'Two', child: Text('Two')),
                  DropdownMenuItem(value: 'Three', child: Text('Three')),
                ],
                onChanged: (v) => setState(() => _dropdownValue = v ?? 'One'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: LiquidGlassListTile(
                      title: 'Switch',
                      subtitle: _switchValue ? 'Enabled' : 'Disabled',
                      trailing: LiquidGlassSwitch(
                        value: _switchValue,
                        onChanged: (v) => setState(() => _switchValue = v),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LiquidGlassListTile(
                title: 'Checkbox',
                subtitle: _checkValue ? 'Checked' : 'Unchecked',
                trailing: LiquidGlassCheckbox(
                  value: _checkValue,
                  onChanged: (v) => setState(() => _checkValue = v ?? false),
                ),
              ),
              const SizedBox(height: 8),
              LiquidGlassListTile(
                title: 'Radio A/B',
                subtitle: 'Selected: $_radioValue',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LiquidGlassRadio<String>(
                      value: 'A',
                      groupValue: _radioValue,
                      onChanged: (v) => setState(() => _radioValue = v),
                    ),
                    const SizedBox(width: 8),
                    LiquidGlassRadio<String>(
                      value: 'B',
                      groupValue: _radioValue,
                      onChanged: (v) => setState(() => _radioValue = v),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: LiquidGlassButton(
                  label: 'Primary',
                  leading: const Icon(CupertinoIcons.checkmark, color: Colors.white),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: LiquidGlassButton(
                  label: 'Ghost',
                  variant: LiquidGlassButtonVariant.ghost,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 10),
              LiquidGlassIconButton(
                icon: const Icon(CupertinoIcons.heart, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionsTab extends StatelessWidget {
  const _ActionsTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LiquidResponsiveBuilder(
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.only(top: 14, bottom: 12),
            children: [
              const LiquidGlassTopBar(title: 'Feedback & States'),
              const SizedBox(height: 12),
              LiquidGlassEmptyState(
                title: 'No items found',
                message: 'This screen demonstrates toast, loader and modal sheet.',
                action: LiquidGlassButton(
                  label: 'Show Toast',
                  onPressed: () => LiquidGlassToast.show(
                    context,
                    'LiquidGlassToast from glovex_liquid_ui',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Center(child: LiquidGlassLoader(label: 'Loading preview...')),
              const SizedBox(height: 14),
              LiquidGlassButton(
                expanded: true,
                label: 'Open Liquid Modal Sheet',
                leading: const Icon(Icons.open_in_new, color: Colors.white),
                onPressed: () => LiquidGlassModalSheet.show(
                  context,
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: LiquidGlassSection(
                      title: 'Modal content',
                      subtitle: 'All from package widgets',
                      children: const [
                        LiquidGlassListTile(
                          title: 'Option 1',
                          leading: Icon(Icons.layers_outlined),
                        ),
                        SizedBox(height: 8),
                        LiquidGlassListTile(
                          title: 'Option 2',
                          leading: Icon(Icons.palette_outlined),
                        ),
                      ],
                    ),
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

class _GradientBackground extends StatelessWidget {
  const _GradientBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF090F2B),
            Color(0xFF241533),
            Color(0xFF0C2B52),
          ],
        ),
      ),
      child: SizedBox.expand(),
    );
  }
}
