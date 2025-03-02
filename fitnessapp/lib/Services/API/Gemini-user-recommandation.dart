import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'dart:convert';

class GeminiUserRecommandation {
  
    Future<Map<String, dynamic>> getRecommandationApi(
        String age, String gender, String weight, String height, String activity) async {
      final baseurl = "https://gemini-api-gjrq.onrender.com";
      final body = jsonEncode({
        "prompt":
            "You are a fitness and health expert. Based on the given user inputs, provide a structured response containing BMR, BMI, exercise recommendations, and nutrient intake.\n\n### **User Inputs:**\n- **Age:** $age  \n- **Gender:** $gender  \n- **Weight:** $weight  \n- **Height:** $height  \n- **Activity Level:** $activity  \n\n### **Structured Response Format:**  \n#### **1. BMR (Basal Metabolic Rate)**  \n- Calculate BMR using the **Mifflin-St Jeor Equation**:  \n  - Male: `BMR = (10 × weight) + (6.25 × height) - (5 × age) + 5`  \n  - Female: `BMR = (10 × weight) + (6.25 × height) - (5 × age) - 161`  \n- Show the **calculated BMR** and the **total daily calorie requirement** based on the activity level.\n\n#### **2. BMI (Body Mass Index)**  \n- Calculate BMI using: `BMI = weight / (height in meters)^2`  \n- Provide a **BMI category** based on the WHO classification:\n  - Underweight (<18.5)\n  - Normal weight (18.5 - 24.9)\n  - Overweight (25 - 29.9)\n  - Obese (≥30)\n\n#### **3. Exercise Recommendations**  \n- Based on **BMR and BMI category**, suggest an exercise plan:\n  - Underweight: Focus on strength training and calorie surplus.\n  - Normal weight: Balanced mix of cardio & strength training.\n  - Overweight: Cardio-focused plan with strength training.\n  - Obese: Low-impact exercises like walking, swimming, cycling.\n\n#### **4. Nutritional Intake**  \n- **Macronutrient Breakdown** (based on BMR and activity level):  \n  - Protein: __ g per day  \n  - Carbohydrates: __ g per day  \n  - Fats: __ g per day  \n- **Recommended Foods**: List foods rich in protein, healthy fats, and complex carbs.  \n- **Hydration Advice**: Suggested daily water intake.\n\n### **Response Guidelines:**  \n- Keep the response **clear and structured**.  \n- Use **bullet points and headers** for better readability.  \n- Provide **practical and realistic recommendations.**"
      });
      try {
        final res = await http.post(
          Uri.parse(baseurl + "/generate"),
          headers: {
            "Content-Type": "application/json",
          },
          body: body,
        );
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          String responseText = data["result"] ?? "";
          print(responseText);
          return data;
        }
        else {
          throw Exception("Failed to fetch exercise description: ${res.body}");
        }
      } catch (error) {
        throw Exception('Error: $error');
      }
    }
  
}
