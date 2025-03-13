// Ask the user for their 23 age, male gender (male/female/other),183 height (cm), 68 weight (kg), and activity level (Sedentary, Lightly Active, Moderately Active, Very Active). Calculate their BMI and classify it as Underweight, Normal, Overweight, or Obese. Use the Mifflin-St Jeor formula to determine their BMR (Basal Metabolic Rate). Based on their BMI and fitness goal, determine whether they should Lose Weight, Maintain, or Gain Muscle. Provide a workout plan accordingly: Cardio-focused workouts with strength training for weight loss, a balanced mix of cardio and weight training for maintenance, and heavy strength training with compound lifts for muscle gain. Include specific exercises they should follow in a comma-separated list.\n\nPresent the results in this format:\n\nBody Goal: [Lose Weight / Maintain / Gain Muscle]\nExercises You Should Follow: [List exercises separated by commas]\nBMR: [Calculated Value]\nBMI: [Value + Classification]

import 'package:fitnessapp/Views/recommendation_screen.dart';
import 'package:flutter/material.dart';
import 'package:fitnessapp/Services/API/Gemini-user-recommandation.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  // Form values
  int _age = 25;
  double _weight = 70;
  double _height = 170;
  String _gender = 'Male';
  String _activityLevel = 'Moderate';

  // Gender options
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  // Activity level options with descriptions
  final Map<String, String> _activityLevels = {
    'Sedentary': 'Little to no exercise',
    'Light': '1-3 days per week',
    'Moderate': '3-5 days per week',
    'Active': '6-7 days per week',
    'Very Active': 'Professional athlete level'
  };
  final _geminiUserRecommandation = GeminiUserRecommendation();
  @override
  void initState() {
    super.initState();
    // _geminiUserRecommandation.getRecommendationApi(
    //     '25', 'Male', '70', '170', 'Moderate');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF462749), // Deep Purple
              Color(0xFF3F3F3F), // Dark Gray
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text(
                    'Your Profile Details',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Help us personalize your fitness journey',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Age Card
                  _buildInfoCard(
                    title: 'Age',
                    icon: Icons.calendar_today_outlined,
                    child: Column(
                      children: [
                        Text(
                          '$_age years',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF462749),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Slider(
                          min: 16,
                          max: 80,
                          divisions: 64,
                          value: _age.toDouble(),
                          activeColor: const Color(0xFF462749),
                          inactiveColor: Colors.grey[300],
                          onChanged: (value) {
                            setState(() {
                              _age = value.round();
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('16', style: TextStyle(color: Colors.grey)),
                            Text('80', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Weight Card
                  _buildInfoCard(
                    title: 'Weight',
                    icon: Icons.monitor_weight_outlined,
                    child: Column(
                      children: [
                        Text(
                          '${_weight.toStringAsFixed(1)} kg',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF462749),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Slider(
                          min: 40,
                          max: 150,
                          divisions: 110,
                          value: _weight,
                          activeColor: const Color(0xFF462749),
                          inactiveColor: Colors.grey[300],
                          onChanged: (value) {
                            setState(() {
                              _weight = double.parse(value.toStringAsFixed(1));
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('40 kg', style: TextStyle(color: Colors.grey)),
                            Text('150 kg',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Height Card
                  _buildInfoCard(
                    title: 'Height',
                    icon: Icons.height_outlined,
                    child: Column(
                      children: [
                        Text(
                          '${_height.toStringAsFixed(1)} cm',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF462749),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Slider(
                          min: 140,
                          max: 220,
                          divisions: 80,
                          value: _height,
                          activeColor: const Color(0xFF462749),
                          inactiveColor: Colors.grey[300],
                          onChanged: (value) {
                            setState(() {
                              _height = double.parse(value.toStringAsFixed(1));
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('140 cm',
                                style: TextStyle(color: Colors.grey)),
                            Text('220 cm',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Gender Card
                  _buildInfoCard(
                    title: 'Gender',
                    icon: Icons.people_outline,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _genderOptions.map((gender) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _gender = gender;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: _gender == gender
                                  ? const Color(0xFF462749)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              gender,
                              style: TextStyle(
                                color: _gender == gender
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // Activity Level Card
                  _buildInfoCard(
                    title: 'Activity Level',
                    icon: Icons.directions_run_outlined,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        ...(_activityLevels.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _activityLevel = entry.key;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: _activityLevel == entry.key
                                      ? const Color(0xFFE1BEE7)
                                      : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _activityLevel == entry.key
                                        ? const Color(0xFF462749)
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _activityLevel == entry.key
                                            ? const Color(0xFF462749)
                                            : Colors.white,
                                        border: Border.all(
                                          color: _activityLevel == entry.key
                                              ? Colors.transparent
                                              : Colors.grey,
                                          width: 2,
                                        ),
                                      ),
                                      child: _activityLevel == entry.key
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 16,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            entry.key,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            entry.value,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList()),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Continue Button
                  ElevatedButton(
                    onPressed: () {
                      // _geminiUserRecommandation.getRecommendationApi(
                      //     _age.toString(),
                      //     _gender,
                      //     _weight.toString(),
                      //     _height.toString(),
                      //     _activityLevel);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecommendationScreen(
                                activityLevel: _activityLevel,
                                age: _age,
                                gender: _gender,
                                height: _height,
                                weight: _weight),
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF462749),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1BEE7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF462749),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
