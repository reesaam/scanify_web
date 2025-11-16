
<p align="center">
  Scanify Web Document Scanner
</p>
<p align="center">
  <!-- Pub Version -->
  <a href="https://pub.dev/packages/scanify_web"><img src="https://img.shields.io/pub/v/scanify_web?logo=dart" alt="PubVersion"></a>
  <!-- Pub Points} -->
  <a href="https://pub.dev/packages/scanify_web"><img src="https://img.shields.io/pub/points/scanify_web?logo=dart" alt="PubPoints"></a>
  <!-- GitHub Repo -->
  <a href="https://github.com/reesaam/scanify_web"><img src="https://img.shields.io/badge/repo-Scanify_Web_Document_Scanner-yellowgreen?logo=github" alt="build"></a>
  <!-- GitHub Stars -->
  <a href="https://github.com/reesaam/scanify_web"><img src="https://img.shields.io/github/stars/felangel/bloc.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Star on Github"></a>
  <!-- DartDoc -->
  <a href="https://pub.dev/documentation/scanify_web/latest"><img src="https://img.shields.io/badge/dartdocs-latest-blue.svg" alt="Latest Dartdocs"></a>
</p>
<p align="center">
  <a href="https://github.com/reesaam/scanify_web"><img src="https://img.shields.io/badge/Web-black" alt="ios"></a>

</p>

A Flutter Package to Scan Document on WEB.

### Contents:
* [Getting Started](#Getting-Started)
* [Usage](#Usage)
* [Options](#Options)
* [Docs](#Docs)
* [About Author](#About-Author)
* [Packages and Dependencies](#Packages-and-Dependencies)
* [Testing](#Testing)

## Getting Started

Add dependencies in the `pubspec.yaml`:
```yaml
dependencies:
  scanify_web: ^latest
```

Get the Changes by:
```shell
flutter pub get
```
or
```shell
dart pub get
```

## Usage

```dart
import 'package:scanify_web/scanify_web.dart';
```

`ScanifyController` must be initialized:
```dart
  void _controllerInitialization() async {
  scanifyStatus = ScanifyStatus.initializing;
  final List<CameraDescription> cameras = await availableCameras();
  if (cameras.isNotEmpty) {
    final CameraDescription selectedCamera = cameras.first;
    scanifyController = ScanifyController(description: selectedCamera);
    if (scanifyController != null) {
      await scanifyController?.initialize();
    } else {
      throw Exception(PackageStrings.throwErrorControllerInitialization);
    }
  } else {
    throw Exception(PackageStrings.throwErrorCameraAvailability);
  }
}
```

`ScanifyController` Can be Initialized in page initialization OR triggered by a trigger such as tapping on a Button:
```dart
  void onInit() {
  _controllerInitialization();
  super.initState();
}
```
OR
```dart
Button(onPressed: () => _controllerInitialization(), child: Text('ScanifyController Initialization'));
```

> **_NOTE:_**
> In either way, `ScanifyController` must be initialized before having `Scanner` Widget.

Using Scanner Widget in your Screen:
```dart
ScanifyWebScanner(scanifyController!);
```

Controller will return the Captured Document:
```dart
ScanifyResponse scanifyResponse = await scanifyController!.startAutoScan();
```

The `Status` of the `Scanify` can be controlled by setting the `ScanifyStatus` of the `ScanifyController`:
```dart
ScanifyStatus scanifyStatus = ScanifyStatus.scanning;
```

### You can check the `/example` for a more complete example, more details and further information.

## Docs
<a href="https://github.com/reesaam/scanify_web/tree/main/generator/doc/api"><img src="https://img.shields.io/badge/GitHub-Docs_Repository-important?logo=github" alt="build"></a>

## About Author

### Resam Taghipour
<a href="https://www.resam.site"><img src="https://img.shields.io/badge/Website-resam.site-blue" alt="Pub"></a>
<a href="https://github.com/reesaam"><img src="https://img.shields.io/badge/GitHub-reesaam-black?style=flat&logo=github&link=https%3A%2F%2Fgithub.com%2Freesaam" alt="account"></a>
<a href="https://www.linkedin.com/in/resam"><img src="https://img.shields.io/badge/LinkedIn-resam-blue?logo=linkedin" alt="Pub"></a>
<a><img src="https://img.shields.io/badge/Email-resam@resam.site-important?logo=maildotru" alt="Pub"></a>


## Packages and Dependencies
<a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-red?logo=dart" alt="Pub"></a>
<a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-blue?logo=flutter" alt="Pub"></a>
<a href="https://pub.dev/packages/get"><img src="https://img.shields.io/badge/pub-GetX-blue?logo=dart" alt="Pub"></a>
<a href="https://pub.dev/packages/dartdoc"><img src="https://img.shields.io/badge/pub-DartDoc-red?logo=dart" alt="Pub"></a>

## License
This project is licensed under the '**BSD-3-Clause**' License - see the LICENSE for details.

<a href="https://pub.dev/packages/scanify_web/license"><img src="https://img.shields.io/badge/LICENSE-blue" alt="Pub"></a>