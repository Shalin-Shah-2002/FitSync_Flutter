import 'package:fitnessapp/Services/Workout_Exersice/ExersiceService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitnessapp/Provider/AuthProvider.dart';
import 'package:fitnessapp/Models/WorkoutModel.dart';
import 'Components/Add_Exersice.dart';
import 'package:fitnessapp/Views/Exersice_Screen.dart';

class WorkoutDetails extends StatefulWidget {
  final String workoutId;

  const WorkoutDetails({Key? key, required this.workoutId}) : super(key: key);

  @override
  State<WorkoutDetails> createState() => _WorkoutDetailsState();
}

class _WorkoutDetailsState extends State<WorkoutDetails> {
  final ExersiceService exersiceService = ExersiceService();

  @override
  void initState() {
    super.initState();
    final userId = Provider.of<Authprovider>(context, listen: false).userId;
    exersiceService.getExersices(userId, widget.workoutId);
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Authprovider>(context, listen: false).userId;

    final Color primaryColor = const Color(0xFF462749);
    final Color accentColor = const Color.fromARGB(255, 255, 255, 255);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Workout Details',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, accentColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Your Exercises",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: StreamBuilder<List<Exercises>>(
                    stream: exersiceService.exersiceStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error, size: 48, color: Colors.red),
                              const SizedBox(height: 8),
                              Text(
                                "Error: ${snapshot.error}",
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.fitness_center,
                                  size: 64,
                                  color: Colors.grey.withOpacity(0.5)),
                              const SizedBox(height: 16),
                              const Text(
                                "No exercises found.",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Start by adding some exercises!",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final exercises = snapshot.data!;
                      return ListView.builder(
                        itemCount: exercises.length,
                        itemBuilder: (context, index) {
                          final exercise = exercises[index];
                          return ExerciseCard(
                            name: exercise.name,
                            sets: exercise.sets,
                            reps: exercise.reps,
                            duration: exercise.duration,
                            color: primaryColor,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ExerciseSearchList(
                                          query: exercise.name ?? '',
                                        )),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            builder: (context) => ExerciseInputPage(
              workoutId: widget.workoutId,
              userId: userId,
            ),
          );
        },
        backgroundColor: primaryColor,
        label: const Text(
          "Add Exercise",
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final String? name;
  final int? sets;
  final int? reps;
  final int? duration;
  final Color color;
  final VoidCallback onTap;

  const ExerciseCard({
    Key? key,
    this.name,
    this.sets,
    this.reps,
    this.duration,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(
            Icons.fitness_center,
            color: color,
          ),
        ),
        title: Text(
          name ?? 'Exercise Name',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Sets: $sets | Reps: $reps | Duration: ${duration ?? 0} mins',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }
}
