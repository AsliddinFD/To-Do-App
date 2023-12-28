import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/utils/apis.dart';
import 'package:frontend/utils/token.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void showMessage(String msg, BuildContext context) {
  if (Platform.isIOS) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }
}

Future<void> login(String email, String password, BuildContext context) async {
  if (email.trim().isEmpty || password.trim().isEmpty) {
    showMessage('Please make sure that you filled all fields', context);
  } else {
    
    final response = await http.post(
      Uri.parse(loginAPI),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {'email': email, 'password': password},
      ),
    );
    if (response.statusCode == 200 && context.mounted) {
      token = json.decode(response.body)['token'];
      print(token);
    }
  }
}

final customButtonStyle = ElevatedButton.styleFrom(
  elevation: 1,
  backgroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 12,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
    side: const BorderSide(width: 1, color: Colors.black),
  ),
);

TextStyle customTextStyle = const TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

formatTime(String time) {
  List<String> timeComponents = time.split(":");
  int hours = int.parse(timeComponents[0]);
  int minutes = int.parse(timeComponents[1]);
  TimeOfDay convertedTime = TimeOfDay(hour: hours, minute: minutes);
  final finalResult = DateFormat('HH:mm').format(
    DateTime(0, 0, 0, convertedTime.hour, convertedTime.minute),
  );

  return finalResult;
}

customInputDesign(String title) {
  return InputDecoration(
    hintText: title,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(17),
    ),
  );
}

stringToTimeOfDay(String timeString) {
  try {
    final List<String> parts = timeString.split(":");
    final int hours = int.parse(parts[0]);
    final int minutes = int.parse(parts[1]);

    return TimeOfDay(hour: hours, minute: minutes);
  } catch (e) {
    print("Error converting string to TimeOfDay: $e");
    return ''; // Return null if conversion fails
  }
}
