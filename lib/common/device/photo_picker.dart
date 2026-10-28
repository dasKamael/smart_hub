import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'photo_picker.g.dart';

enum PhotoSource { camera, gallery }

/// Takes or picks a photo and returns its temporary path; `null` when cancelled. The hub takes photos with its own
/// camera view (`showCameraCapture`) – the system camera app cannot be left in the kiosk.
class PhotoPicker {
  PhotoPicker({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<String?> pick(PhotoSource source) async {
    final file = await _picker.pickImage(
      source: switch (source) {
        PhotoSource.camera => ImageSource.camera,
        PhotoSource.gallery => ImageSource.gallery,
      },
      // Plenty for a 100 px tile on a tablet, small enough for the database folder.
      maxWidth: 1200,
      imageQuality: 85,
    );
    return file?.path;
  }
}

@Riverpod(keepAlive: true)
PhotoPicker photoPicker(Ref ref) => PhotoPicker();
