import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitnessapp/Models/WorkoutModel.dart';
import 'package:fitnessapp/Provider/AuthProvider.dart';
import 'package:fitnessapp/Services/Workout_Exersice/WorkoutService.dart';

class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent({super.key});

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  String? selectedDifficulty;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Authprovider>(context);
    final userId = authProvider.userId;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: durationController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Duration (in minutes)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedDifficulty,
            decoration: const InputDecoration(
              labelText: 'Select Difficulty',
              border: OutlineInputBorder(),
            ),
            items: const <String>['EASY', 'MEDIUM', 'HARD']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedDifficulty = newValue;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                
                backgroundColor: const Color(0xFF462749),
                foregroundColor: Colors.white),
            onPressed: () async {
              if (selectedDifficulty == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a difficulty')),
                );
                return;
              }

              final workout = Workoutmodel(
                title: titleController.text.trim(),
                description: descriptionController.text.trim(),
                duration: int.tryParse(durationController.text.trim()) ?? 0,
                difficulty: selectedDifficulty!,
              );

              await WorkoutService().AddWorkout(userId, workout);

              // Refresh the workouts stream
              await WorkoutService().getWorkouts(userId);

              Navigator.pop(context); // Close the bottom sheet
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
