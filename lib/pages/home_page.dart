import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/pages/add_task.dart';
import 'package:todo/pages/todotile.dart';
import 'package:todo/theme/app_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final taskData = Hive.box("Tasks");

  List<Map<String, dynamic>> tasks = [];
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
      backgroundColor: AppColors.background,
      body: Stack(children: [taskList(), floatingActionButton(context)]),
    );
  }

  ListView taskList() {
    return ListView.builder(
      itemCount: tasks.length,
      padding: const EdgeInsets.only(top: 48, left: 20, right: 20, bottom: 48),
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
          onEditedTask: (updatedTask) {
            setState(() {
              tasks[index] = updatedTask;
              _saveTasks();
            });
          },
        );
      },
    );
  }

  Positioned floatingActionButton(BuildContext context) {
    return Positioned(
      bottom: 30,
      left: 0,
      right: 0,
      child: Center(
        child: SizedBox(
          height: 72,
          width: 64,
          child: GestureDetector(
            onTap: () {
              setState(() {
                fabTapped = true;
              });
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return const AddTask(
                    editTask: false,
                    taskName: "0",
                    taskHour: "0",
                    taskMinute: "0",
                    taskDate: "0",
                    taskMonth: "0",
                    taskYear: "0",
                  );
                },
              ).then((value) {
                setState(() {
                  fabTapped = false;
                  if (value != null) {
                    tasks.add(Map<String, dynamic>.from(value));
                    _saveTasks();
                  }
                });
              });
            },
            child: Stack(
              children: [
                Container(
                  width: 64,
                  height: fabTapped ? 0 : 68,
                  margin: EdgeInsets.only(top: fabTapped ? 8 : 0),
                  decoration: BoxDecoration(
                    color: AppColors.tileBottom,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                Container(
                  height: 64,
                  width: 64,
                  margin: EdgeInsets.only(top: fabTapped ? 8 : 0),
                  decoration: BoxDecoration(
                    gradient: fabTapped
                        ? null
                        : const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF9A9BA2),
                              Color(0xFF85868D),
                              Color(0xFF707178),
                            ],
                          ),
                    shape: BoxShape.circle,
                    color: fabTapped
                        ? Color(0xFF111216).withOpacity(0.2)
                        : null,
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    color: fabTapped ? AppColors.secondaryText : Colors.white,
                    size: 40,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
