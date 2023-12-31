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

View custom logger inside app. Works on debug and release mode.

## Features

<img src="https://github.com/irfnyas/golog/assets/34657831/7ce67ba6-b39c-4eda-bb01-00fca865f191" alt="Screenshot 1" width="300">
<img src="https://github.com/irfnyas/golog/assets/34657831/c49446e5-e3a3-408a-96ae-325bb689ca43" alt="Screenshot 2" width="300">

## Getting started

```dart
flutter pub add golog
```

## Usage

- Add ```Golog.builder()``` to your MaterialApp.builder:

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

- Alternatively, if you are not using ```Golog.builder()``` you can wrap your child widget inside MaterialApp.builder using ```GologWidget()```:

```dart
return MaterialApp(
  builder: (BuildContext context, Widget? child) {
    return GologWidget(
      context: context,
      child: MediaQuery(
        data: MediaQuery.of(context),
        child: child ?? const SizedBox(),
      ),
    );
  }
)
```

- Send your custom log:

```dart
Golog.add('Log Title', body: {'hello': 'world', 'foo': 123});
```

- Get log list:

```dart
Golog.list();
```

- Tap item to see the body, tap again to copy its value to clipboard.

## Additional information

Contributions of any kind are welcome. Feel free to improve the library by creating a pull request or opening an issue.
