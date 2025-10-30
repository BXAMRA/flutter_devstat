import 'package:flutter_devstat/flutter_devstat.dart';
import 'package:test/test.dart';

void main() {
  test('version constant', () {
    expect(getDevStatVersion(), '1.3.1');
  });
}
