import 'dart:io';

bool get gemmaExists {
  return File(
          "/storage/emulated/0/Android/data/com.example.gadc/files/data/user/0/com.example.gadc/files/model.bin")
      .existsSync();
}
