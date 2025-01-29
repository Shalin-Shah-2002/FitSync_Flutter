import 'package:flutter/material.dart';
import 'package:fitnessapp/Provider/AuthProvider.dart';
import 'package:provider/provider.dart';

class hello extends StatelessWidget {
  const hello({super.key});

  @override
  Widget build(BuildContext context) {
    final logout = Provider.of<Authprovider>(context);
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              logout.logout();
            },
            child: Text("Log-out")),
      ),
    );
  }
}
