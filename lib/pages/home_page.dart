import 'package:flutter/material.dart';
import 'package:todo/pages/add_task.dart';
import 'package:todo/pages/todotile.dart';
import 'package:todo/theme/app_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<({String name, String hour, String minute})> tasks = [];
  bool fabTapped = false;
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
          taskName: task.name,
          taskHour: task.hour,
          taskMinute: task.minute,
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
                  return const AddTask();
                },
              ).then((value) {
                setState(() {
                  fabTapped = false;
                  if (value != null) {
                    tasks.add(value);
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
