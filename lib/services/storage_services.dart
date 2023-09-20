import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class StorageServices {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Upload Image File
  Future<String> uploadImageFileToStorage(
      String fileLocation, File file, String pid) async {
    switch (fileLocation) {
      case 'user_profile_images':
        Reference ref =
            storage.ref().child(fileLocation).child(_auth.currentUser!.uid);
        ref = ref.child('profile_image');
        UploadTask uploadTask = ref.putFile(file);
        TaskSnapshot snap = await uploadTask;
        String imageURL = await snap.ref.getDownloadURL();
        return imageURL;
      case 'user_banner_images':
        Reference ref =
            storage.ref().child(fileLocation).child(_auth.currentUser!.uid);
        ref = ref.child('banner_image');
        UploadTask uploadTask = ref.putFile(file);
        TaskSnapshot snap = await uploadTask;
        String imageURL = await snap.ref.getDownloadURL();
        return imageURL;
      case 'user_post_images':
        Reference ref =
            storage.ref().child(fileLocation).child(_auth.currentUser!.uid);
        String pid = const Uuid().v1();
        ref = ref.child(pid);
        UploadTask uploadTask = ref.putFile(file);
        TaskSnapshot snap = await uploadTask;
        String imageURL = await snap.ref.getDownloadURL();
        return imageURL;
      case 'user_media':
        Reference ref =
            storage.ref().child(fileLocation).child(_auth.currentUser!.uid);
        String pid = const Uuid().v1();
        ref = ref.child(pid);
        UploadTask uploadTask = ref.putFile(file);
        TaskSnapshot snap = await uploadTask;
        String imageURL = await snap.ref.getDownloadURL();
        return imageURL;

      default:
        Reference ref =
            storage.ref().child(fileLocation).child(_auth.currentUser!.uid);

        UploadTask uploadTask = ref.putFile(file);
        TaskSnapshot snap = await uploadTask;
        String imageURL = await snap.ref.getDownloadURL();
        return imageURL;
    }
  }

  Future<String> updateBannerFile(File file) async {
    Reference ref =
        storage.ref().child('user_banner_images').child(_auth.currentUser!.uid);
    ref.delete();
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snap = await uploadTask;
    String imageURL = await snap.ref.getDownloadURL();
    return imageURL;
  }

  // Upload Image Bytes
  Future<String> uploadImageBytesToStorage(
      String fileLocation, Uint8List file, String pid) async {
    switch (fileLocation) {
      case 'user_profile_images':
        Reference ref =
            storage.ref().child(fileLocation).child(_auth.currentUser!.uid);
        ref = ref.child('profile_image');
        UploadTask uploadTask = ref.putData(file);
        TaskSnapshot snap = await uploadTask;
        String imageURL = await snap.ref.getDownloadURL();
        return imageURL;
      case 'user_banner_images':
        Reference ref =
            storage.ref().child(fileLocation).child(_auth.currentUser!.uid);
        ref = ref.child('banner_image');
        UploadTask uploadTask = ref.putData(file);
        TaskSnapshot snap = await uploadTask;
        String imageURL = await snap.ref.getDownloadURL();
        return imageURL;
      case 'user_post_images':
        Reference ref =
            storage.ref().child(fileLocation).child(_auth.currentUser!.uid);
        String pid = const Uuid().v1();
        ref = ref.child(pid);
        UploadTask uploadTask = ref.putData(file);
        TaskSnapshot snap = await uploadTask;
        String imageURL = await snap.ref.getDownloadURL();
        return imageURL;
      case 'user_media':
        Reference ref =
            storage.ref().child(fileLocation).child(_auth.currentUser!.uid);
        String pid = const Uuid().v1();
        ref = ref.child(pid);
        UploadTask uploadTask = ref.putData(file);
        TaskSnapshot snap = await uploadTask;
        String imageURL = await snap.ref.getDownloadURL();
        return imageURL;
      default:
        Reference ref =
            storage.ref().child(fileLocation).child(_auth.currentUser!.uid);

        UploadTask uploadTask = ref.putData(file);
        TaskSnapshot snap = await uploadTask;
        String imageURL = await snap.ref.getDownloadURL();
        return imageURL;
    }
  }

  Future<String> updateBannerBytes(Uint8List bytes) async {
    Reference ref =
        storage.ref().child('user_banner_images').child(_auth.currentUser!.uid);
    ref.delete();
    UploadTask uploadTask = ref.putData(bytes);
    TaskSnapshot snap = await uploadTask;
    String imageURL = await snap.ref.getDownloadURL();
    return imageURL;
  }
}
