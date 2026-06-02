import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:hive/hive.dart';
import 'package:todo/theme/app_theme.dart';
import 'scheduling_section.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class AddTask extends StatefulWidget {
  final bool editTask;
  final String taskName;
  final String taskHour;
  final String taskMinute;
  final String taskDate;
  final String taskMonth;
  final String taskYear;
  const AddTask({
    super.key,
    required this.editTask,
    required this.taskName,
    required this.taskHour,
    required this.taskMinute,
    required this.taskDate,
    required this.taskMonth,
    required this.taskYear,
  });

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  late TextEditingController _taskName;
  bool highPriority = false;
  bool saveClicked = false;
  bool dateTapped = true;
  bool timeTapped = false;
  late String selectedHour;
  late String selectedMinute;
  late String selectedDate;
  late String selectedMonth;
  late String selectedYear;
  @override
  void initState() {
    super.initState();
    _taskName = widget.taskName == "0"
        ? TextEditingController()
        : TextEditingController(text: widget.taskName);
    selectedHour = widget.taskHour == "0" ? "0" : widget.taskHour;
    selectedMinute = widget.taskMinute == "0" ? "0" : widget.taskMinute;
    selectedDate = widget.editTask
        ? widget.taskDate
        : DateTime.now().day.toString();
    selectedMonth = widget.editTask
        ? widget.taskMonth
        : DateTime.now().month.toString();
    selectedYear = widget.editTask
        ? widget.taskYear
        : DateTime.now().year.toString();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(
        bottom: keyboardHeight > 0 ? keyboardHeight + 20 : 0,
      ),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 160,
              width: screenWidth - 20,
              margin: EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFBFBFBF),
                borderRadius: const BorderRadius.all(Radius.circular(18)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF4D4D4D).withValues(alpha: 0.9),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
            Container(
              height: 160,
              width: screenWidth - 20,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE6E6E6),
                borderRadius: const BorderRadius.all(Radius.circular(18)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF4D4D4D).withValues(alpha: 0.10),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  taskName(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        height: 52,
                        width: 190,
                        decoration: BoxDecoration(
                          color: Color(0xFFBFBFBF),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 6,
                              inset: true,
                              offset: Offset(0, 3),
                            ),
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.25),
                              blurRadius: 4,
                              inset: true,
                              offset: Offset(0, -1),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  highPriority = !highPriority;
                                });
                                await Future.delayed(
                                  Duration(milliseconds: 350),
                                );
                                setState(() {
                                  highPriority = false;
                                });
                              },
                              child: Stack(
                                children: [
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 50),
                                    height: 32,
                                    width: 78,
                                    margin: EdgeInsets.only(top: 4),
                                    decoration: BoxDecoration(
                                      color: highPriority
                                          ? Color(
                                              0xFFBFBFBF,
                                            ).withValues(alpha: 0)
                                          : Color(0xFFBFBFBF),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(
                                            0xFF333333,
                                          ).withValues(alpha: 0.25),
                                          blurRadius: 2,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 80),
                                    curve: Curves.easeInOutCubic,
                                    height: 32,
                                    width: 78,
                                    margin: EdgeInsets.only(
                                      top: highPriority ? 4 : 0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: highPriority
                                          ? Color(0xFFB3B3B3)
                                          : Color(0xFFD9D9D9),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: highPriority
                                          ? [
                                              BoxShadow(
                                                color: const Color(
                                                  0xFF404040,
                                                ).withOpacity(0.3),
                                                blurRadius: 4,
                                                inset: true,
                                                offset: const Offset(0, 2),
                                              ),
                                              BoxShadow(
                                                color: const Color(
                                                  0xFFE5E5E5,
                                                ).withOpacity(0.2),
                                                blurRadius: 2,
                                                inset: true,
                                                offset: const Offset(0, -1),
                                              ),
                                            ]
                                          : [
                                              BoxShadow(
                                                color: Color(
                                                  0xFF999999,
                                                ).withValues(alpha: 0.25),
                                                blurRadius: 4,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        top: highPriority ? 4 : 0,
                                      ),
                                      child: Text(
                                        "High Priority",
                                        style: TextStyle(
                                          color: highPriority
                                              ? Color(0xFFD9D9D9)
                                              : Color(0xFF4D4D4D),
                                          fontFamily: "Hanken_Grotesk",
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SchedulingSection(
                              // selectedDate: selectedDate,
                              // selectedMonth: selectedMonth,
                              // selectedYear: selectedYear,
                              selectedHour: selectedHour,
                              selectedMinute: selectedMinute,
                              // dateTapped: dateTapped,
                              timeTapped: timeTapped,
                              // onDateToggled: (newValue) {
                              //   setState(() {
                              //     dateTapped = newValue;
                              //   });
                              // },
                              // onDateSelected: ((date, month, year) {
                              //   setState(() {
                              //     selectedDate = date;
                              //     selectedMonth = month.toString();
                              //     selectedYear = year.toString();
                              //     dateTapped = true;
                              //   });
                              // }),
                              onTimeToggled: (newValue) {
                                setState(() {
                                  timeTapped = newValue;
                                });
                              },
                              onTimeSelected: ((hour, minute) {
                                setState(() {
                                  selectedHour = hour;
                                  selectedMinute = minute;
                                  timeTapped = true;
                                });
                              }),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 46,
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            deleteTask(context),
                            saveTaskButton(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector saveTaskButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        String taskText = _taskName.text.trim();
        if (taskText.isNotEmpty) {
          setState(() {
            saveClicked = true;
          });
          Navigator.pop(context, {
            'name': taskText,
            'hour': selectedHour,
            'minute': selectedMinute,
            'date': selectedDate,
            'month': selectedMonth.toString(),
            'year': selectedYear.toString(),
            'isCompleted': false,
          });
        } else {
          setState(() {
            saveClicked = true;
          });
          await Future.delayed(const Duration(milliseconds: 150));
          setState(() {
            saveClicked = false;
          });
        }
      },
      child: Container(
        height: 46,
        width: 46,
        decoration: BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.35),
              blurRadius: 6,
              inset: true,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Icon(Icons.arrow_upward, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  GestureDetector deleteTask(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, {'delete': true});
      },
      child: Container(
        height: 46,
        width: 46,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.35),
              blurRadius: 6,
              inset: true,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Center(child: Icon(Icons.delete, color: Colors.white, size: 20)),
      ),
    );
  }

  Widget taskName() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 60,
      width: 380,

      decoration: BoxDecoration(
        color: const Color(0xFFB3B3B3),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 6,
            inset: true,
            offset: Offset(0, 3),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0),
            blurRadius: 4,
            inset: true,
            offset: Offset(0, -1),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: TextField(
          autofocus: widget.editTask ? false : true,
          controller: _taskName,
          cursorColor: Colors.black,
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: "What's to be done?",
            hintStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF595959),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
