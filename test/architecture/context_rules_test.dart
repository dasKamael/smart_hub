// Bounded context rules – contexts stay separated inside the layers.
// See docs/architecture.md, "Dependency rules" 4–6.

import 'package:flutter_test/flutter_test.dart';

import 'utils/arch_utils.dart';

void main() {
  const dataOnlyFromOwnDomain = 'data/<context> is only used by domain/<context> (data/connection is shared)';
  test(dataOnlyFromOwnDomain, () {
    final dataImport = RegExp('^$appPackage/data/(\\w+)/');
    checkImports(
      'lib',
      isForbidden: (file, uri) {
        final context = dataImport.firstMatch(uri)?.group(1);
        if (context == null) return false;
        final path = file.path;
        if (path.startsWith('lib/data/$context/') || path.startsWith('lib/domain/$context/')) return false;
        if (path.startsWith('lib/data/database/')) return false;
        if (context == 'connection' && path.startsWith('lib/data/')) return false;
        if (context == 'database' && path.startsWith('lib/data/')) return false;
        return true;
      },
      because: dataOnlyFromOwnDomain,
    );
  });

  const haClientOnlyInData = 'package:ha_client is only used in the data layer';
  test(haClientOnlyInData, () {
    for (final layer in ['lib/common', 'lib/domain', 'lib/presentation']) {
      checkNoImportFrom(layer, 'package:ha_client/', because: haClientOnlyInData);
    }
  });

  const floorplanIndependent = 'domain/floorplan does not depend on other device contexts';
  test(floorplanIndependent, () {
    final otherDeviceContexts = RegExp('^$appPackage/domain/(lights|plants|music)/');
    checkImports(
      'lib/domain/floorplan',
      isForbidden: (file, uri) => otherDeviceContexts.hasMatch(uri),
      because: floorplanIndependent,
    );
  });
}
