import 'package:flutter/material.dart';

class Profile_Scrren extends StatefulWidget {
  const Profile_Scrren({super.key});

  @override
  State<Profile_Scrren> createState() => _Profile_ScrrenState();
}

class _Profile_ScrrenState extends State<Profile_Scrren> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Profile Screen")),);
  }
}