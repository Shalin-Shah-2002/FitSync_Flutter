import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fitnessapp/Models/WorkoutModel.dart';

class WorkoutService {
  // final String baseUrl = 'http://192.168.31.104:5001';
  final String baseUrl =
      'https://nodejs-fitness-app-server-shalin.onrender.com';

  final StreamController<List<Workoutmodel>> _workoutStreamController =
      StreamController<List<Workoutmodel>>();

  Stream<List<Workoutmodel>> get workouts => _workoutStreamController.stream;

  Future<void> getWorkouts(String userId) async {
    final url = Uri.parse('$baseUrl/users/$userId/workouts');

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        List<dynamic> workouts = json.decode(res.body);
        print(workouts);

        // Yield the list of WorkoutModel objects as a stream
        _workoutStreamController.add(
            workouts.map((workout) => Workoutmodel.fromJson(workout)).toList());
      } else {
        throw Exception("The error is: ${res.body}");
      }
    } catch (e) {
      _workoutStreamController.addError(e);
    }
  }

  Future<void> AddWorkout(userid, Workoutmodel workout) async {
    // Add a new workout

    final url = Uri.parse('$baseUrl/users/$userid/workouts');
    final headers = {"Content-Type": "application/json"};
    final body = json.encode(workout.toJson());

    final res = await http.post(url, headers: headers, body: body);

    if (res.statusCode == 200) {
      print(res.body);
    } else {
      throw Exception(res.body);
    }
  }

  void dispose() {
    _workoutStreamController.close();
  }

  Future<void> deleteWorkout(String userId, String workoutId) async {
    final url = Uri.parse('$baseUrl/users/$userId/workouts/$workoutId');

    final res = await http.delete(url);

    if (res.statusCode == 200) {
      print(res.body);
    } else {
      throw Exception(res.body);
    }
  }
}
