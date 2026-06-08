import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:hive/hive.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
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
  bool saveIconColorChange = false;
  bool taskBorderError = false;
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
        bottom: keyboardHeight > 0 ? keyboardHeight + 20 : 30,
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
                        height: 56,
                        width: 100,
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
                            SchedulingSection(
                              selectedHour: selectedHour,
                              selectedMinute: selectedMinute,
                              timeTapped: timeTapped,
                              isEditing: widget.editTask,
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
                            widget.editTask ? deleteTask() : SizedBox(),
                            saveTaskButton(),
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

  GestureDetector saveTaskButton() {
    return GestureDetector(
      onTap: () async {
        String taskText = _taskName.text.trim();
        if (taskText.isNotEmpty) {
          setState(() {
            saveClicked = true;
          });
          await Posthog().capture(eventName: "Task Addded");
          if (!mounted) return;
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
            taskBorderError = true;
            saveIconColorChange = true;
          });
          await Future.delayed(const Duration(milliseconds: 200));
          setState(() {
            saveIconColorChange = false;
          });
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 80),
        height: 46,
        width: 46,
        decoration: BoxDecoration(
          color: saveIconColorChange ? Colors.red : Color(0xFF1A1A1A),
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

  GestureDetector deleteTask() {
    return GestureDetector(
      onTap: () async {
        await Posthog().capture(eventName: "Task deleted");
        if (!mounted) return;
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
    return AnimatedContainer(
      duration: Duration(milliseconds: 80),
      margin: const EdgeInsets.only(bottom: 8),
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
        border: Border.all(
          color: taskBorderError ? Colors.red : Colors.transparent,
          width: 2,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: TextField(
          maxLength: 30,
          buildCounter:
              (
                context, {
                required currentLength,
                required isFocused,
                maxLength,
              }) => null,
          onChanged: (value) {
            if (value.isNotEmpty) {
              if (taskBorderError) {
                setState(() {
                  taskBorderError = false;
                });
              }
            }
          },
          autofocus: widget.editTask ? false : true,
          controller: _taskName,
          cursorColor: taskBorderError ? Colors.red : Colors.black,
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: taskBorderError
                ? "Enter task name to save"
                : "What's to be done?",
            hintStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: taskBorderError
                  ? Colors.red.withValues(alpha: 0.5)
                  : Color(0xFF595959),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
