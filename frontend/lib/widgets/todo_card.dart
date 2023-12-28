import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:frontend/utils/functions.dart';
import 'package:frontend/screens/update_todo.dart';

class TodoCard extends StatefulWidget {
  const TodoCard({
    Key? key,
    required this.deleteTodo,
    required this.todo,
    required this.updateTodo,
    required this.getTodos,
  }) : super(key: key);

  final void Function(int id) deleteTodo;
  final void Function(int id, Map todo) updateTodo;
  final void Function() getTodos;
  final Map todo;

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  late bool test;

  @override
  void initState() {
    super.initState();
    test = widget.todo['completed'];
  }

  @override
  Widget build(BuildContext context) {
    final givenDate = DateTime.parse(widget.todo['deadline']);
    TextStyle customStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      decoration: test ? TextDecoration.lineThrough : TextDecoration.none,
      decorationColor: Colors.green,
      decorationThickness: 3,
    );
    return Container(
      padding: const EdgeInsets.only(left: 3),
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
      color: givenDate.isAfter(DateTime.now())?Colors.transparent:Colors.red,
        
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: MediaQuery.of(context).platformBrightness == Brightness.light
              ? Colors.black
              : Colors.white,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          
          Checkbox(
            value: test,
            onChanged: (newValue) {
              setState(() {
                test = newValue!;
                widget.todo['completed'] = test;
              });
              widget.updateTodo(
                widget.todo['id'],
                widget.todo,
              );
            },
          ),
          Flexible(
            child: Text(
              widget.todo['title'],
              style: customStyle,
              maxLines: null,
              overflow: TextOverflow.clip,
            ),
          ),
          const SizedBox(width: 10),
          Row(
            children: [
              const Icon(CupertinoIcons.calendar),
              Text(
                ' ${widget.todo['deadline']}',
                style: customStyle,
              )
            ],
          ),
          const SizedBox(width: 10),
          Text(
            formatTime(widget.todo['deadlineTime']),
            style: customStyle,
          ),
          widget.todo['completed']
              ? const SizedBox(
                  width: 10,
                )
              : IconButton(
                  onPressed: () async {
                    await showModalBottomSheet(
                      context: context,
                      builder: (context) => UpdateToDo(
                        updateTodo: widget.updateTodo,
                        todo: widget.todo,
                      ),
                    );
                    widget.getTodos();
                  },
                  icon: const Icon(Icons.edit),
                ),
          IconButton(
            onPressed: () {
              widget.deleteTodo(widget.todo['id']);
            },
            icon: const Icon(Icons.delete),
          )
        ],
      ),
    );
  }
}
