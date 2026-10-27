import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/connection/model/connection_status.enum.dart';

void main() {
  test('Given every status, when asking isOnline, then only online is online', () {
    expect(ConnectionStatus.values.where((s) => s.isOnline), [ConnectionStatus.online]);
  });
}
