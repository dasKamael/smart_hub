import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:smart_hub/data/plants/plant_photo.repository.dart';

void main() {
  group('PlantPhotoRepository', () {
    late Directory documents;
    late PlantPhotoRepository repository;

    setUp(() async {
      documents = await Directory.systemTemp.createTemp('plant_photos_test');
      addTearDown(() => documents.delete(recursive: true));
      repository = PlantPhotoRepository(directory: () async => documents);
    });

    Future<File> pickedPhoto(String name) async {
      final file = File(p.join(documents.path, name));
      await file.writeAsBytes([1, 2, 3]);
      return file;
    }

    test('Given a picked photo, when storing it, then a copy lands in the photo folder', () async {
      final picked = await pickedPhoto('IMG_0001.jpeg');

      final stored = await repository.store('plant-fern', picked.path);

      expect(p.dirname(stored), p.join(documents.path, PlantPhotoRepository.folderName));
      expect(p.basename(stored), startsWith('plant-fern-'));
      expect(p.extension(stored), '.jpeg');
      expect(await File(stored).readAsBytes(), [1, 2, 3]);
      expect(await picked.exists(), isTrue, reason: 'the original is left alone');
    });

    test('Given a stored photo, when deleting it twice, then it is gone and the second call is fine', () async {
      final stored = await repository.store('plant-fern', (await pickedPhoto('a.png')).path);

      await repository.delete(stored);
      await repository.delete(stored);

      expect(await File(stored).exists(), isFalse);
    });
  });
}
