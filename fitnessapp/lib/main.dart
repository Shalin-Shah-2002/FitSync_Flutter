import 'package:fitnessapp/Services/Notification_Service/Notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fitnessapp/Provider/BottomnavbarProvider.dart';
import 'package:fitnessapp/Services/API/Calories_Food.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitnessapp/Services/API/Exersice_Api.dart';
import 'package:fitnessapp/Services/API/firebase_api.dart';
import 'package:fitnessapp/Views/LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitnessapp/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'Provider/AuthProvider.dart';
import 'Views/Homepage.dart';
import 'dart:io';
 


void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifiactions();

  await NotificationService().init();
  
  if (Platform.isAndroid) {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();  
    
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    await androidImplementation?.requestNotificationsPermission();
    await androidImplementation?.requestExactAlarmsPermission();
  }
  
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Authprovider()..tryAutoLogin()),
        ChangeNotifierProvider(create: (_) => BottomNavBarProvider()),
        ChangeNotifierProvider(create: (_) => CaloriesFood()),
        ChangeNotifierProvider(create: (_) => ExersiceService()),
      ],
      child: Consumer<Authprovider>(
        builder: (context, auth, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Fitness App",
            theme: ThemeData(primarySwatch: Colors.blue),
            home: auth.isAuth ? HomePage() : LoginScreen(),
          );
        },
      ),
    );
  }
}
