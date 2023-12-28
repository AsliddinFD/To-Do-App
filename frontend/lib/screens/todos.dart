import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/screens/login.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/utils/apis.dart';
import 'package:frontend/utils/token.dart';
import 'package:frontend/screens/add_todo.dart';
import 'package:frontend/widgets/todo_card.dart';

class ToDos extends StatefulWidget {
  const ToDos({super.key});
  @override
  State<ToDos> createState() {
    return _ToDosState();
  }
}

class _ToDosState extends State<ToDos> {
  @override
  void initState() {
    super.initState();
    getTodos();
  }

  late Widget mainWidget;
  List responseData = [];

  getTodos() async {
    final response = await http
        .get(Uri.parse(getToDoAPi), headers: {'Authorization': 'Token $token'});
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);

      setState(() {
        responseData = responseBody;
        print(responseBody[0]['deadline'].runtimeType);
        mainWidget = ListView.builder(
          itemCount: responseBody.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(top: 16, left: 5, right: 5),
            child: TodoCard(
              getTodos: getTodos,
              deleteTodo: deleteTodo,
              todo: responseBody[index],
              updateTodo: updateTodo,
            ),
          ),
        );
      });
    }
  }

  void deleteTodo(int id) async {
    final response = await http.delete(
        Uri.parse(
          deleteToDoAPI.replaceAll(
            'todoId',
            id.toString(),
          ),
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        });
    if (response.statusCode == 204 && context.mounted) {
      getTodos();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Activity has been deleted'),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  void updateTodo(int id, Map todo) async {
    final response = await http.put(
      Uri.parse(
        updateTodoAPI.replaceAll(
          'todoId',
          id.toString(),
        ),
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
      body: json.encode(
        {
          'title': todo['title'],
          'deadline': todo['deadline'],
          'deadlineTime': todo['deadlineTime'],
          'completed': todo['completed']
        },
      ),
    );
    if (response.statusCode == 200 && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Activity has been updated'),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities'),
        actions: [
          IconButton(
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                builder: (context) => const AddTodo(),
              );
              await getTodos();
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Login(),
                ),
              );
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: responseData.isEmpty
          ? const Center(
              child: Text('You have nothing to do yet.'),
            )
          : mainWidget,
    );
  }
}
