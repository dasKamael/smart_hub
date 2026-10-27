import 'dart:io';

import 'package:clock/clock.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'plant_photo.repository.g.dart';

/// Keeps plant photos in the app's documents directory, independent of where they were picked from.
class PlantPhotoRepository {
  PlantPhotoRepository({required this.directory});

  /// Resolves the directory the photos live in.
  final Future<Directory> Function() directory;

  static const folderName = 'plant_photos';

  /// Copies the photo at [sourcePath] for [plantId] and returns its new path. Every copy gets a new name, so image
  /// caches never show an old photo.
  Future<String> store(String plantId, String sourcePath) async {
    final folder = Directory(p.join((await directory()).path, folderName));
    await folder.create(recursive: true);
    final extension = p.extension(sourcePath).isEmpty ? '.jpg' : p.extension(sourcePath);
    final target = p.join(folder.path, '$plantId-${clock.now().millisecondsSinceEpoch}$extension');
    await File(sourcePath).copy(target);
    return target;
  }

  /// Deletes a stored photo; missing files are fine.
  Future<void> delete(String path) async {
    final file = File(path);
    if (await file.exists()) await file.delete();
  }
}

/// Providers
@Riverpod(keepAlive: true)
PlantPhotoRepository plantPhotoRepository(Ref ref) => PlantPhotoRepository(directory: getApplicationDocumentsDirectory);
