// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class GeminiUserRecommendation {
//   Future<Map<String, dynamic>> getRecommendationApi(String age, String gender,
//       String weight, String height, String activity) async {
//     final baseurl = "https://gemini-api-gjrq.onrender.com";
//     final body = jsonEncode({
//       "prompt":
//           "You are a fitness and health expert. Based on the given user inputs, provide a structured response containing BMR, BMI, exercise recommendations, and nutrient intake in a simple, well-formatted text.\n\n### **User Inputs:**\n- **Age:** $age  \n- **Gender:** $gender  \n- **Weight:** $weight  \n- **Height:** $height  \n- **Activity Level:** $activity\n\n### **Results:**\n- **BMR (Basal Metabolic Rate):** [Calculated BMR] kcal/day\n- **BMI (Body Mass Index):** [Calculated BMI]\n\n### **Exercise Recommendations:**\n- [List of exercise recommendations based on activity level and fitness goal]\n\n### **Nutrient Intake Recommendations (per day):**\n- **Calories:** [Recommended calories] kcal\n- **Proteins:** [Recommended proteins] grams\n- **Fats:** [Recommended fats] grams\n- **Carbohydrates:** [Recommended carbohydrates] grams"
//     });

//     try {
//       final res = await http.post(
//         Uri.parse("$baseurl/generate"),
//         headers: {"Content-Type": "application/json"},
//         body: body,
//       );

//       if (res.statusCode == 200) {
//         print(jsonDecode(res.body));
//         return jsonDecode(res.body);
//       }
//       throw Exception("Failed to fetch data");
//     } catch (error) {
//       throw Exception('Error: $error');
//     }
//   }
// }

import 'package:http/http.dart' as http;
import 'dart:convert';

class GeminiUserRecommendation {
  Future<Map<String, dynamic>> getRecommendationApi(
      String age, String gender, String weight, String height, String activity) async {
    final baseurl = "https://gemini-api-gjrq.onrender.com";
    final body = jsonEncode({
      "prompt":
          "You are a fitness and health expert. Based on the given user inputs, provide a structured response containing BMR, BMI, exercise recommendations, and nutrient intake in a simple, well-formatted text.\n\n### **User Inputs:**\n- **Age:** $age  \n- **Gender:** $gender  \n- **Weight:** $weight  \n- **Height:** $height  \n- **Activity Level:** $activity\n\n### **Results:**\n- **BMR (Basal Metabolic Rate):** [Calculated BMR] kcal/day\n- **BMI (Body Mass Index):** [Calculated BMI]\n\n### **Exercise Recommendations:**\n- [List of exercise recommendations based on activity level and fitness goal]\n\n### **Nutrient Intake Recommendations (per day):**\n- **Calories:** [Recommended calories] kcal\n- **Proteins:** [Recommended proteins] grams\n- **Fats:** [Recommended fats] grams\n- **Carbohydrates:** [Recommended carbohydrates] grams"
    });

    try {
      final res = await http.post(
        Uri.parse("$baseurl/generate"),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (res.statusCode == 200) {
        final response = jsonDecode(res.body)['result'] as String;
        
        // Parsing the response into JSON format
        final parsedResponse = _parseResponse(response);
        
        print(parsedResponse);
        return parsedResponse;
      } else {
        throw Exception("Failed to fetch data");
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Map<String, dynamic> _parseResponse(String response) {
    // Extracting the details using RegExp
    final age = _extractValue(response, r"\*\*Age:\*\* (.+)");
    final gender = _extractValue(response, r"\*\*Gender:\*\* (.+)");
    final weight = _extractValue(response, r"\*\*Weight:\*\* (.+)");
    final height = _extractValue(response, r"\*\*Height:\*\* (.+)");
    final activity = _extractValue(response, r"\*\*Activity Level:\*\* (.+)");
    final bmr = _extractValue(response, r"\*\*BMR \(Basal Metabolic Rate\):\*\* (.+)");
    final bmi = _extractValue(response, r"\*\*BMI \(Body Mass Index\):\*\* (.+)");
    final cardio = _extractValue(response, r"\*\*Cardio:\*\* (.+)");
    final strength = _extractValue(response, r"\*\*Strength Training:\*\* (.+)");
    final calories = _extractValue(response, r"\*\*Calories:\*\* (.+)");
    final proteins = _extractValue(response, r"\*\*Proteins:\*\* (.+)");
    final fats = _extractValue(response, r"\*\*Fats:\*\* (.+)");
    final carbs = _extractValue(response, r"\*\*Carbohydrates:\*\* (.+)");
    final disclaimer = _extractValue(response, r"\*\*Disclaimer:\*\* (.+)");

    return {
      "User Inputs": {
        "Age": age,
        "Gender": gender,
        "Weight": weight,
        "Height": height,
        "Activity Level": activity
      },
      "Results": {
        "BMR": bmr,
        "BMI": bmi
      },
      "Exercise Recommendations": {
        "Cardio": cardio,
        "Strength Training": strength
      },
      "Nutrient Intake Recommendations (per day)": {
        "Calories": calories,
        "Proteins": proteins,
        "Fats": fats,
        "Carbohydrates": carbs
      },
      "Disclaimer": disclaimer
    };
  }

  String _extractValue(String source, String pattern) {
    final regex = RegExp(pattern);
    final match = regex.firstMatch(source);
    return match != null ? match.group(1)?.trim() ?? '' : '';
  }
}

