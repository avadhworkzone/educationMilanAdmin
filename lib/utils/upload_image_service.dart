import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class UploadImageService {
  static Future<void> uploadImg(File image) async {
    print('IMG :==>${image.path}');
    FirebaseStorage storage = FirebaseStorage.instance;
    final reference = storage.ref().child("promotion/");
    final uploadTask = reference.putFile(image);
    final taskSnapshot = await uploadTask.whenComplete(() => null);
    String url = await taskSnapshot.ref.getDownloadURL();
    print('URL ===>$url');
  }
}
