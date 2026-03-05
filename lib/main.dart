import 'dart:convert';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:glovex_liquid_ui/glovex_liquid_ui.dart';
import 'package:http/http.dart' as http;
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
      backgroundColor: const Color(0xFF060B1A),
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
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF111B38), Color(0xFF0B1228)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF223157)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'discover flutter packages by us',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 760),
                              child: Text(
                                'Curated package demos with live stats, quick preview access, '
                                'and direct package links for your next Flutter app.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: const Color(0xFF93A4D0),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              '${demoPackages.length} package demo(s) available',
                              style: const TextStyle(
                                color: Color(0xFF6DD6FF),
                                fontWeight: FontWeight.w700,
                              ),
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
    final fallbackStats = _PubDevStats(
      version: package.version,
      grantedPoints: package.pubPoints,
      maxPoints: package.maxPubPoints,
      likes: package.likes,
      downloads: package.downloads,
    );

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0E162F),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF26365F)),
      ),
      child: FutureBuilder<_PubDevStats>(
        future: _PubDevStatsService.fetch(package),
        builder: (context, snapshot) {
          final stats = snapshot.data ?? fallbackStats;

          return Column(
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
                            color: const Color(0xFF1B2F57),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(package.icon, color: const Color(0xFF6DD6FF)),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A2748),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            stats.version,
                            style: const TextStyle(
                              color: Color(0xFFB9C9F2),
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
                          color: Colors.white,
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
                          color: Color(0xFFA6B4DA),
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          _StatBadge(
                            icon: Icons.verified_rounded,
                            iconColor: const Color(0xFF10B981),
                            value: '${stats.grantedPoints}/${stats.maxPoints}',
                            label: 'Pub Points',
                          ),
                          _StatBadge(
                            icon: Icons.favorite_rounded,
                            iconColor: const Color(0xFFF43F5E),
                            value: '${stats.likes}',
                            label: 'Likes',
                          ),
                          _StatBadge(
                            icon: Icons.download_rounded,
                            iconColor: const Color(0xFF6DD6FF),
                            value: _formatDownloads(stats.downloads),
                            label: '30d DL',
                          ),
                      ],
                    ),
                  ],
                ),
              ),
                const Divider(height: 1, color: Color(0xFF26365F)),
              SizedBox(
                height: 48,
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF6DD6FF),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(14),
                            ),
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
                          foregroundColor: const Color(0xFFB2C1EA),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(14),
                            ),
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
          );
        },
      ),
    );
  }
}

class _PubDevStats {
  const _PubDevStats({
    required this.version,
    required this.grantedPoints,
    required this.maxPoints,
    required this.likes,
    required this.downloads,
  });

  final String version;
  final int grantedPoints;
  final int maxPoints;
  final int likes;
  final int downloads;
}

class _PubDevStatsService {
  static final Map<String, Future<_PubDevStats>> _cache = {};

  static Future<_PubDevStats> fetch(DemoPackage package) {
    return _cache.putIfAbsent(package.name, () => _fetchInternal(package));
  }

  static Future<_PubDevStats> _fetchInternal(DemoPackage package) async {
    final fallback = _PubDevStats(
      version: package.version,
      grantedPoints: package.pubPoints,
      maxPoints: package.maxPubPoints,
      likes: package.likes,
      downloads: package.downloads,
    );

    try {
      final packageUri = Uri.parse('https://pub.dev/api/packages/${package.name}');
      final scoreUri = Uri.parse('https://pub.dev/api/packages/${package.name}/score');

      final packageResponse = await http.get(packageUri);
      final scoreResponse = await http.get(scoreUri);

      if (packageResponse.statusCode != 200 || scoreResponse.statusCode != 200) {
        return fallback;
      }

      final packageJson = jsonDecode(packageResponse.body) as Map<String, dynamic>;
      final scoreJson = jsonDecode(scoreResponse.body) as Map<String, dynamic>;
      final score = scoreJson['score'] as Map<String, dynamic>?;

      final latest = packageJson['latest'] as Map<String, dynamic>?;
        final latestPubspec = latest?['pubspec'] as Map<String, dynamic>?;
        final liveVersion =
          (latestPubspec?['version'] as String?) ?? (latest?['version'] as String?);
      final livePoints = score?['grantedPoints'] as int?;
      final liveMaxPoints = score?['maxPoints'] as int?;
      final liveLikes = score?['likeCount'] as int?;
      final liveDownloads = score?['downloadCount30Days'] as int?;

      return _PubDevStats(
        version: liveVersion == null || liveVersion.isEmpty
            ? fallback.version
            : 'v$liveVersion',
        grantedPoints: livePoints ?? fallback.grantedPoints,
        maxPoints: liveMaxPoints ?? fallback.maxPoints,
        likes: liveLikes ?? fallback.likes,
        downloads: liveDownloads ?? fallback.downloads,
      );
    } catch (_) {
      return fallback;
    }
  }
}

class _StatBadge extends StatelessWidget {
  const _StatBadge({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 4),
        Text(
          '$value $label',
          style: const TextStyle(
            color: Color(0xFFD1DCFF),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

String _formatDownloads(int value) {
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(1)}M';
  }
  if (value >= 1000) {
    return '${(value / 1000).toStringAsFixed(1)}K';
  }
  return '$value';
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
