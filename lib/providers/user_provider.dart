import 'package:flutter/material.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/services/auth_services.dart';
import 'package:social_app/services/server_services.dart';

class UserProvider with ChangeNotifier {
  final AuthServices _fbAuth = AuthServices();
  UserModel? _user;
  List<Map<String, dynamic>> servers = [];

  UserModel get getUser => _user!;
  List get getServers => servers;

  Future<void> refreshUser() async {
    UserModel user = await _fbAuth.getUser();
    await getUserServerInfo();
    _user = user;
    notifyListeners();
  }

  Future<void> getUserServerInfo() async {
    List<Map<String, dynamic>> userServers =
        await ServerServices().getServerList();
    servers = userServers;
    notifyListeners();
  }
}
