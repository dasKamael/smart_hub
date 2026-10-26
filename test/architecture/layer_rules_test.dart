// Layer rules – presentation → domain → data, never the other way round.
// See docs/architecture.md, "Dependency rules" 1–3 and 7.

import 'package:flutter_test/flutter_test.dart';

import 'utils/arch_utils.dart';

void main() {
  const domainNotPresentation = 'domain layer must not depend on presentation layer';
  test(domainNotPresentation, () {
    checkNoImportFrom('lib/domain', '$appPackage/presentation/', because: domainNotPresentation);
  });

  const dataNotPresentation = 'data layer must not depend on presentation layer';
  test(dataNotPresentation, () {
    checkNoImportFrom('lib/data', '$appPackage/presentation/', because: dataNotPresentation);
  });

  const presentationNotData = 'presentation layer must access data through the domain layer';
  test(presentationNotData, () {
    checkNoImportFrom('lib/presentation', '$appPackage/data/', because: presentationNotData);
  });

  const commonNotPresentation = 'common layer must be independent of presentation';
  test(commonNotPresentation, () {
    checkNoImportFrom('lib/common', '$appPackage/presentation/', because: commonNotPresentation);
  });

  const commonNotDomain = 'common layer must be independent of domain';
  test(commonNotDomain, () {
    checkNoImportFrom('lib/common', '$appPackage/domain/', because: commonNotDomain);
  });

  const commonNotData = 'common layer must be independent of data';
  test(commonNotData, () {
    checkNoImportFrom('lib/common', '$appPackage/data/', because: commonNotData);
  });

  const dataOnlyDomainModels = 'data layer may only import domain models (domain/<context>/model/)';
  test(dataOnlyDomainModels, () {
    final domainModel = RegExp('^$appPackage/domain/\\w+/model/');
    checkImports(
      'lib/data',
      isForbidden: (file, uri) => uri.startsWith('$appPackage/domain/') && !domainModel.hasMatch(uri),
      because: dataOnlyDomainModels,
    );
  });
}
