import 'package:fitnessapp/Services/Notification_Service/Notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fitnessapp/Provider/BottomnavbarProvider.dart';
import 'package:fitnessapp/Services/API/Calories_Food.dart';
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
// import 'package:flutter/material.dart';
// import 'package:health/health.dart';

// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:fitnessapp/Services/google_fit_service.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final GoogleFitService _googleFitService = GoogleFitService();
//   List<HealthDataPoint> _healthData = [];

// Future<void> fetchSteps() async {
//   final health = Health();

//   List<HealthDataType> types = [HealthDataType.STEPS];

//   bool authorized = await health.requestAuthorization(types);
//   if (authorized) {
//     List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
//       startTime: DateTime.now().subtract(Duration(days: 1)),
//       endTime: DateTime.now(),
//       types: types,

//           );

//     setState(() => _healthData = healthData);
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text("Google Fit in Flutter")),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: () async {
//                   await _googleFitService.signIn();
//                   fetchSteps();
//                 },
//                 child: Text("Connect Google Fit"),
//               ),
//               SizedBox(height: 20),
//               ..._healthData.map((data) => Text("${data.type}: ${data.value}")),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// // 