import 'package:fitnessapp/Services/Notification_Service/Notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:fitnessapp/Services/API/firebase_api.dart';


class ReminderPage extends StatefulWidget {
  const ReminderPage({Key? key}) : super(key: key);

  @override
  State<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
    @override
  void initState() {
    super.initState();
    _testNotification();  // Automatically test on page load
  }

  // Add this method
  Future<void> _testNotification() async {
    await NotificationService().scheduleNotification(
      999, 
      'Test Notification', 
      'Checking notification functionality', 
      DateTime.now().add(Duration(seconds: 1))
    );
  }
  TimeOfDay? selectedTime;

  // Pick time using TimePicker
  void _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  // Set a reminder notification
  void _setReminder() {
    if (selectedTime != null) {
      final now = DateTime.now();
      final reminderTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );

      if (reminderTime.isAfter(now)) {
        NotificationService().scheduleNotification(
          0, // Notification ID
          'Reminder',
          'It\'s time for your task!',
          reminderTime,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Reminder set for ${DateFormat.jm().format(reminderTime)}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a future time!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reminder App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Pick a time for your reminder:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickTime(context),
              child: Text(
                selectedTime != null
                    ? 'Selected Time: ${selectedTime!.format(context)}'
                    : 'Select Time',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _setReminder,
              child: const Text('Set Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}
