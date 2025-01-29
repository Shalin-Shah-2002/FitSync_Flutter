import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://192.168.31.104:5001';

  // Static variable to store userId
  static String? userId;

  Future<String> register(
      String username, String email, String password) async {
    final url = Uri.parse('$baseUrl/register');
    final headers = {"Content-Type": "application/json"};
    final body =
        json.encode({"name": username, "email": email, "password": password});

    final res = await http.post(
      url,
      headers: headers,
      body: body,
    );
    if (res.statusCode == 200) {
      return res.body;
    } else {
      throw Exception(res.body);
    }
  }

  Future<String> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final headers = {"Content-Type": "application/json"};
    final body = json.encode({"email": email, "password": password});
    final res = await http.post(url, headers: headers, body: body);
    final data = json.decode(res.body);

    if (res.statusCode == 200) {
      print(res.body);
      // Assign the userId to the static variable
      userId = data['userid'];
      print(userId);
      return res.body;
    } else {
      throw Exception(res.body);
    }
  }
}
