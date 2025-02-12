import 'package:http/http.dart' as http;
import 'dart:convert';

class AiExerciseDescription {
  Future<Map<String, dynamic>> getExerciseDescriptionApi(String query) async {
    final baseurl = "http://192.168.0.197:3000/chat";

    final body = jsonEncode({
      "message":
          "Generate an exercise description of $query with proper form and recommended reps for beginners, intermediates, and professionals in this format:\n\nExercise Name: [Name]\nDescription: [How to perform]\nBeginner Reps: [Number]\nIntermediate Reps: [Number]\nProfessional Reps: [Number]"
    });

    try {
      final res = await http.post(
        Uri.parse(baseurl),
        headers: {
          "Content-Type": "application/json",
        },
        body: body,
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        print(data["response"]);
        print(data);
        return data;
      } else {
        throw Exception("Failed to fetch exercise description: ${res.body}");
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
