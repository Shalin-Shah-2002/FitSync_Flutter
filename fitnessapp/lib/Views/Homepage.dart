import 'package:flutter/material.dart';
import 'package:fitnessapp/Provider/AuthProvider.dart';
import 'package:fitnessapp/Services/Workout_Exersice/WorkoutService.dart';
import 'package:fitnessapp/Views/Components/navitem.dart';
import 'package:provider/provider.dart';
import 'package:fitnessapp/Provider/BottomnavbarProvider.dart';
import 'package:fitnessapp/Views/hello.dart';
import 'package:fitnessapp/Views/Home.dart';
import 'package:fitnessapp/Views/Components/ExersiceBottomSheetContent.dart';
import 'package:fitnessapp/Views/Calories.dart';
import 'package:fitnessapp/Views/Exersice_Screen.dart';
import 'package:fitnessapp/Views/Reminder.dart';
import 'package:fitnessapp/Views/Notification_Reminder.dart';


class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Color SelectedColor = Color(0xFF462749);
  Color UnselectedColor = Color(0xFF8332AC);

  @override
  Widget build(BuildContext context) {
    final pagechange = Provider.of<BottomNavBarProvider>(context);
    final authProvider = Provider.of<Authprovider>(context);
    final userId = authProvider.userId;

    return Scaffold(
      floatingActionButton: pagechange.selectedindex == 0
          ? FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => BottomSheetContent());
                WorkoutService().getWorkouts(userId);
              },
              backgroundColor: SelectedColor,
              shape: CircleBorder(side: BorderSide(color: UnselectedColor)),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFF462749), // Background color of the navbar
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), // Rounded corners at the top
            topRight: Radius.circular(40),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              offset: Offset(0, -5), // Shadow above the navbar
            ),
          ],
        ),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            NavItem(icon: Icons.home, label: "Home", index: 0),
            NavItem(icon: Icons.fastfood_outlined, label: "Calories", index: 1),
            NavItem(icon: Icons.sports_gymnastics, label: "Exerises", index: 2),
            NavItem(icon: Icons.search, label: "Search", index: 3),
          ],
        ),
      ),
      body: pagechange.selectedindex == 0
          ? Home() // Home page when index is 0
          : pagechange.selectedindex == 1
              ? Calories() // Calories page when index is 1
              : pagechange.selectedindex == 2
                  ? ExerciseSearchList() // Exercise search page when index is 2
                  : pagechange.selectedindex == 3
                      ? const Center(child: Text("Search or Profile Page")) // Placeholder for index 3
                      : const Center(child: Text("Calories")),
    );
  }
}
