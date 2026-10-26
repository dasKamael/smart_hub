// Naming conventions – the file suffix states what the file contains.
// See docs/architecture.md, "File naming".

import 'package:flutter_test/flutter_test.dart';

import 'utils/arch_utils.dart';

void main() {
  const suffixToClass = {
    '.repository.dart': 'Repository',
    '.controller.dart': 'Controller',
    '.state.dart': 'State',
    '.screen.dart': 'Screen',
    '.util.dart': 'Util',
    '.color_palette.dart': 'ColorPalette',
  };

  for (final MapEntry(key: fileSuffix, value: classSuffix) in suffixToClass.entries) {
    test('*$fileSuffix files declare a ...$classSuffix class', () {
      checkNaming(fileSuffix: fileSuffix, classSuffix: classSuffix);
    });
  }

  test('*.extension.dart files declare a named extension', checkExtensionNaming);

  test('*.enum.dart files declare an enum', checkEnumNaming);
}
