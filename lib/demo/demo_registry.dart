import 'package:flutter/widgets.dart';

import 'glovex_liquid_ui/showcase_app.dart';

class DemoPackage {
  const DemoPackage({
    required this.name,
    required this.summary,
    required this.packageSite,
    required this.demoBuilder,
  });

  final String name;
  final String summary;
  final String packageSite;
  final WidgetBuilder demoBuilder;

  String get packagePath => '/package/$name';
  String get demoPath => '/demo/$name';
}

const demoPackages = <DemoPackage>[
  DemoPackage(
    name: 'glovex_liquid_ui',
    summary: 'Liquid glass widgets showcase for Flutter apps.',
    packageSite: 'https://pub.dev/packages/glovex_liquid_ui',
    demoBuilder: _glovexLiquidUiDemoBuilder,
  ),
];

DemoPackage? findDemoPackage(String name) {
  for (final package in demoPackages) {
    if (package.name == name) {
      return package;
    }
  }
  return null;
}

Widget _glovexLiquidUiDemoBuilder(BuildContext context) {
  return const GlovexLiquidUiDemoPage();
}
