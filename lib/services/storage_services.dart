import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class StorageServices {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageFileToStorage(
      String fileLocation, File file, String pid) async {
    Reference ref = storage
        .ref()
        .child(fileLocation)
        .child(_auth.currentUser!.uid); //// Change too Unique user/server ID

    // File Organization
    if (fileLocation == 'user_post_images') {
      String pid = const Uuid().v1();
      ref = ref.child(pid);
    } else if (fileLocation == 'user_media') {
      ref = ref.child(pid);
    }

    //
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snap = await uploadTask;

    String imageURL = await snap.ref.getDownloadURL();

    return imageURL;
  }

  Future<String> uploadImageBytesToStorage(
      String fileLocation, Uint8List file, String pid) async {
    Reference ref = storage
        .ref()
        .child(fileLocation)
        .child(_auth.currentUser!.uid); //// Change too Unique user/server ID

    // File Organization
    if (fileLocation == 'user_post_images') {
      String uUid = const Uuid().v1();
      ref = ref.child(uUid);
    } else if (fileLocation == 'user_media') {
      ref = ref.child(pid);
    }

    //
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask;

    String imageURL = await snap.ref.getDownloadURL();

    return imageURL;
  }
}
