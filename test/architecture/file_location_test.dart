// File location rules – certain file types belong to a certain layer.

import 'package:flutter_test/flutter_test.dart';

import 'utils/arch_utils.dart';

void main() {
  test('*.screen.dart files belong in presentation/', () {
    checkFilesOnlyIn(
      fileSuffix: '.screen.dart',
      allowedDirectories: ['lib/presentation'],
      because: 'screens belong in the presentation layer',
    );
  });

  test('*.controller.dart files belong in presentation/', () {
    checkFilesOnlyIn(
      fileSuffix: '.controller.dart',
      allowedDirectories: ['lib/presentation'],
      because: 'controllers belong in the presentation layer',
    );
  });

  test('*.repository.dart and *.table.dart files belong in data/', () {
    for (final suffix in ['.repository.dart', '.table.dart']) {
      checkFilesOnlyIn(
        fileSuffix: suffix,
        allowedDirectories: ['lib/data'],
        because: 'repositories and tables belong in the data layer',
      );
    }
  });

  test('*.service.dart files belong in domain/', () {
    checkFilesOnlyIn(
      fileSuffix: '.service.dart',
      allowedDirectories: ['lib/domain'],
      because: 'services belong in the domain layer',
    );
  });
}
