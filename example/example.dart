// example/example.dart

import '../bin/flutter_devstat.dart';

void main() async {
  print('Running Flutter DevStat Example...');

  // Example: Analyze the current project
  // Make sure you run this from a Flutter project directory.
  final analyzer = FlutterProjectAnalyzer(showPaths: true, annotate: false);

  await analyzer.analyze();

  print('\n✅ Example run complete.');
}
