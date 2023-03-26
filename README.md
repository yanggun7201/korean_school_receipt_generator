# korean_school_receipt_generator

The Korean school Receipt Generator

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## Windows

### Normal build
```
flutter build windows
```

### Build with the [msix](https://pub.dev/packages/msix) 
#### pubspec.yaml
```
msix_config:
  display_name: Flutter App
  publisher_display_name: Company Name
  identity_name: company.suite.flutterapp
  msix_version: 1.0.0.0
  logo_path: C:\path\to\logo.png
  capabilities: internetClient, location, microphone, webcam
```

#### install msix and build 
```
flutter pub add --dev msix
flutter pub run msix:create
```
