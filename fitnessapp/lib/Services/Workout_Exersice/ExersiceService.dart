import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fitnessapp/Models/WorkoutModel.dart';

class ExersiceService {
  final String baseUrl = 'http://192.168.31.104:5001';

  final StreamController<List<Exercises>> _exersiceStreamController =
      StreamController<List<Exercises>>();

  Stream<List<Exercises>> get exersiceStream =>
      _exersiceStreamController.stream;

  Future<void> addExersice(userid, Exercises exersice, String workoutId) async {
    final url =
        Uri.parse('$baseUrl/users/$userid/workouts/$workoutId/exercises');
    final headers = {"Content-Type": "application/json"};
    final body = json.encode(exersice.toJson());
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  Future<void> getExersices(String userId, String workoutId) async {
    final url =
        Uri.parse('$baseUrl/users/$userId/workouts/$workoutId/exercises');

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        List<dynamic> exersices = json.decode(res.body);
        print(exersices);
        //  _workoutStreamController.add(workouts.map((workout) => Workoutmodel.fromJson(workout)).toList());
        _exersiceStreamController.add(
            exersices.map((exersice) => Exercises.fromJson(exersice)).toList());
      } else {
        throw Exception("The error is: ${res.body}");
      }
    } catch (e) {
      print(e);
    }
  }
}
