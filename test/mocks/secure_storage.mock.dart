import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';

class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

/// Secure storage backed by [values].
FlutterSecureStorage inMemorySecureStorage([Map<String, String>? values]) {
  final store = values ?? <String, String>{};
  final storage = _MockSecureStorage();
  when(() => storage.read(key: any(named: 'key'))).thenAnswer((i) async => store[i.namedArguments[#key]]);
  when(
    () => storage.write(
      key: any(named: 'key'),
      value: any(named: 'value'),
    ),
  ).thenAnswer((i) async {
    final value = i.namedArguments[#value] as String?;
    final key = i.namedArguments[#key] as String;
    value == null ? store.remove(key) : store[key] = value;
  });
  when(() => storage.delete(key: any(named: 'key'))).thenAnswer((i) async => store.remove(i.namedArguments[#key]));
  return storage;
}
