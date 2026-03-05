import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:glovex_liquid_ui/glovex_liquid_ui.dart';

import 'demo/demo_registry.dart';

const bool _enableDevicePreview = bool.fromEnvironment(
  'DEVICE_PREVIEW',
  defaultValue: !kReleaseMode,
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
      appBar: AppBar(title: const Text('Flutter Package Hub')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'All Flutter package showcases',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text('Pick a package and either open demo or view package details.'),
          const SizedBox(height: 16),
          for (final package in demoPackages)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    Text(package.summary),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => context.go(package.demoPath),
                            icon: const Icon(CupertinoIcons.play_circle),
                            label: const Text('Try Demo'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => context.go(package.packagePath),
                            icon: const Icon(CupertinoIcons.cube_box),
                            label: const Text('Package Info'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PackageDetailsPage extends StatelessWidget {
  const _PackageDetailsPage({required this.package});

  final DemoPackage package;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(package.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            package.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(package.summary),
          const SizedBox(height: 16),
          const Text('Package link', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          SelectableText(package.packageSite),
          const SizedBox(height: 20),
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
