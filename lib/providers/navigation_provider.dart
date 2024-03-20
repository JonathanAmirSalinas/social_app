import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  String profileID = FirebaseAuth.instance.currentUser!.uid;
  String contentID = ' ';
  int routerIndex = 0;

  String get getProfileID => profileID;
  String get getContentID => contentID;
  int get getRouterIndex => routerIndex;

  // Sets navigation value for Profile ID
  Future<void> changeProfileID(String id) async {
    profileID = id;
    notifyListeners();
  }

  // Sets naviagtion value for Content ID
  Future<void> changeContentID(String id) async {
    contentID = id;
    notifyListeners();
  }

  // Sets naviagtion value for Content ID
  Future<void> changeRouterIndex(int tab) async {
    routerIndex = tab;
    notifyListeners();
  }
}
