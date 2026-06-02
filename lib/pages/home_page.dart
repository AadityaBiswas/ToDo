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

  bool fabTapped = false;
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
                      tasks.insert(0, newTask);
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
    return ListView.builder(
      itemCount: tasks.length,
      padding: const EdgeInsets.only(top: 52, left: 20, right: 20, bottom: 52),
      itemBuilder: (context, index) {
        final task = tasks[index];

        return ToDoTile(
          taskName: task["name"] ?? "0",
          taskHour: task["hour"] ?? "0",
          taskMinute: task["minute"] ?? "0",
          taskDate: task["date"] ?? "0",
          taskMonth: task["month"] ?? "0",
          taskYear: task["year"] ?? "0",
          isCompleted: task["isCompleted"] ?? false,
          isTimerActive: activeTimerIndex == index,
          onTimerTap: () {
            setState(() {
              fabTapped = false;
              if (activeTimerIndex == index) {
                activeTimerIndex = null;
              } else {
                activeTimerIndex = index;
              }
            });
          },
          onEditedTask: (updatedTask) {
            setState(() {
              fabTapped = false;
              if (updatedTask['delete'] == true) {
                tasks.removeAt(index);
              } else {
                tasks[index] = updatedTask;
                _saveTasks();
              }
            });
          },
        );
      },
    );
  }
}
