import 'dart:io';
import 'package:yaml/yaml.dart';

// ============================================
// Flutter Project Structure Analyzer (DevStat)
// v1.3.2 (Global Edition) - January 09, 2026
// Copyright 2025 BXAMRA
// Website: https://bxamra.github.io/
// ============================================

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
  v1.3.2 © BXAMRA 2025
  Website: https://bxamra.github.io/

  USAGE:
    dart run devstat.dart [options]

  OPTIONS:
    -p, --paths        Show all Dart file paths under lib/
    -a, --annotate     Add or update // lib/... comment headers in all Dart files
    -h, --help         Show this help information
    -u, --usage        Show usage information (same as -h)
    -v, --version      Show DevStat version info
  ''');
}

void _printVersion() {
  print('''
  DevStat v1.3.2 (Global Edition)
  Flutter Project Structure Analyzer
  Built: January 09, 2026
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

  Map<String, dynamic>? _devInfo;

  FlutterProjectAnalyzer({this.showPaths = false, this.annotate = false});

  Future<void> analyze() async {
    if (!_isFlutterProject()) {
      print(
        '❌ Please run from a Flutter app folder (must contain pubspec.yaml)',
      );
      return;
    }

    _loadDevInfo();

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
    final file = File('pubspec.yaml');
    if (!file.existsSync()) return false;

    final content = file.readAsStringSync();
    return content.contains('sdk: flutter') ||
        content.contains('flutter:') ||
        content.contains('flutter_test:');
  }

  void _loadDevInfo() {
    final file = File('pubspec.yaml');
    if (!file.existsSync()) return;

    final yaml = loadYaml(file.readAsStringSync());
    final section = yaml['flutter_devstat']?['dev_info'];
    if (section == null) return;

    _devInfo = Map<String, dynamic>.from(section);
  }

  String _buildDevBlock() {
    if (_devInfo == null) return '';

    final name = (_devInfo!['name'] ?? '').toString().trim();
    final email = (_devInfo!['email'] ?? '').toString().trim();
    final website = (_devInfo!['website'] ?? '').toString().trim();
    final project = (_devInfo!['project'] ?? '').toString().trim();
    final genCopyright = _devInfo!['generate_copyright'] == true;

    final year = DateTime.now().year;
    final lines = <String>[];

    if (name.isNotEmpty) lines.add(' * $name');
    if (email.isNotEmpty) lines.add(' * $email');
    if (website.isNotEmpty) lines.add(' * $website');

    if (genCopyright && name.isNotEmpty) {
      lines.add(' * Copyright $year $name. All rights reserved.');
    }

    if (project.isNotEmpty) {
      if (lines.isNotEmpty) lines.add(' *');
      lines.add(' * Project : $project');
    }

    if (lines.isEmpty) return '';

    return ['/*', ...lines, ' */'].join('\n');
  }

  Future<void> _scanDirectory(Directory dir, String path) async {
    final entries = dir.listSync();
    final dartFiles = <String>[];

    for (final e in entries) {
      if (e is File && e.path.endsWith('.dart')) {
        dartFiles.add(_getFileName(e.path));
        _totalFiles++;

        _allPaths.add(
          '${Directory.current.path.split(Platform.pathSeparator).last}/$path/${_getFileName(e.path)}',
        );
      } else if (e is Directory) {
        await _scanDirectory(e, '$path/${_getFileName(e.path)}');
      }
    }

    _folderFiles[path] = dartFiles;
    _folderCounts[path] = dartFiles.length;
    _totalDirectories++;
  }

  String _getFileName(String path) => path.split(Platform.pathSeparator).last;

  Future<void> _annotateFiles() async {
    print('✏️  Annotating all Dart files under lib/ ...\n');

    for (final path in _allPaths) {
      final filePath = path.split('/').skip(1).join('/');
      final file = File(filePath);
      if (!file.existsSync()) continue;

      final body = file.readAsStringSync();
      final devBlock = _buildDevBlock();

      final headerLines = <String>['// $filePath', ''];

      if (devBlock.isNotEmpty) {
        headerLines.add(devBlock);
        headerLines.add('');
      }

      final header = '${headerLines.join('\n')}\n';

      String cleaned = body
          .replaceFirst(RegExp(r'^// lib\/.*\n+'), '')
          .replaceFirst(RegExp(r'^/\*[\s\S]*?\*/\n+'), '')
          .trimLeft();

      file.writeAsStringSync('$header$cleaned\n');
      print('✅ Updated $filePath');
    }

    print('\n✨ Annotation complete! ${_allPaths.length} files processed.');
  }

  void _printHeader() {
    final now = DateTime.now();
    final project = Directory.current.path.split(Platform.pathSeparator).last;

    print('* - ' * 15 + '*');
    print('🚀 Flutter Project Structure Analyzer (DevStat)');
    print('   v1.3.2 © BXAMRA 2025');
    print('🌐 https://bxamra.github.io/');
    print('* - ' * 15 + '*');
    print('Project: $project');
    print('Timestamp: ${now.toIso8601String().replaceFirst('T', ' ')}\n');
  }

  void _printTree() {
    final project = Directory.current.path.split(Platform.pathSeparator).last;
    print('│$project/');
    print('│');
    _printDirectoryTree('lib', '', true);
  }

  void _printDirectoryTree(String dir, String prefix, bool last) {
    final files = _folderFiles[dir] ?? [];
    final dirs =
        _folderFiles.keys
            .where(
              (k) =>
                  k.startsWith('$dir/') &&
                  k.split('/').length == dir.split('/').length + 1,
            )
            .toList()
          ..sort();

    print(
      '$prefix${last ? '└──│' : '├──│'}${dir.split('/').last}/ - ${files.length} files',
    );

    final newPrefix = prefix + (last ? '   ' : '│  ');

    for (int i = 0; i < dirs.length; i++) {
      _printDirectoryTree(
        dirs[i],
        newPrefix,
        i == dirs.length - 1 && files.isEmpty,
      );
    }

    for (int i = 0; i < files.length; i++) {
      print('$newPrefix${i == files.length - 1 ? '└──' : '├──'} ${files[i]}');
    }
  }

  void _printPaths() {
    print('📄 Dart File Paths:\n');
    _allPaths.sort();
    for (final p in _allPaths) {
      print(p);
    }
    print(
      '\nTotal $_totalFiles Dart files across $_totalDirectories directories',
    );
  }

  void _printFooter() {
    print('\nTotal $_totalFiles files across $_totalDirectories directories');
  }
}
