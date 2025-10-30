import 'dart:io';

// ============================================================
// Flutter Project Structure Analyzer (DevStat)
// v1.3 (Global Edition) - October 30, 2025
// Copyright 2025 BXAMRA
// Website: https://bxamra.github.io/
// ============================================================

void main(List<String> args) async {
  final flags = args.toSet();

  if (flags.contains('-h') ||
      flags.contains('--help') ||
      flags.contains('-u') ||
      flags.contains('--usage')) {
    _printUsage();
    return;
  }

  if (flags.contains('-v') || flags.contains('--version')) {
    _printVersion();
    return;
  }

  final showPaths = flags.contains('-p') || flags.contains('--paths');
  final annotate = flags.contains('-a') || flags.contains('--annotate');

  final analyzer = FlutterProjectAnalyzer(
    showPaths: showPaths,
    annotate: annotate,
  );

  await analyzer.analyze();
}

void _printUsage() {
  print('''

  Flutter Project Structure Analyzer (DevStat)
  v1.3 © BXAMRA 2025
  Website: https://bxamra.github.io/

  USAGE:
    dart run devstat.dart [options]

  OPTIONS:
    -p, --paths        Show all Dart file paths under lib/
    -a, --annotate     Add or update // lib/... comment headers in all Dart files
    -h, --help         Show this help information
    -u, --usage        Show usage information (same as -h)
    -v, --version      Show DevStat version info

  EXAMPLES:
    dart run devstat.dart            → Display project structure tree
    dart run devstat.dart -p         → List all Dart file paths
    dart run devstat.dart -a         → Annotate all Dart files with path headers
    dart run devstat.dart -a -p      → Annotate & list paths
    dart run devstat.dart -v         → Show version
  ''');
}

void _printVersion() {
  print('''
  DevStat v1.3 (Global Edition)
  Flutter Project Structure Analyzer
  Built: October 30, 2025
  Author: BXAMRA
  Website: https://bxamra.github.io/
  ''');
}

class FlutterProjectAnalyzer {
  final Map<String, List<String>> _folderFiles = {};
  final Map<String, int> _folderCounts = {};
  final List<String> _allPaths = [];

  int _totalFiles = 0;
  int _totalDirectories = 0;
  final bool showPaths;
  final bool annotate;

  FlutterProjectAnalyzer({this.showPaths = false, this.annotate = false});

  Future<void> analyze() async {
    if (!_isFlutterProject()) {
      print(
        '❌ Please run from a Flutter app folder (must contain pubspec.yaml)',
      );
      return;
    }

    final baseDir = Directory('lib');

    if (!baseDir.existsSync()) {
      print('❌ lib directory does not exist');
      return;
    }

    _printHeader();

    await _scanDirectory(baseDir, 'lib');

    if (annotate) {
      await _annotateFiles();
      return;
    }

    if (showPaths) {
      _printPaths();
    } else {
      _printTree();
      _printFooter();
    }
  }

  bool _isFlutterProject() {
    final pubspecFile = File('pubspec.yaml');
    if (!pubspecFile.existsSync()) return false;

    try {
      final content = pubspecFile.readAsStringSync();
      return content.contains('flutter:') ||
          content.contains('flutter_test:') ||
          content.contains('sdk: flutter');
    } catch (_) {
      return false;
    }
  }

  void _printHeader() {
    final now = DateTime.now();
    final timestamp =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    final projectName = Directory.current.path
        .split(Platform.pathSeparator)
        .last;

    print('* - ' * 15 + '*');
    print('🚀 Flutter Project Structure Analyzer (DevStat)');
    print('   v1.3 © BXAMRA 2025');
    print('🌐 https://bxamra.github.io/');
    print('* - ' * 15 + '*');
    print('Project: $projectName');
    print('Timestamp: $timestamp\n');
  }

