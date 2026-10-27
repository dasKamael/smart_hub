import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/apps/app_choice.util.dart';

import '../../mocks/apps.mock.dart';

void main() {
  group('AppChoiceUtil', () {
    final apps = [
      testApp('app.films', 'Films', isVideo: true),
      testApp('app.mail', 'Mail'),
      testApp('app.series', 'Series', isVideo: true),
    ];

    test('Given nothing chosen, when picking what to show, then it is the video apps', () {
      expect(AppChoiceUtil.shown(apps, const []).map((app) => app.label), ['Films', 'Series']);
    });

    test('Given chosen apps and one removed, when picking what to show, then it is the chosen ones in order', () {
      expect(AppChoiceUtil.shown(apps, const ['app.mail', 'app.gone', 'app.films']).map((app) => app.label), [
        'Mail',
        'Films',
      ]);
    });
  });
}
