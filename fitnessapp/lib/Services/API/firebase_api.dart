import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebasemessaging = FirebaseMessaging.instance;

  Future<void> initNotifiactions() async {
    await _firebasemessaging.requestPermission();

    final token = await _firebasemessaging.getToken();

    print("Token: $token");
  }
}
