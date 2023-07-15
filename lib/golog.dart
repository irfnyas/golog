library golog;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Golog Main Class
class Golog {
  static final _instance = Golog._();
  factory Golog() => _instance;
  Golog._();

  static final _logList = <GologModel>[];
  static final _logLength = ValueNotifier(0);
  static final _logOpened = ValueNotifier(0);
  static final _isExpanded = ValueNotifier(false);

  /// Golog material app builder.
  ///
  /// ```
  /// // Example
  /// return MaterialApp(
  ///   builder: Golog.builder(),
  /// )
  /// ```
  ///
  static Widget Function(BuildContext, Widget?)? builder() {
    return (context, child) => GologWidget(context: context, child: child);
  }

  /// Add new log.
  static void add(String title, {Map<String, dynamic>? body}) {
    Golog._logList.insert(0, GologModel(title: title, body: body));
    Golog._logLength.value = Golog._logList.length;
    Golog._logOpened.value = 0;
  }

  /// Get log list
  static List<GologModel> list() {
    return _logList;
  }
}

// Golog custom model.
class GologModel {
  GologModel({
    required this.title,
    this.body,
  });

  final String title;
  final createdAt = '${DateTime.now()}';
  final Map<String, dynamic>? body;

  Map<String, dynamic> toJson() => {
        'title': title,
        'createdAt': createdAt,
        'body': body,
      };

  @override
  toString() {
    return jsonEncode({
      'title': title,
      'createdAt': createdAt,
      'body': body,
    });
  }
}

/// Alternative if you are not using Golog.builder().
/// Wrap your child widget inside material app using GologWidget().
///
/// ```
/// // Example
/// return MaterialApp(
///   builder: (BuildContext context, Widget? child) {
///     return GologWidget(
///       context: context,
///       child: MediaQuery(
///         data: MediaQuery.of(context),
///         child: child ?? const SizedBox(),
///       ),
///     );
///   }
/// )
/// ```
///
class GologWidget extends StatelessWidget {
  const GologWidget({
    Key? key,
    required this.context,
    this.child,
  }) : super(key: key);

  final BuildContext context;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ValueListenableBuilder(
        valueListenable: Golog._isExpanded,
        builder: (_, bool isExpanded, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              flex: isExpanded ? 0 : 1,
              child: SizedBox(
                height: isExpanded ? 0 : null,
                child: child ?? const SizedBox.shrink(),
              ),
            ),
            Visibility(
              visible: isExpanded,
              child: Expanded(
                child: Scaffold(
                  appBar: AppBar(title: const Text('Log Viewer')),
                  backgroundColor: Theme.of(context).cardColor,
                  body: ValueListenableBuilder(
                    valueListenable: Golog._logOpened,
                    builder: (_, int logOpened, __) => ListView.separated(
                      itemCount: Golog._logLength.value,
                      physics: const BouncingScrollPhysics(),
                      separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        thickness: 1,
                      ),
                      itemBuilder: (_, i) {
                        final e = Golog._logList[i];
                        return ListTile(
                          tileColor: logOpened == i
                              ? Theme.of(context).primaryColor.withOpacity(0.05)
                              : null,
                          minVerticalPadding: 0,
                          title: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(e.title),
                                      const SizedBox(height: 4),
                                      Text(
                                        e.createdAt,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall
                                                  ?.color
                                                  ?.withOpacity(0.5),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Icon(
                                  logOpened == i
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                ),
                              ],
                            ),
                          ),
                          subtitle: Visibility(
                            visible: e.body != null && logOpened == i,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: e.body?.length ?? 0,
                                itemBuilder: (_, i) {
                                  final f = e.body?.entries.elementAt(i);
                                  return RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '${f?.key}:\n',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '${f?.value}\n',
                                        ),
                                      ],
                                      style: TextStyle(
                                        height: 1.5,
                                        fontFamily: 'FiraCode',
                                        package: 'golog',
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          onTap: () =>
                              Golog._logOpened.value = logOpened == i ? -1 : i,
                          onLongPress: () {
                            Clipboard.setData(ClipboardData(text: '$e'));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Value copied to clipboard!',
                                ),
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
            ),
            InkWell(
              onTap: () => Golog._isExpanded.value = !Golog._isExpanded.value,
              child: Container(
                height: kTextTabBarHeight,
                color: Theme.of(context).cardColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: Golog._logLength,
                        builder: (_, int i, __) => Text(
                          i == 0 ? 'Log View' : Golog._logList.first.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Switch(
                      value: isExpanded,
                      onChanged: (v) => Golog._isExpanded.value = v,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
