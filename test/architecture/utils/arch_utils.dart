import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const appPackage = 'package:smart_hub';

final _generatedSuffixes = ['.g.dart', '.freezed.dart'];
final _importRegExp = RegExp(r'''^\s*(?:import|export)\s+['"]([^'"]+)['"]''', multiLine: true);

/// All hand-written Dart files below [directory], with `/` separated relative paths.
List<File> dartFilesIn(String directory) {
  final dir = Directory(directory);
  if (!dir.existsSync()) return [];
  return dir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart') && !_generatedSuffixes.any(f.path.endsWith))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));
}

/// Import and export URIs of [file].
List<String> importsOf(File file) {
  return _importRegExp.allMatches(file.readAsStringSync()).map((m) => m.group(1)!).toList();
}

/// Names of the bounded contexts that exist in [layerDirectory] (e.g. `lib/data`).
List<String> contextsIn(String layerDirectory) {
  final dir = Directory(layerDirectory);
  if (!dir.existsSync()) return [];
  return dir.listSync().whereType<Directory>().map((d) => d.uri.pathSegments.where((s) => s.isNotEmpty).last).toList()
    ..sort();
}

/// Fails if a file in [directory] imports a URI starting with [forbiddenPrefix].
void checkNoImportFrom(
  String directory,
  String forbiddenPrefix, {
  required String because,
  List<String> knownViolations = const [],
}) {
  checkImports(
    directory,
    isForbidden: (file, uri) => uri.startsWith(forbiddenPrefix),
    because: because,
    knownViolations: knownViolations,
  );
}

/// Fails if [isForbidden] returns true for any import of any file in [directory].
void checkImports(
  String directory, {
  required bool Function(File file, String uri) isForbidden,
  required String because,
  List<String> knownViolations = const [],
}) {
  final violations = <String>[];
  for (final file in dartFilesIn(directory)) {
    if (_isKnown(file, knownViolations)) continue;
    for (final uri in importsOf(file)) {
      if (isForbidden(file, uri)) violations.add('${file.path} → $uri');
    }
  }
  _failIfAny('[ArchTest] $because', violations);
}

/// Fails if a `*<fileSuffix>` file below `lib/` does not declare a class ending with [classSuffix].
void checkNaming({required String fileSuffix, required String classSuffix, List<String> knownViolations = const []}) {
  final classRegExp = RegExp('(class|enum|mixin)\\s+\\w*$classSuffix\\b');
  final violations = [
    for (final file in dartFilesIn('lib'))
      if (file.path.endsWith(fileSuffix) &&
          !_isKnown(file, knownViolations) &&
          !classRegExp.hasMatch(file.readAsStringSync()))
        file.path,
  ];
  _failIfAny('[ArchTest] *$fileSuffix must declare a class ending with "$classSuffix"', violations);
}

/// Fails if a `*.extension.dart` file below `lib/` does not declare a named extension.
void checkExtensionNaming() {
  final extensionRegExp = RegExp(r'extension\s+\w+Extension\s+on\s');
  final violations = [
    for (final file in dartFilesIn('lib'))
      if (file.path.endsWith('.extension.dart') && !extensionRegExp.hasMatch(file.readAsStringSync())) file.path,
  ];
  _failIfAny('[ArchTest] *.extension.dart must declare a named "...Extension"', violations);
}

/// Fails if a `*.enum.dart` file below `lib/` does not declare an enum.
void checkEnumNaming() {
  final enumRegExp = RegExp(r'\benum\s+\w+');
  final violations = [
    for (final file in dartFilesIn('lib'))
      if (file.path.endsWith('.enum.dart') && !enumRegExp.hasMatch(file.readAsStringSync())) file.path,
  ];
  _failIfAny('[ArchTest] *.enum.dart must declare an enum', violations);
}

/// Fails if a `*<fileSuffix>` file lives outside of [allowedDirectories].
void checkFilesOnlyIn({required String fileSuffix, required List<String> allowedDirectories, required String because}) {
  final violations = [
    for (final file in dartFilesIn('lib'))
      if (file.path.endsWith(fileSuffix) && !allowedDirectories.any((d) => file.path.startsWith('$d/'))) file.path,
  ];
  _failIfAny('[ArchTest] $because', violations);
}

/// Fails if [pattern] matches in a file of [directory] (comments included).
void checkNoPattern(
  RegExp pattern, {
  required String inDirectory,
  required String because,
  List<String> knownViolations = const [],
}) {
  final violations = <String>[];
  for (final file in dartFilesIn(inDirectory)) {
    if (_isKnown(file, knownViolations)) continue;
    final lines = file.readAsLinesSync();
    for (final (index, line) in lines.indexed) {
      if (pattern.hasMatch(line)) violations.add('${file.path}:${index + 1}  ${line.trim()}');
    }
  }
  _failIfAny('[ArchTest] $because', violations);
}

/// Fails if a `*_test.dart` file exists in [directory].
void checkNoTestFilesIn(String directory) {
  final violations = [
    for (final file in dartFilesIn(directory))
      if (file.path.endsWith('_test.dart')) file.path,
  ];
  _failIfAny('[ArchTest] test files belong in test/', violations);
}

bool _isKnown(File file, List<String> knownViolations) {
  return knownViolations.any((v) => file.path == v || file.path.endsWith('/$v'));
}

void _failIfAny(String message, List<String> violations) {
  if (violations.isEmpty) return;
  fail('$message\n${violations.map((v) => '  - $v').join('\n')}');
}
