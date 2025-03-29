import 'package:http/http.dart' as http;
import 'dart:convert';

class GeminiExerciseRecommandation {
  Future<Map<String, dynamic>> getExerciseRecommandationApi(String query) async {
    final baseurl = "https://gemini-api-gjrq.onrender.com";

    final body = jsonEncode({
      "prompt":
          "Generate a structured exercise plan for $query with the following details. Ensure the response follows the exact format mentioned below:\n\n"
          "**Exercise Name:** <exercise_name>\n"
          "**Description:** <description>\n"
          "**Recommended Reps:**\n"
          "**Beginners:** <beginners_reps>\n"
          "**Intermediate:** <intermediate_reps>\n"
          "**Professional:** <professional_reps>"
    });

    try {
      final res = await http.post(
        Uri.parse("$baseurl/generate"),
        headers: {
          "Content-Type": "application/json",
        },
        body: body,
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        String responseText = data["result"] ?? "";

        Map<String, dynamic> formattedData = parseExerciseResponse(responseText);
        print(formattedData);
        return formattedData;
      } else {
        throw Exception("Failed to fetch exercise description: ${res.body}");
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Map<String, dynamic> parseExerciseResponse(String response) {
    RegExp exerciseNameRegex = RegExp(r"\*\*Exercise Name:\*\*\s*(.+)");
    RegExp descriptionRegex = RegExp(r"\*\*Description:\*\*\s*(.+)");
    RegExp beginnersRegex = RegExp(r"\*\*Beginners:\*\*\s*(.+)");
    RegExp intermediateRegex = RegExp(r"\*\*Intermediate:\*\*\s*(.+)");
    RegExp professionalRegex = RegExp(r"\*\*Professional:\*\*\s*(.+)");

    String exerciseName = _extractData(response, exerciseNameRegex);
    String description = _extractData(response, descriptionRegex);
    String beginners = _extractData(response, beginnersRegex);
    String intermediate = _extractData(response, intermediateRegex);
    String professional = _extractData(response, professionalRegex);

    return {
      "Exercise Name": exerciseName,
      "Description": description,
      "Recommended Reps": {
        "Beginners": beginners,
        "Intermediate": intermediate,
        "Professional": professional,
      }
    };
  }

  String _extractData(String response, RegExp regex) {
    final match = regex.firstMatch(response);
    return match != null ? match.group(1)?.trim() ?? "" : "";
  }
}
