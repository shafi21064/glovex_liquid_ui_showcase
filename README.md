# glovex_liquid_ui_showcase

Showcase app for `glovex_liquid_ui` with `device_preview` enabled in debug/profile and disabled in release builds.

## Local development

```bash
flutter pub get
flutter run
```

To run on web locally:

```bash
flutter run -d chrome
```

## Device Preview integration

- Dependency: `device_preview: ^1.3.1`
- `DevicePreview` wraps `ShowcaseApp` in `main.dart`
- `MaterialApp` uses `DevicePreview.locale(context)` and `DevicePreview.appBuilder`

## GitHub Pages deployment

This repository includes a workflow at `.github/workflows/deploy-web.yml`.

### One-time GitHub settings

1. Push this project to a GitHub repository.
2. In GitHub, go to **Settings → Pages**.
3. Under **Build and deployment**, set **Source** to **GitHub Actions**.

### Deploy

- Push to the `main` branch, or run the workflow manually from **Actions**.
- The workflow builds with:

```bash
flutter build web --release --base-href "/<repo-name>/"
```

This base href makes the app work correctly on GitHub Pages project URLs.
