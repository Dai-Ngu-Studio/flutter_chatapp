import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  Future<String> uploadFile({
    required String fileName,
    required File file,
  }) async {
    final reference = FirebaseStorage.instance.ref(fileName);
    await reference.putFile(file);
    final uri = await reference.getDownloadURL();

    return uri;
  }
}
