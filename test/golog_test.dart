import 'package:flutter_test/flutter_test.dart';
import 'package:golog/golog.dart';

void main() {
  test('add new log', () {
    const title = 'Log Test';
    const body = '{"hello": "world"}';

    Golog.add(title, body: body);

    expect(Golog.logLength.value, 1);
    expect(Golog.logList.first.title, title);
    expect(Golog.logList.first.body, body);
  });
}
