import 'package:mocktail/mocktail.dart';
import 'package:smart_hub/common/device/kiosk.dart';

class MockKiosk extends Mock implements Kiosk {}

/// [MockKiosk] that reports [isHomeApp] and accepts every change.
MockKiosk kioskReporting({bool isHomeApp = false}) {
  final kiosk = MockKiosk();
  when(kiosk.isHomeApp).thenAnswer((_) async => isHomeApp);
  when(() => kiosk.setHomeApp(enabled: any(named: 'enabled'))).thenAnswer((_) async {});
  return kiosk;
}
