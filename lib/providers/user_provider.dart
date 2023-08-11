import 'package:flutter/material.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/services/auth_services.dart';

class UserProvider with ChangeNotifier {
  final AuthServices _fbAuth = AuthServices();
  UserModel? _user;

  UserModel get getUser => _user!;

  Future<void> refreshUser() async {
    UserModel user = await _fbAuth.getUser();
    _user = user;
    notifyListeners();
  }
}
