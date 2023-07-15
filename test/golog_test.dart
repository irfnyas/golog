import 'package:flutter_test/flutter_test.dart';
import 'package:golog/golog.dart';

void main() {
  test('add new log', () {
    const title = 'Log Test';
    const body = {'hello': 'world'};

    Golog.add(title, body: body);

    expect(Golog.list().length, 1);
    expect(Golog.list().first.title, title);
    expect(Golog.list().first.body, body);
  });
}
