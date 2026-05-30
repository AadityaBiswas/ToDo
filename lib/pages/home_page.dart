import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/pages/add_task.dart';
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
      body: Stack(children: [taskList(), navBar(context)]),
    );
  }

  Widget navBar(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: EdgeInsets.only(top: 70),
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.bgBottomBar,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFA6A6A6).withOpacity(0.05),
                  inset: true,
                  offset: Offset(0, 3),
                  spreadRadius: -3,
                  blurRadius: 5,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: floatingActionButton(context),
          ),
        ],
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
      bottom: 40,
      left: 0,
      right: 0,
      child: Center(
        child: SizedBox(
          height: 100,
          width: 100,
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
              alignment: Alignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  margin: EdgeInsets.only(top: 25),
                  decoration: BoxDecoration(
                    color: AppColors.bgBottomBar,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFA6A6A6).withOpacity(0.05),
                        inset: true,
                        offset: Offset(0, 3),
                        spreadRadius: -3,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 64,
                  height: fabTapped ? 0 : 64,
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFF404040),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                Container(
                  height: 64,
                  width: 64,
                  margin: EdgeInsets.only(top: fabTapped ? 8 : 0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: fabTapped
                        ? Color(0xFF111216).withOpacity(0.2)
                        : Color(0xFF666666),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFB2B2B2).withOpacity(0.25),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                        inset: true,
                      ),
                      BoxShadow(
                        color: Color(0xFF333333).withOpacity(0.25),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      ),
                      BoxShadow(
                        color: Color(0xFF3D3D3D).withOpacity(0.25),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    color: fabTapped ? AppColors.secondaryText : Colors.white,
                    size: 32,
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
