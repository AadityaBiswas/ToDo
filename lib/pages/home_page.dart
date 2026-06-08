import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/pages/add_task.dart';
import 'package:todo/pages/fab.dart';
import 'package:todo/pages/todotile.dart';
import 'package:todo/theme/app_theme.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final taskData = Hive.box("Tasks");

  List<Map<String, dynamic>> tasks = [];
  int? activeTimerIndex;
  bool fabTapped = false;

  @override
  void initState() {
    super.initState();
    _loadTasksFromHive();
  }

  void _loadTasksFromHive() {
    var savedData = taskData.get("allTasks");
    if (savedData != null) {
      tasks = List<Map<String, dynamic>>.from(
        savedData.map((item) => Map<String, dynamic>.from(item)),
      );
    }
  }

  void _saveTasks() {
    taskData.put("allTasks", tasks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            fabTapped = false;
            activeTimerIndex = null;
          });
        },
        child: Stack(
          children: [
            taskList(),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: FabButton(
                  tapped: fabTapped,
                  onToggle: () {
                    setState(() {
                      fabTapped = !fabTapped;
                      if (fabTapped) {
                        activeTimerIndex = null;
                      }
                    });
                  },
                  onTaskAdded: (newTask) {
                    setState(() {
                      // All tasks are saved to the master list
                      tasks.add(newTask);
                      _saveTasks();
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView taskList() {
    // 1. Get current date
    final DateTime now = DateTime.now();

    // 2. Filter tasks for today, saving their ORIGINAL index in the master list
    List<MapEntry<int, Map<String, dynamic>>> todaysTasks = [];
    for (int i = 0; i < tasks.length; i++) {
      final task = tasks[i];

      // Safely parse date components (handles both String and Int storage)
      final int tDate = int.tryParse(task["date"]?.toString() ?? "0") ?? 0;
      final int tMonth = int.tryParse(task["month"]?.toString() ?? "0") ?? 0;
      final int tYear = int.tryParse(task["year"]?.toString() ?? "0") ?? 0;

      // Check if the task matches today's date
      if (tDate == now.day && tMonth == now.month && tYear == now.year) {
        todaysTasks.add(MapEntry(i, task));
      }
    }

    return ListView.builder(
      itemCount: todaysTasks.length, // Only build for today's tasks
      padding: const EdgeInsets.only(top: 52, left: 20, right: 20, bottom: 52),
      itemBuilder: (context, index) {
        // 3. Extract the original master index and the task data
        final int originalIndex = todaysTasks[index].key;
        final Map<String, dynamic> task = todaysTasks[index].value;

        return ToDoTile(
          taskName: task["name"]?.toString() ?? "0",
          taskHour: task["hour"]?.toString() ?? "0",
          taskMinute: task["minute"]?.toString() ?? "0",
          taskDate: task["date"]?.toString() ?? "0",
          taskMonth: task["month"]?.toString() ?? "0",
          taskYear: task["year"]?.toString() ?? "0",
          isCompleted: task["isCompleted"] ?? false,
          isHighPriority: false, // Hardcoded to false to enforce normal state
          isTimerActive:
              activeTimerIndex == originalIndex, // Match against original index
          onTimerTap: () {
            setState(() {
              fabTapped = false;
              if (activeTimerIndex == originalIndex) {
                activeTimerIndex = null;
              } else {
                activeTimerIndex = originalIndex;
              }
            });
          },
          onEditedTask: (updatedTask) {
            setState(() {
              fabTapped = false;
              if (updatedTask['delete'] == true) {
                // Delete from the master list using the original index
                tasks.removeAt(originalIndex);
                if (activeTimerIndex == originalIndex) {
                  activeTimerIndex =
                      null; // Clear timer if the active task is deleted
                }
                _saveTasks();
              } else {
                // Update the master list using the original index
                tasks[originalIndex] = updatedTask;
                _saveTasks();
              }
            });
          },
        );
      },
    );
  }
}
