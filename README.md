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

### [Install Flutter](https://docs.flutter.dev/get-started/install)

### [Install Visual Studio](https://visualstudio.microsoft.com/vs/)
need to install [C++](/screenshots/visual_studio_c++.png) together.

### Enable the developer option in Windows
On Windows 11 go to settings: Click on Privacy & Security and after, click on for developers option.
On for developers settings, activate the Developer mode option (Install apps from any source...).
![windows 11](/screenshots/windows_developer_option.png "")

### Normal build
```
flutter build windows
```

### Post build
```
cp -R ./assets_real/images ./build/
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
