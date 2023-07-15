<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

## Golog

<p>
	<a href="https://pub.dev/packages/golog"><img src="https://img.shields.io/pub/v/golog" alt="Pub.dev Badge"></a>
	<a href="https://github.com/irfnyas/golog/actions/workflows/main.yml"><img src="https://github.com/irfnyas/golog/actions/workflows/main.yml/badge.svg" alt="GitHub Build Badge"></a>
	<a href="https://opensource.org/licenses/apache-2-0"><img src="https://img.shields.io/badge/License-Apache_2.0-blue.svg" alt="Apache 2.0 License Badge"></a>
	<a href="https://github.com/irfnyas/golog"><img src="https://img.shields.io/badge/platform-flutter-ff69b4.svg" alt="Flutter Platform Badge"></a>
</p>

View custom logger inside app. Works on debug and release.

## Features

<img src="https://github.com/irfnyas/golog/assets/34657831/7ce67ba6-b39c-4eda-bb01-00fca865f191" alt="Screenshot 1" width="300">
<img src="https://github.com/irfnyas/golog/assets/34657831/2ef37092-f600-4568-a66b-f1553fef67cd" alt="Screenshot 2" width="300">

## Getting started

```dart
flutter pub add golog
```

## Usage

- Add ```Golog.builder()``` to your MaterialApp:
```dart
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: Golog.builder(),
    );
  }
}
```

- Send your custom log using:
```dart
Golog.add('my log title', body: '{"hello":"this body is optional"}');
```

- Tap item to see the body, tap again to copy its value to clipboard.

## Additional information

Contributions of any kind are welcome. Feel free to improve the library by creating a pull request or opening an issue.
