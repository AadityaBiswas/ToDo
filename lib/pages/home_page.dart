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
            height: 55,
            decoration: BoxDecoration(
              color: AppColors.bgBottomBar,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFA6A6A6).withOpacity(0.02),
                  inset: true,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                  spreadRadius: -2,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
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

  Widget floatingActionButton(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: GestureDetector(
        onTap: () async {
          setState(() {
            fabTapped = !fabTapped;
          });
          await Future.delayed(const Duration(milliseconds: 60));
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
          ).then((value) async {
            await Future.delayed(const Duration(milliseconds: 400));
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
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: 80,
              height: 80,
              margin: EdgeInsets.only(top: 8),
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
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Color(0xFF404040),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            Container(
              height: 64,
              width: 64,
              margin: EdgeInsets.only(top: fabTapped ? 16 : 0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: fabTapped ? AppColors.bgLighter : Color(0xFF666666),
                boxShadow: fabTapped
                    ? [
                        BoxShadow(
                          color: Color.fromARGB(
                            255,
                            122,
                            122,
                            122,
                          ).withOpacity(0.1),
                          blurRadius: 4.5,
                          inset: true,
                          offset: Offset(0, -3),
                        ),
                        BoxShadow(
                          color: Color(0xFF0d0d0d).withOpacity(0.16),
                          blurRadius: 5,
                          inset: true,
                          offset: Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                Icons.add_rounded,
                color: fabTapped ? AppColors.secondaryText : Colors.white,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
