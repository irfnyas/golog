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

  /// Add new log
  static void add(String title, {Map<String, dynamic>? body}) {
    Golog._logList.insert(0, GologModel(title: title, body: body));
    Golog._logLength.value = Golog._logList.length;
    Golog._logOpened.value = 0;
  }

  /// Get log list
  static List<GologModel> list() {
    return _logList;
  }

  /// Clear log list
  static void _clear() {
    _logOpened.value = 0;
    _logList.clear();
    _logLength.value = 0;
    _logOpened.value = -1;
  }
}

/// Golog custom model.
class GologModel {
  GologModel({
    required this.title,
    this.body,
  });

  final String title;
  final createdAt = '${DateTime.now()}'.substring(0, 19);
  final Map<String, dynamic>? body;

  Map<String, dynamic> toJson() => {
        'title': title,
        'createdAt': createdAt,
        'body': body,
      };

  @override
  toString() => jsonEncode({
        'title': title,
        'createdAt': createdAt,
        'body': body,
      });
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
      color: Colors.transparent,
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
            Theme(
              data: ThemeData(useMaterial3: true),
              child: Visibility(
                visible: isExpanded,
                child: Expanded(
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text(
                        'Log Viewer',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.grey.shade900,
                        ),
                      ),
                      actions: [
                        IconButton(
                          onPressed: () => Golog._clear(),
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.grey.shade900,
                          ),
                        )
                      ],
                    ),
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
                                ? Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.05)
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
                                        Text(
                                          e.title,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade900,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          e.createdAt,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: e.body?.isNotEmpty == true,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: Icon(
                                        logOpened == i
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                        color: Colors.grey.shade900,
                                      ),
                                    ),
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
                                          color: Colors.grey.shade900,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            onTap: () => Golog._logOpened.value =
                                logOpened == i ? -1 : i,
                            onLongPress: () {
                              Clipboard.setData(ClipboardData(text: '$e'));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Value copied to clipboard!',
                                  ),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
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
            ),
            Theme(
              data: ThemeData(useMaterial3: true),
              child: const Divider(
                height: 1,
                thickness: 1,
              ),
            ),
            Theme(
              data: ThemeData(useMaterial3: true),
              child: InkWell(
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
                            style: TextStyle(
                              color: Colors.grey.shade900,
                              fontSize: 14,
                            ),
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
            ),
          ],
        ),
      ),
    );
  }
}
