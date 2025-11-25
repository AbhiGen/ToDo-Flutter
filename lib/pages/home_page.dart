import 'package:flutter/material.dart';
import 'package:flutter_testapplication_1/util/dailog_box.dart';
import 'package:flutter_testapplication_1/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List todoList = [
    ['Make tutorial', false],
    ['Do exercise', true],
    ['Play game', false],
  ];

  final TextEditingController controller = TextEditingController();

  void checkboxchanged(bool? value, int index) {
    setState(() {
      todoList[index][1] = !todoList[index][1];
    });
  }

  void onSave() {
    setState(() {
      todoList.add([controller.text, false]);
      controller.clear();
    });
    Navigator.pop(context);
  }

  void onCancel() {
    controller.clear();
    Navigator.pop(context);
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: controller,
          onSave: onSave,
          onCancel: onCancel,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: const Text('To Do'),
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),

      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return TodoTile(
            taskName: todoList[index][0],
            taskCompleted: todoList[index][1],
            onChanged: (value) => checkboxchanged(value, index),
          );
        },
      ),
    );
  }
}
