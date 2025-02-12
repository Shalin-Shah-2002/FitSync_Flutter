import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> scheduleNotification(
    int id, String title, String body, DateTime date) async {
  // final url = Uri.parse('http://192.168.31.104:5001/schedule-notification');
  final url = Uri.parse('https://nodejs-fitness-app-server-shalin.onrender.com/schedule-notification');

  final headers = {"Content-Type": "application/json"};

  final data = jsonEncode({
    "id": id,
    "title": title,
    "body": body,
    "date": date.toIso8601String(),
  });

  final res = await http.post(url, headers: headers, body: data);

  if (res.statusCode == 200) {
    print(res.body);
  } else {
    throw Exception(res.body);
  }
}
