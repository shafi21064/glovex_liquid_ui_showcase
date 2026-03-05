import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:glovex_liquid_ui/glovex_liquid_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import 'demo/demo_registry.dart';

const bool _enableDevicePreview = bool.fromEnvironment(
  'DEVICE_PREVIEW',
  defaultValue: true,
);

void main() {
  runApp(const ShowcaseWebsiteApp());
}

class ShowcaseWebsiteApp extends StatelessWidget {
  const ShowcaseWebsiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Package Showcase',
      theme: ThemeData(
        brightness: Brightness.dark,
        extensions: const [
          LiquidGlassTheme(
            tintColor: Colors.white,
            highlightColor: Colors.white,
            borderColor: Color(0x4DFFFFFF),
            shadowColor: Colors.black,
            cardRadius: BorderRadius.all(Radius.circular(24)),
            capsuleRadius: BorderRadius.all(Radius.circular(9999)),
            enableBlur: true,
            blurMode: LiquidBlurMode.real,
            blurSigma: 14,
            borderWidth: 1.2,
            tintOpacity: 0.06,
            highlightOpacity: 0.16,
            shadowOpacity: 0.12,
          ),
        ],
      ),
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const _LandingPage(),
    ),
    GoRoute(
      path: '/package/:packageName',
      builder: (context, state) {
        final packageName = state.pathParameters['packageName'] ?? '';
        final package = findDemoPackage(packageName);
        if (package == null) {
          return _NotFoundPage(packageName: packageName);
        }
        return _PackageDetailsPage(package: package);
      },
    ),
    GoRoute(
      path: '/demo/:packageName',
      builder: (context, state) {
        final packageName = state.pathParameters['packageName'] ?? '';
        final package = findDemoPackage(packageName);
        if (package != null) {
          return DevicePreview(
            enabled: _enableDevicePreview,
            builder: package.demoBuilder,
          );
        }
        return _NotFoundPage(packageName: packageName);
      },
    ),
  ],
);

class _LandingPage extends StatelessWidget {
  const _LandingPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        title: const Text('Flutter Package Hub'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0175C2),
                foregroundColor: Colors.white,
              ),
              onPressed: () {},
              child: const Text('Publish Package'),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          const horizontalPadding = 24.0;
          const gridSpacing = 18.0;
          final contentWidth = constraints.maxWidth - (horizontalPadding * 2);
          final columns = contentWidth >= 1100
              ? 3
              : contentWidth >= 760
              ? 2
              : 1;
          final cardWidth =
              (contentWidth - (gridSpacing * (columns - 1))) / columns;

          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1240),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    horizontalPadding,
                    28,
                    horizontalPadding,
                    36,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Discover top-tier Flutter packages',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: const Color(0xFF0F172A),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 760),
                              child: Text(
                                'A clean and professional hub to browse Flutter package demos. '
                                'Each card provides a live demo and direct package link.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: const Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              alignment: WrapAlignment.center,
                              children: const [
                                _CategoryChip(label: 'All', selected: true),
                                _CategoryChip(label: 'UI Design'),
                                _CategoryChip(label: 'State Management'),
                                _CategoryChip(label: 'Animation'),
                                _CategoryChip(label: 'Network'),
                                _CategoryChip(label: 'Database'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      Wrap(
                        spacing: gridSpacing,
                        runSpacing: gridSpacing,
                        children: [
                          for (final package in demoPackages)
                            SizedBox(
                              width: cardWidth,
                              child: _PackageCard(package: package),
                            ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const _LandingFooter(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.package});

  final DemoPackage package;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(package.icon, color: const Color(0xFF0175C2)),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        package.version,
                        style: const TextStyle(
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  package.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  package.summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.verified_rounded, size: 16, color: Color(0xFF10B981)),
                    const SizedBox(width: 4),
                    Text(
                      '${package.pubPoints} Pub Points',
                      style: const TextStyle(
                        color: Color(0xFF334155),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.favorite_rounded, size: 16, color: Color(0xFFF43F5E)),
                    const SizedBox(width: 4),
                    Text(
                      package.likes.toString(),
                      style: const TextStyle(
                        color: Color(0xFF334155),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          SizedBox(
            height: 48,
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF0175C2),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(14)),
                      ),
                    ),
                    onPressed: () => context.go(package.demoPath),
                    child: const Text(
                      'VIEW DEMO',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const VerticalDivider(width: 1, color: Color(0xFFE2E8F0)),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF475569),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(14)),
                      ),
                    ),
                    onPressed: () => _openPackageUrl(package.packageSite),
                    child: const Text(
                      'PACKAGE DETAILS',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
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

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: selected ? const Color(0xFF0175C2) : Colors.white,
      side: BorderSide(
        color: selected ? const Color(0xFF0175C2) : const Color(0xFFE2E8F0),
      ),
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : const Color(0xFF475569),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _LandingFooter extends StatelessWidget {
  const _LandingFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        alignment: WrapAlignment.spaceBetween,
        children: const [
          Text(
            '© Flutter Package Hub',
            style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600),
          ),
          Text(
            'Curated demos for Flutter packages',
            style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

Future<void> _openPackageUrl(String url) async {
  final uri = Uri.parse(url);
  await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
    webOnlyWindowName: '_blank',
  );
}

class _PackageDetailsPage extends StatelessWidget {
  const _PackageDetailsPage({required this.package});

  final DemoPackage package;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(package.name)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        package.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(package.summary),
                      const SizedBox(height: 16),
                      const Text(
                        'Package link',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      SelectableText(package.packageSite),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => context.go(package.demoPath),
                icon: const Icon(CupertinoIcons.play_circle),
                label: const Text('Open Demo Page'),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () => context.go('/'),
                child: const Text('Back to Landing'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage({required this.packageName});

  final String packageName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('No entry found for "$packageName"'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go to landing'),
            ),
          ],
        ),
      ),
    );
  }
}
