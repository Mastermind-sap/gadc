import 'dart:io';

bool get gemmaExists {
  return File(
          "/storage/emulated/0/Android/data/com.aura3dinbetween.aura/files/data/user/0/com.aura3dinbetween.aura/files/model.bin")
      .existsSync();
}
