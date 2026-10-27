// Code quality – patterns that must not appear in production code.

import 'package:flutter_test/flutter_test.dart';

import 'utils/arch_utils.dart';

void main() {
  test('no print() calls in production code', () {
    checkNoPattern(RegExp(r'(?<![.\w])print\('), inDirectory: 'lib', because: 'use the logger instead');
  });

  test('no debugPrint() calls in production code', () {
    checkNoPattern(
      RegExp(r'debugPrint\('),
      inDirectory: 'lib',
      because: 'use the logger instead',
      // The logger itself writes to the console.
      knownViolations: ['lib/common/logging/logging.setup.dart'],
    );
  });

  test('no relative imports in lib/', () {
    checkNoPattern(
      RegExp(r'''^(import|export) '(?!dart:|package:)'''),
      inDirectory: 'lib',
      because: 'use package imports for consistency and refactor safety',
    );
  });

  test('no DateTime.now() in lib/', () {
    checkNoPattern(RegExp(r'DateTime\.now\(\)'), inDirectory: 'lib', because: 'use clock.now() from package:clock');
  });

  test('no brand names outside of the data layer', () {
    for (final layer in ['lib/common', 'lib/domain', 'lib/presentation']) {
      checkNoPattern(
        RegExp(r'\b(Hue|Govee|Sonos|Philips)\b'),
        inDirectory: layer,
        because: 'the app knows device kinds and capabilities, not brands',
      );
    }
  });

  test('no Material icons', () {
    checkNoPattern(
      RegExp(r'\bIcons\.'),
      inDirectory: 'lib',
      because: 'the hub draws its own icons (HubGlyph), no system icon set',
    );
  });

  test('no test files inside lib/', () {
    checkNoTestFilesIn('lib');
  });
}
