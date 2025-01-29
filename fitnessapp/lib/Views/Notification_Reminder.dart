
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



class HomePage_1 extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage_1> {
  DateTime selectedDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  // Method to show the Date Picker
  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDateTime) {
      setState(() {
        selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          selectedDateTime.hour,
          selectedDateTime.minute,
        );
      });
    }
  }

  // Method to show the Time Picker
  Future<void> _pickTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
    );

    if (pickedTime != null) {
      setState(() {
        selectedDateTime = DateTime(
          selectedDateTime.year,
          selectedDateTime.month,
          selectedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }


  // Method to call the API and schedule the notification
  Future<void> scheduleNotification(
  String id, String title, String body, DateTime date
) async {
  final url = Uri.parse('http://192.168.31.104:5001/schedule-notification');
  final headers = {"Content-Type": "application/json"};

  final formattedDateTime = date.toUtc().toIso8601String(); // Convert to ISO 8601 format

  final data = jsonEncode({
    "token": id,
    "title": title,
    "body": body,
    "scheduleTime": formattedDateTime, // Use the formatted date
  });

  final res = await http.post(url, headers: headers, body: data);

  if (res.statusCode == 200) {
    print(res.body);
  } else {
    throw Exception(res.body);
  }
}


  // Method to schedule notification after date-time selection
  void _scheduleNotification() {
    scheduleNotification(
     "eLp5gl_aSSewRLap82ud1h:APA91bE858_CVZdwknUmEhKA1w5ht8m2FmYfzl7ya0_VhmkpBwD4qLFIGo_yRQdQ2Rw0_KnvIIyvsk9tBtQItqCgz-DF7EEOe4wVjrW-0g1RHm639PMRC5o", // Sample notification ID
      'Scheduled Notification',
      'This is a scheduled notification.',
      selectedDateTime,
    ).then((_) {
      // After scheduling, you can show a success message or handle it as needed.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Notification Scheduled'),
              content: Text('Your notification is scheduled for ${selectedDateTime.toString()}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      });
    }).catchError((e) {
      print('Error scheduling notification: $e');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Scheduler'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Selected Date & Time: ${selectedDateTime.toString()}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickDate,
              child: Text('Pick Date'),
            ),
            ElevatedButton(
              onPressed: _pickTime,
              child: Text('Pick Time'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scheduleNotification,
              child: Text('Schedule Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
