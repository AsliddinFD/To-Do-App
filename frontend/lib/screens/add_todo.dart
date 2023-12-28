import 'dart:convert';
import 'package:frontend/utils/functions.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/utils/apis.dart';
import 'package:frontend/utils/token.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});
  @override
  State<AddTodo> createState() {
    return _AddTodoState();
  }
}

class _AddTodoState extends State<AddTodo> {
  final _titleController = TextEditingController();
  DateTime selectedDeadline = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String time = 'Select time';
  final completed = false;
  var testDate = false;
  var testTime = false;

  @override
  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDeadline,
      firstDate: selectedDeadline,
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDeadline) {
      setState(() {
        selectedDeadline = picked;
        testDate = true;
      });
    }
  }

  void selectTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
        time = '${selectedTime.hour}:${selectedTime.minute}';
        testTime = true;
      });
    } else {
      print('${selectedTime.hour}:${selectedTime.minute}');
      setState(() {
        time = '${selectedTime.hour}:${selectedTime.minute}';
        testTime = false;
      });
    }
  }

  void addTodo() async {
    if (_titleController.text.trim().isEmpty || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill the fields'),
          duration: Duration(seconds: 4),
        ),
      );
    } else {
      final response = await http.post(
        Uri.parse(createTodoAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: json.encode(
          {
            'title': _titleController.text,
            'deadline': DateFormat('yyyy-MM-dd').format(selectedDeadline),
            'deadlineTime': DateFormat('HH:mm').format(
              DateTime(0, 0, 0, selectedTime.hour, selectedTime.minute),
            ),
            'completed': completed,
          },
        ),
      );
      if (response.statusCode == 201 && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ToDo activity added successfully'),
            duration: Duration(seconds: 4),
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.body),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Enter the todo title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _selectDate,
                    style: customButtonStyle,
                    child: testDate
                        ? Text(
                            DateFormat('yyyy-MM-dd').format(selectedDeadline),
                            style: customTextStyle,
                          )
                        : Row(
                            children: [
                              const Icon(
                                Icons.calendar_month_rounded,
                                color: Colors.black,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Select Date',
                                style: customTextStyle,
                              )
                            ],
                          ),
                  ),
                  ElevatedButton(
                    onPressed: selectTime,
                    style: customButtonStyle,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.watch_later_rounded,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          time,
                          style: customTextStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: addTodo,
                style: customButtonStyle,
                child: Text(
                  'Add the activity',
                  style: customTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
