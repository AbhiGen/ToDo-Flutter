import 'package:flutter/material.dart';
import 'package:flutter_testapplication_1/util/dailog_box.dart';
import 'package:flutter_testapplication_1/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Use explicit non-nullable types
  List<List<Object?>> pendingTasks = [
    ['Make tutorial', false],
    ['Play game', false],
  ];
  List<List<Object?>> completedTasks = [
    ['Do exercise', true],
  ];
  List<List<Object?>> deletedTasks = [];

  final TextEditingController controller = TextEditingController();

  // 0 = Pending, 1 = Completed, 2 = Deleted
  int currentTab = 0;

  // Checkbox toggle
  void checkboxchanged(bool? value, int index) {
    setState(() {
      if (currentTab == 0) {
        // Move from pending to completed
        var task = pendingTasks.removeAt(index);
        task[1] = true;
        completedTasks.add(task);
      } else if (currentTab == 1) {
        // Move from completed to pending
        var task = completedTasks.removeAt(index);
        task[1] = false;
        pendingTasks.add(task);
      }
    });
  }

  // Save task
  void onSave() {
    if (controller.text.trim().isEmpty) return;

    setState(() {
      pendingTasks.add([controller.text.trim(), false]);
      controller.clear();
    });

    Navigator.pop(context);
  }

  // Cancel add task
  void onCancel() {
    controller.clear();
    Navigator.pop(context);
  }

  // Open dialog to create new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) => DialogBox(
        controller: controller,
        onSave: onSave,
        onCancel: onCancel,
      ),
    );
  }

  // Delete task - moves task to deleted list
  void deleteTask(int index) {
    setState(() {
      if (currentTab == 0) {
        deletedTasks.add(pendingTasks.removeAt(index));
      } else if (currentTab == 1) {
        deletedTasks.add(completedTasks.removeAt(index));
      }
    });
  }

  // Switch tabs via drawer
  void changeTab(int tabIndex) {
    setState(() {
      currentTab = tabIndex;
    });
    Navigator.pop(context);
  }

  // Return the task list based on the current tab
  List<List<Object?>> get currentTaskList {
    if (currentTab == 0) return pendingTasks;
    if (currentTab == 1) return completedTasks;
    return deletedTasks;
  }

  @override
  Widget build(BuildContext context) {
    final tasks = currentTaskList; // non-null by design

    return Scaffold(
      backgroundColor: Colors.yellow[200],

      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "TASKS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.yellow,
        elevation: 0,
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.yellow),
              child: const Text(
                "Task Categories",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text("Pending Tasks"),
              selected: currentTab == 0,
              onTap: () => changeTab(0),
            ),
            ListTile(
              leading: const Icon(Icons.check),
              title: const Text("Completed Tasks"),
              selected: currentTab == 1,
              onTap: () => changeTab(1),
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("Deleted Tasks"),
              selected: currentTab == 2,
              onTap: () => changeTab(2),
            ),
          ],
        ),
      ),

      floatingActionButton: currentTab == 2
          ? null
          : FloatingActionButton(
              onPressed: createNewTask,
              child: const Icon(Icons.add, color: Colors.white),
            ),

      body: tasks.isEmpty
          ? Center(
              child: Text(
                "No tasks here!",
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              ),
            )
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final taskName = tasks[index][0] as String;
                final taskCompleted = tasks[index][1] as bool;

                return TodoTile(
                  taskName: taskName,
                  taskCompleted: taskCompleted,
                  onChanged: currentTab == 2
                      ? null
                      : (value) => checkboxchanged(value, index),
                  onDelete: currentTab == 2 ? null : () => deleteTask(index),
                );
              },
            ),
    );
  }
}
