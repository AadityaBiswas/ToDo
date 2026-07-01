import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/pages/add_task.dart';
import 'package:todo/pages/fab.dart';
import 'package:todo/pages/todotile.dart';
import 'package:todo/theme/app_theme.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';

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
  bool micTapped = false;
  bool addTaskTapped = false;

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
    final size = MediaQuery.of(context).size;
    final scale = math.min(size.width / 440, size.height / 956);
    return Scaffold(
      backgroundColor: AppColors.bg,
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
            taskList(scale),
            Positioned(
              bottom: 40 * scale,
              left: 20 * scale,
              right: 20 * scale,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 113 * scale,
                    height: 54 * scale,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Color(0xFFE6E6E6),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF000000).withValues(alpha: 0.15),
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10 * scale,
                      vertical: 7 * scale,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          'assets/icon/progress.svg',
                          width: 40 * scale,
                          height: 40 * scale,
                        ),
                        SvgPicture.asset(
                          'assets/icon/dark_clock.svg',
                          width: 40 * scale,
                          height: 40 * scale,
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 113 * scale,
                    height: 54 * scale,
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              micTapped = !micTapped;
                            });
                          },
                          child: Container(
                            width: 50 * scale,
                            height: 50 * scale,
                            margin: EdgeInsets.only(top: micTapped ? 4 : 0),
                            decoration: BoxDecoration(
                              color: Color(0xFFE6E6E6),
                              borderRadius: BorderRadius.circular(16),
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xFFB3B3B3),
                                  width: micTapped ? 2 : 6,
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                ),
                                top: BorderSide(
                                  color: Color(0xFFB3B3B3),
                                  width: 2,
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                ),
                                left: BorderSide(
                                  color: Color(0xFFB3B3B3),
                                  width: 2,
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                ),
                                right: BorderSide(
                                  color: Color(0xFFB3B3B3),
                                  width: 2,
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                ),
                              ),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/icon/mic.svg',
                                width: 25 * scale,
                                height: 25 * scale,
                              ),
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              addTaskTapped = true;
                            });
                            await Future.delayed(
                              const Duration(milliseconds: 60),
                            );
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
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
                              await Future.delayed(
                                const Duration(milliseconds: 300),
                              );
                              if (!mounted) return;
                              setState(() {
                                addTaskTapped = false;
                              });
                              await Future.delayed(
                                const Duration(milliseconds: 80),
                              );
                              if (value != null) {
                                setState(() {
                                  tasks.add(Map<String, dynamic>.from(value));
                                  _saveTasks();
                                });
                              }
                            });
                          },
                          child: Container(
                            width: 50 * scale,
                            height: 50 * scale,
                            margin: EdgeInsets.only(top: addTaskTapped ? 4 : 0),
                            decoration: BoxDecoration(
                              color: Color(0xFFE6E6E6),
                              borderRadius: BorderRadius.circular(16),
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xFFB3B3B3),
                                  width: addTaskTapped ? 2 : 6,
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                ),
                                top: BorderSide(
                                  color: Color(0xFFB3B3B3),
                                  width: 2,
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                ),
                                left: BorderSide(
                                  color: Color(0xFFB3B3B3),
                                  width: 2,
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                ),
                                right: BorderSide(
                                  color: Color(0xFFB3B3B3),
                                  width: 2,
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                ),
                              ),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/icon/add.svg',
                                width: 25 * scale,
                                height: 25 * scale,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            //top app bar
            Positioned(
              top: 40 * scale,
              left: 20 * scale,
              right: 20 * scale,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 62 * scale,
                    height: 40 * scale,
                    decoration: BoxDecoration(
                      color: Color(0xFFE6E6E6),
                      borderRadius: BorderRadius.circular(124),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF000000).withValues(alpha: 0.15),
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(
                            'assets/icon/check.svg',
                            width: 20 * scale,
                            height: 20 * scale,
                          ),
                          Text(
                            "5",
                            style: TextStyle(
                              color: Color(0xFF4D4D4D),
                              fontSize: 20 * scale,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    width: 124 * scale,
                    height: 40 * scale,
                    decoration: BoxDecoration(
                      color: Color(0xFFE6E6E6),
                      borderRadius: BorderRadius.circular(124),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF000000).withValues(alpha: 0.15),
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(
                            'assets/icon/loading.svg',
                            width: 22 * scale,
                            height: 22 * scale,
                          ),
                          Text(
                            "1:30:00",
                            style: TextStyle(
                              color: Color(0xFF4D4D4D),
                              fontSize: 20 * scale,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    width: 94 * scale,
                    height: 40 * scale,
                    decoration: BoxDecoration(
                      color: Color(0xFFE6E6E6),
                      borderRadius: BorderRadius.circular(124),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF000000).withValues(alpha: 0.15),
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 38 * scale,
                            height: 40 * scale,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  'assets/icon/fire.svg',
                                  width: 22 * scale,
                                  height: 22 * scale,
                                ),
                                Text(
                                  "3",
                                  style: TextStyle(
                                    color: Color(0xFF4D4D4D),
                                    fontSize: 20 * scale,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/icon/settings.svg',
                            width: 22 * scale,
                            height: 22 * scale,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView taskList(double scale) {
    final DateTime now = DateTime.now();

    // CHANGED: Replaced 'todaysTasks' with two distinct lists for separation
    List<MapEntry<int, Map<String, dynamic>>> todaysHabits = [];
    List<MapEntry<int, Map<String, dynamic>>> todaysNormalTasks = [];

    for (int i = 0; i < tasks.length; i++) {
      final task = tasks[i];
      final int tDate = int.tryParse(task["date"]?.toString() ?? "0") ?? 0;
      final int tMonth = int.tryParse(task["month"]?.toString() ?? "0") ?? 0;
      final int tYear = int.tryParse(task["year"]?.toString() ?? "0") ?? 0;

      final bool isHabit = task["isHabit"] ?? false;
      final List<dynamic> habitDaysRaw =
          task["habitDays"] ?? List.filled(7, false);
      final List<bool> habitDays = habitDaysRaw.map((e) => e == true).toList();

      if (isHabit) {
        int currentDayIndex = now.weekday - 1;
        if (habitDays.length == 7 && habitDays[currentDayIndex]) {
          // CHANGED: Route habits specifically to the habits list
          todaysHabits.add(MapEntry(i, task));
        }
      } else {
        if (tDate == now.day && tMonth == now.month && tYear == now.year) {
          // CHANGED: Route standard tasks to the normal tasks list
          todaysNormalTasks.add(MapEntry(i, task));
        }
      }
    }

    // NEW: Extracted the ToDoTile building logic into a helper function so it can be used for both lists
    Widget buildTile(
      MapEntry<int, Map<String, dynamic>> entry,
      bool isHabitUI,
    ) {
      final int originalIndex = entry.key;
      final Map<String, dynamic> task = entry.value;
      final List<dynamic> habitDaysRaw =
          task["habitDays"] ?? List.filled(7, false);
      final List<bool> currentHabitDays = habitDaysRaw
          .map((e) => e == true)
          .toList();
      return Container(
        margin: EdgeInsets.only(bottom: 10 * scale),
        child: ToDoTile(
          taskName: task["name"]?.toString() ?? "0",
          taskHour: task["hour"]?.toString() ?? "0",
          taskMinute: task["minute"]?.toString() ?? "0",
          taskDate: task["date"]?.toString() ?? "0",
          taskMonth: task["month"]?.toString() ?? "0",
          taskYear: task["year"]?.toString() ?? "0",
          isCompleted: task["isCompleted"] ?? false,
          isHighPriority: task["isHighPriority"] ?? false,

          // NEW: Pass the boolean down so the Tile knows how to style itself
          isHabit: isHabitUI,
          habitDays: currentHabitDays,
          isTimerActive: activeTimerIndex == originalIndex,
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
                tasks.removeAt(originalIndex);
                if (activeTimerIndex == originalIndex) {
                  activeTimerIndex = null;
                }
                _saveTasks();
              } else {
                tasks[originalIndex] = updatedTask;
                _saveTasks();
              }
            });
          },
        ),
      );
    }

    // CHANGED: Replaced ListView.builder with a standard ListView to accommodate headers and sections
    return ListView(
      padding: EdgeInsets.only(
        top: 100 * scale,
        left: 20 * scale,
        right: 20 * scale,
        bottom:
            120 *
            scale, // Added bottom padding so the FAB/menu doesn't cover the bottom items
      ),
      children: [
        if (todaysHabits.isNotEmpty) ...[
          ...List.generate((todaysHabits.length / 2).ceil(), (index) {
            int firstIndex = index * 2;
            int secondIndex = firstIndex + 1;

            return Padding(
              padding: EdgeInsets.only(bottom: 10 * scale),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: buildTile(todaysHabits[firstIndex], true)),
                  SizedBox(width: 12 * scale),
                  Expanded(
                    child: secondIndex < todaysHabits.length
                        ? buildTile(todaysHabits[secondIndex], true)
                        : SizedBox(),
                  ),
                ],
              ),
            );
          }),

          SizedBox(height: 4 * scale),
        ],

        if (todaysNormalTasks.isNotEmpty) ...[
          ...todaysNormalTasks.map((entry) => buildTile(entry, false)),
        ],

        if (todaysHabits.isEmpty && todaysNormalTasks.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: 40 * scale),
            child: Center(
              child: Text(
                "Nothing scheduled for today",
                style: TextStyle(
                  color: Color(0xFF999999),
                  fontSize: 16 * scale,
                  fontFamily: "Hanken_Grotesk",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
