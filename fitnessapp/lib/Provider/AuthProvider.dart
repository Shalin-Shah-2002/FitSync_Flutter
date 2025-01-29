import 'package:flutter/material.dart';
import 'package:fitnessapp/Models/Usermodel.dart';
import 'package:fitnessapp/Services/AuthService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authprovider with ChangeNotifier {
  final AuthService _authservice = AuthService();

  User? _user;
  String? _token;

  User? get user => _user;
  String? get token => _token;

  bool get isAuth => _token != null && _token!.isNotEmpty;

  dynamic _userId;
  dynamic get userId => _userId;

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) {
      return;
    }

    _token = prefs.getString('token');
    _userId = prefs.getString('userID');

    print('User ID: $_userId');

    notifyListeners();
  }

  Future<void> register(String username, String email, String password) async {
    try {
      final res = await _authservice.register(username, email, password);
      print(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final res = await _authservice.login(email, password);
      final prefs = await SharedPreferences.getInstance();

      final userdata = User(name: email.split('@')[0], email: email);
      _user = userdata;
      _token = res;

      _userId = AuthService.userId;

      await prefs.setString('token', res);
      await prefs.setString('userID', _userId.toString());

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _user = null;
    _token = null;
    notifyListeners();
  }
}
