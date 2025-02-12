import 'dart:ffi';

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebasemessaging = FirebaseMessaging.instance;

  // final token = FirebaseMessaging.instance.getToken();
  String? token;
  String? get firebasetoken => token;
  Future<String> initNotifiactions() async {
    await _firebasemessaging.requestPermission();

    token = await _firebasemessaging.getToken();

    print("Token: $token");
    return token!;
  }
}
