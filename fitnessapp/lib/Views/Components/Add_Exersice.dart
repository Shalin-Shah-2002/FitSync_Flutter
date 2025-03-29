import 'package:flutter/material.dart';
import 'package:fitnessapp/Services/Workout_Exersice/ExersiceService.dart';
import 'package:fitnessapp/Models/WorkoutModel.dart';

class ExerciseInputPage extends StatefulWidget {
  final String workoutId;
  final String userId;
  const ExerciseInputPage(
      {super.key, required this.workoutId, required this.userId});

  @override
  State<ExerciseInputPage> createState() => _ExerciseInputPageState();
}

class _ExerciseInputPageState extends State<ExerciseInputPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController setsController = TextEditingController();
  final TextEditingController repsController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add Exercise Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Name of the Exercise",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.fitness_center),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: setsController,
            decoration: const InputDecoration(
              labelText: "Sets",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.fitness_center),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: repsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Reps",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.repeat),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: timeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Duration (in minutes)",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.timer),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                print(widget.userId);
                Exercises exercises = Exercises(
                  name: nameController.text,
                  sets: int.parse(setsController.text),
                  reps: int.parse(repsController.text),
                  duration: int.parse(timeController.text),
                );

                ExersiceService()
                    .addExersice(widget.userId, exercises, widget.workoutId);
              },
              child: const Text("Save"),
            ),
          ),
        ],
      ),
    );
  }
}
