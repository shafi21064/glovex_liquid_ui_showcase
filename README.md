# glovex_liquid_ui_showcase

Router-based Flutter website for package showcases.

## Website structure

- Landing page: `/`
- Package details: `/package/<package_name>`
- Demo page: `/demo/<package_name>`

Current live domain target:

- `https://flutter-package.glovency.com`

Current demo:

- `https://flutter-package.glovency.com/demo/glovex_liquid_ui`

Landing list includes two actions per package:

- `Try Demo`
- `Package Info`

## Local development

```bash
flutter pub get
flutter run
```

Web:

```bash
flutter run -d chrome
```

## Demo architecture

- Demo code stays inside this project under `lib/demo/<package_name>/`
- Demo registry is centralized in `lib/demo/demo_registry.dart`
- Router and pages are managed in `lib/main.dart`

### Device Preview behavior

- `device_preview: ^1.3.1` is used
- Device preview is enabled only on demo routes (`/demo/<package_name>`)
- Landing and package pages do not use device preview

## Add a new package demo

1. Create folder: `lib/demo/<package_name>/`
2. Add your demo page widget there
3. Import and register a `DemoPackage` entry in `lib/demo/demo_registry.dart`

After registration, landing list + package page + demo route work automatically.

## GitHub Pages deployment

Workflow file: `.github/workflows/deploy-web.yml`

### One-time GitHub setup

1. Push this repository to GitHub.
2. Open **Settings → Pages**.
3. Set **Source** to **GitHub Actions**.
4. Set custom domain to `flutter-package.glovency.com`.

### Deploy

- Push to `main` or `master`, or run workflow manually.
- Web build command:

```bash
flutter build web --release --base-href "/"
```

The workflow also writes:

- `CNAME` with `flutter-package.glovency.com`
- `404.html` fallback for SPA route refresh support
