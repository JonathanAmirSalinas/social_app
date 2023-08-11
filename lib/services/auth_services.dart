import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/services/storage_services.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Gets Current User
  Future<UserModel> getUser() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return UserModel.dataFromDoc(snap);
  }

  // Gets User via UID
  Future<UserModel> getUserProfile(String uid) async {
    DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();

    return UserModel.dataFromDoc(snap);
  }

  // Register User
  Future<void> registerUser(
      {required String email,
      required String password,
      required String name,
      required String username,
      File? imageFile,
      Uint8List? imageBytes}) async {
    try {
      // Registar User Email and Password
      final UserCredential userCred = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      String profileUrl;

      // Set Image Profile in FirebaseStorage to New User
      if (imageFile != null) {
        // Mobile File Image
        profileUrl = await StorageServices()
            .uploadImageFileToStorage("user_profile_images", imageFile);
      } else {
        // Web Bytes image
        profileUrl = await StorageServices()
            .uploadImageBytesToStorage("user_profile_images", imageBytes!);
      }
      // Add User Account to database
      UserModel user = UserModel(
        uid: userCred.user!.uid,
        email: email,
        name: name,
        username: username,
        profileUrl: profileUrl,
        bio: "Hello my name is $name!!!",
        status: "Online",
        renown: "No",
        timeJoined: Timestamp.now(),
        friends: [],
        followers: [],
        following: [],
        posts: [],
        servers: [],
        access: true,
      );
      await _firestore
          .collection('users')
          .doc(userCred.user!.uid)
          .set(user.toJson());
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  //////////////////////////////////////////////////////////// User Services ///
  // Update User's Name
  Future<void> updateUserName() async {}
  // Update User's Username
  Future<void> updateUserUsername() async {}
  // Update User's ProfileImage
  Future<void> updateUserProfileImage() async {}
  // Update User's Profile Banner
  Future<void> updateUserProfileBanner() async {}
  // Update User's Description
  Future<void> updateUserDescription() async {}
  // Update User's Email
  Future<void> updateUserEmail() async {}
  // Update User's Status
  Future<void> updateUserStatus() async {}
}
