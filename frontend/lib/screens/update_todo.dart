import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/utils/functions.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:frontend/utils/apis.dart';
import 'package:frontend/utils/token.dart';

class UpdateToDo extends StatefulWidget {
  final void Function(int id, Map todo) updateTodo;
  final Map todo;

  const UpdateToDo({
    required this.updateTodo,
    required this.todo,
  });

  @override
  _UpdateToDoState createState() => _UpdateToDoState();
}

class _UpdateToDoState extends State<UpdateToDo> {
  final _titleController = TextEditingController();
  DateTime selectedDeadline = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String time = 'Select time';

  var testDate = true;
  var testTime = true;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.todo['title'];
    selectedDeadline = DateTime.parse(widget.todo['deadline']);
    selectedTime = stringToTimeOfDay(widget.todo['deadlineTime']);
    time = '${selectedTime.hour}:${selectedTime.minute}';
  }

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
      setState(() {
        time = '${selectedTime.hour}:${selectedTime.minute}';
        testTime = false;
      });
    }
  }

  Future<void> saveTodo() async {
    if (_titleController.text.trim().isEmpty || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill the fields'),
          duration: Duration(seconds: 4),
        ),
      );
    } else {
      try {
        final response = await http.put(
          Uri.parse(
            updateTodoAPI.replaceAll('todoId', widget.todo['id'].toString()),
          ),
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
              'completed': widget.todo['completed']
            },
          ),
        );

        if (response.statusCode == 200 && context.mounted) {
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update. Please try again.'),
              duration: Duration(seconds: 4),
            ),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again.'),
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                maxLines: null,
                decoration: customInputDesign(''),
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
                        : Text(
                            'Select Date',
                            style: customTextStyle,
                          ),
                  ),
                  ElevatedButton(
                    onPressed: selectTime,
                    style: customButtonStyle,
                    child: Text(
                      time,
                      style: customTextStyle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: saveTodo,
                style: customButtonStyle,
                child: Text(
                  'Save',
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
