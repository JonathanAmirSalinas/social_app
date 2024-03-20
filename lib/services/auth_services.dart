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

  Future<Map<String, dynamic>> getMentionedUser(String mention) async {
    var snap = await _firestore
        .collection('users')
        .where('username', isEqualTo: mention)
        .get();

    var mentionedUser = snap.docs.first.data();

    // Returns Mentioned User uid
    return mentionedUser;
  }

  Future<bool> checkUniqueServerID(String serverID) async {
    try {
      var snap = await _firestore
          .collection('servers')
          .where('sid', isEqualTo: serverID)
          .get();
      if (snap.docs.isNotEmpty) {
        return false;
      }
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  // Register User
  Future<void> registerUser({
    required String email,
    required String password,
    required String name,
    required String username,
    File? profileImageFile,
    Uint8List? profileImageBytes,
    File? bannerImageFile,
    Uint8List? bannerImageBytes,
  }) async {
    try {
      // Registar User Email and Password
      final UserCredential userCred = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      String profileUrl;
      String bannerUrl;

      // Set Image Profile in FirebaseStorage to New User
      if (profileImageFile != null) {
        // Mobile File Image
        profileUrl = await StorageServices().uploadImageFileToStorage(
            "user_profile_images", profileImageFile, "");
      } else {
        // Web Bytes image
        profileUrl = await StorageServices().uploadImageBytesToStorage(
            "user_profile_images", profileImageBytes!, "");
      }

      // Set Image Profile Banner in FirebaseStorage to New User
      if (bannerImageFile != null) {
        // Mobile File Image
        bannerUrl = await StorageServices().uploadImageFileToStorage(
            "user_banner_images", bannerImageFile, "");
      } else {
        // Web Bytes image
        bannerUrl = await StorageServices().uploadImageBytesToStorage(
            "user_banner_images", bannerImageBytes!, "");
      }
      // Add User Account to database
      UserModel user = UserModel(
        uid: userCred.user!.uid,
        email: email,
        name: name,
        username: username,
        profileUrl: profileUrl,
        bannerUrl: bannerUrl,
        bio: "Hello my name is $name!!!",
        status: "Online",
        renown: "No",
        recentlySearched: [],
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
  Future<void> updateUserName(String name) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'name': name});
    } catch (e) {
      print(e);
    }
  }

  // Update User's Username
  Future<void> updateUserUsername(String username) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'username': username});
    } catch (e) {
      print(e);
    }
  }

  // Update User's ProfileImage
  Future<void> updateUserProfileImage() async {}

  // Update User's Profile Banner
  Future<void> updateUserProfileBanner(
      File? bannerFile, Uint8List? bannerBytes) async {
    try {
      String bannerUrl;
      // Set Image Profile Banner in FirebaseStorage to New User
      if (bannerFile != null) {
        // Mobile File Image
        bannerUrl = await StorageServices().updateBannerFile(bannerFile);
      } else {
        // Web Bytes image
        bannerUrl = await StorageServices().updateBannerBytes(bannerBytes!);
      }
      // Set New
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'banner_image': bannerUrl});
    } catch (e) {
      print(e);
    }
  }

  // Update User's Description
  Future<void> updateUserDescription(String bio) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'bio': bio});
    } catch (e) {
      print(e);
    }
  }

  // Update User's Email
  Future<void> updateUserEmail() async {}
  // Update User's Status
  Future<void> updateUserStatus() async {}

  Future<bool> validateUsername(String username) async {
    try {
      var data = await FirebaseFirestore.instance
          .collection('users')
          .where('username')
          .get();

      if (data.docs.isEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
