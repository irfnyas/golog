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

  /// Golog material app builder
  static Widget Function(BuildContext, Widget?)? builder() {
    return (context, child) => _GologWidget(context: context, child: child);
  }

  /// Add new log
  static void add(String title, {String? body}) {
    Golog._logList.insert(0, GologModel(title: title, body: body));
    Golog._logLength.value = Golog._logList.length;
    Golog._logOpened.value = 0;
  }

  /// Get log list
  static List<GologModel> list() {
    return _logList;
  }
}

// Golog custom model
class GologModel {
  GologModel({
    required this.title,
    this.body,
  });

  final String title;
  final createdAt = '${DateTime.now()}';
  final String? body;

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

class _GologWidget extends StatelessWidget {
  const _GologWidget({
    required this.context,
    this.child,
  });

  final BuildContext context;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ValueListenableBuilder(
        valueListenable: Golog._isExpanded,
        builder: (context, bool isExpanded, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: !isExpanded
                  ? (child ?? const SizedBox.shrink())
                  : SafeArea(
                      child: ValueListenableBuilder(
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
                                      .withOpacity(0.1)
                                  : null,
                              title: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
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
                                          ? Icons.copy
                                          : Icons.keyboard_arrow_down,
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: Visibility(
                                visible: e.body != null && logOpened == i,
                                child: Text(
                                  e.body ?? '',
                                  style: const TextStyle(
                                    height: 1.5,
                                    fontFamily: 'FiraCode',
                                    package: 'golog',
                                  ),
                                ),
                              ),
                              onTap: () => logOpened == i
                                  ? Clipboard.setData(ClipboardData(text: '$e'))
                                  : Golog._logOpened.value = i,
                            );
                          },
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
