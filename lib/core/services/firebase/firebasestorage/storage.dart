import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:whalechat/core/services/firebase/firebasefirestore/userservice.dart';

class StorageService {
  storage.Reference _storage = storage.FirebaseStorage.instance.ref();

  Future<void> addImage({File image, String id}) async {
    await _storage.child("profile/$id.img").putFile(image);
    var url = await _storage.child("profile/$id.img").getDownloadURL();
    await FirebaseUserService().profileUpdate(id: id, url: url);
  }
}
