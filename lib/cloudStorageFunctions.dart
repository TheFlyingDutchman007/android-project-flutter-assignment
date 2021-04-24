import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

import 'package:hello_me/authRepo.dart';

class StorageService{
  final storage;

  StorageService.instance() : storage = firebase_storage.FirebaseStorage.instance;

  Future<String> downloadURLofProfile(User user) async {
    final uid = AuthRepository.instance().user!.uid;
    String downloadURL = await storage
        .ref('uploads/$uid/file-to-upload.png')
        .getDownloadURL();
    // Within your widgets:
    // Image.network(downloadURL);
    return downloadURL;
  }


  Future<void> uploadFile(File file) async {
    try {
      final uid = AuthRepository.instance().user!.uid;
      await storage .ref('uploads/$uid/file-to-upload.png').putFile(file);
    } on firebase_storage.FirebaseException catch (e) {
      print("not fun");
      print(e);
      // e.g, e.code == 'canceled'
    }
  }
}
