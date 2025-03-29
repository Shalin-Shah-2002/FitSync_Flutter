import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:fitnessapp/Services/google_fit_service.dart';

class FitnessPage extends StatefulWidget {
  @override
  _FitnessPageState createState() => _FitnessPageState();
}

class _FitnessPageState extends State<FitnessPage> {
  final GoogleFitService _googleFitService = GoogleFitService();
  List<HealthDataPoint> _healthData = [];

  Future<void> fetchHealthData() async {
    final health = Health();
    List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.BODY_TEMPERATURE,
      HealthDataType.DISTANCE_WALKING_RUNNING,
    ];

    bool authorized = await health.requestAuthorization(types);
    if (authorized) {
      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        startTime: DateTime.now().subtract(Duration(days: 1)),
        endTime: DateTime.now(),
        types: types,
      );

      setState(() => _healthData = healthData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fitness Data")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await _googleFitService.signIn();
                fetchHealthData();
              },
              child: Text("Connect Google Fit & Fetch Data"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: _healthData.map((data) => ListTile(
                      title: Text("${data.typeString}: ${data.value}"),
                      subtitle: Text("Source: ${data.sourceName}"),
                    )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