  Future<void> _scanDirectory(Directory dir, String path) async {
    final files = dir.listSync();
    final dartFiles = <String>[];
    final subDirectories = <Directory>[];

    for (final file in files) {
      if (file is File && file.path.endsWith('.dart')) {
        dartFiles.add(_getFileName(file.path));
        _totalFiles++;

        final fullPath =
            '${Directory.current.path.split(Platform.pathSeparator).last}/$path/${_getFileName(file.path)}';
        _allPaths.add(fullPath);
      } else if (file is Directory) {
        subDirectories.add(file);
      }
    }

    _folderFiles[path] = dartFiles;
    _folderCounts[path] = dartFiles.length;
    _totalDirectories++;

    for (final subDir in subDirectories) {
      final subPath = '$path/${_getFileName(subDir.path)}';
      await _scanDirectory(subDir, subPath);
    }
  }

  String _getFileName(String path) => path.split(Platform.pathSeparator).last;

  Future<void> _annotateFiles() async {
    print('✏️  Annotating all Dart files under lib/ ...\n');
    for (final path in _allPaths) {
      final filePath = path.split('/').skip(1).join('/'); // remove project/
      final file = File(filePath);

      if (!file.existsSync()) continue;

      final lines = file.readAsLinesSync();
      final headerComment = '// $filePath';

      if (lines.isEmpty) {
        file.writeAsStringSync('$headerComment\n');
        print('🆕 Added $filePath');
        continue;
      }

      final firstLine = lines.first.trim();
      if (firstLine.startsWith('// lib/')) {
        lines[0] = headerComment;
      } else {
        lines.insert(0, headerComment);
      }

      file.writeAsStringSync(lines.join('\n'));
      print('✅ Updated $filePath');
    }

    print('\n✨ Annotation complete! ${_allPaths.length} files processed.');
  }

  void _printTree() {
    final projectName = Directory.current.path
        .split(Platform.pathSeparator)
        .last;
    print('│$projectName/');
    print('│');
    _printDirectoryTree('lib', '', true);
  }

  void _printDirectoryTree(String dirPath, String prefix, bool isLast) {
    final files = _folderFiles[dirPath] ?? [];
    final fileCount = _folderCounts[dirPath] ?? 0;
    final dirName = dirPath.split('/').last;

    final dirBranch = isLast ? '└──│' : '├──│';
    print('$prefix$dirBranch$dirName/ - $fileCount files');

    final subDirs =
        _folderFiles.keys
            .where((key) => key.startsWith('$dirPath/') && key != dirPath)
            .where(
              (key) => key.split('/').length == dirPath.split('/').length + 1,
            )
            .toList()
          ..sort();

    final directories = subDirs.map((dir) => '${dir.split('/').last}/').toList()
      ..sort();
    final sortedFiles = List<String>.from(files)..sort();

    final newPrefix = prefix + (isLast ? '   ' : '│  ');

    if (directories.isNotEmpty) print('$newPrefix│');

    for (int i = 0; i < directories.length; i++) {
      final dirName = directories[i].substring(0, directories[i].length - 1);
      final fullSubDirPath = '$dirPath/$dirName';
      final isLastDir = i == directories.length - 1 && sortedFiles.isEmpty;

      _printDirectoryTree(fullSubDirPath, newPrefix, isLastDir);

      if (i < directories.length - 1) print('$newPrefix│');
    }

    if (directories.isNotEmpty && sortedFiles.isNotEmpty) print('$newPrefix│');

    for (int i = 0; i < sortedFiles.length; i++) {
      final file = sortedFiles[i];
      final isLastItem = i == sortedFiles.length - 1;
      final fileBranch = isLastItem ? '└──' : '├──';
      print('$newPrefix$fileBranch $file');
    }
  }

  void _printPaths() {
    print('📄 Dart File Paths:\n');
    _allPaths.sort();
    for (final path in _allPaths) {
      print(path);
    }
    print(
      '\nTotal $_totalFiles Dart files found across $_totalDirectories directories',
    );
  }

  void _printFooter() {
    print('');
    print('Total $_totalFiles files across $_totalDirectories directories');
  }
}
