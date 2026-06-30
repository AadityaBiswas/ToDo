import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:hive/hive.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:todo/pages/add_habit.dart';
import 'package:todo/pages/date_allocation.dart';
import 'package:todo/theme/app_theme.dart';
import 'scheduling_section.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

class AddTask extends StatefulWidget {
  final bool editTask;
  final String taskName;
  final String taskHour;
  final String taskMinute;
  final String taskDate;
  final String taskMonth;
  final String taskYear;
  final bool isHighPriority;
  const AddTask({
    super.key,
    required this.editTask,
    required this.taskName,
    required this.taskHour,
    required this.taskMinute,
    required this.taskDate,
    required this.taskMonth,
    required this.taskYear,
    this.isHighPriority = false,
  });

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  List<bool> showHabitDays = List.filled(7, false);
  bool tapOnceHabit = false;
  bool repeatSelected = false;
  DateTime dateTimeSelectedDate = DateTime.now();
  late TextEditingController _taskName;
  bool saveIconColorChange = false;
  bool taskBorderError = false;
  bool saveClicked = false;
  bool dateTapped = true;
  bool timeTapped = false;
  bool dateSelected = false;
  late String selectedHour;
  late String selectedMinute;
  late String selectedDate;
  late String selectedMonth;
  late String selectedYear;
  late bool priority;
  bool tapOncePriority = false;
  bool priorityTapped = false;
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
    priority = widget.isHighPriority;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = math.min(size.width / 440, size.height / 956);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight > 0 ? keyboardHeight : 0),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 134 * scale,
              width: screenWidth,
              padding: const EdgeInsets.only(
                top: 14,
                right: 10,
                left: 10,
                bottom: 12,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF000000).withValues(alpha: 0.10),
                    blurRadius: 4,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  taskName(scale),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Row(
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
                            priorityButton(scale),
                            dateSelectionButton(context, scale),
                            HabitButton(context, scale),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 50,
                        width: 110,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.editTask ? deleteTask(scale) : SizedBox(),
                            saveTaskButton(scale),
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

  GestureDetector HabitButton(BuildContext context, double scale) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          tapOnceHabit = true;
        });
        await Future.delayed(Duration(milliseconds: 80));
        final result = await showModalBottomSheet<Map<String, dynamic>>(
          context: context,
          isScrollControlled: true,
          builder: (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: AddHabit(
              habitName: _taskName.text.trim(),
              showHabitDays: showHabitDays,
            ),
          ),
        );
        setState(() {
          if (result != null) {
            repeatSelected = result["habitCreated"];
            _taskName.text = result["name"];
            showHabitDays = result["datesToShow"];
          }
        });
        await Future.delayed(Duration(milliseconds: 200));
        setState(() {
          tapOnceHabit = false;
        });
      },
      child: Transform.translate(
        offset: Offset(0, tapOnceHabit ? 4 : 0),
        child: Container(
          margin: EdgeInsets.only(left: 8),
          width: 84 * scale,
          height: 45 * scale,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(8),
            border: Border(
              top: BorderSide(
                color: repeatSelected ? Color(0xFFC0C0C0) : Color(0xFFE0E0E0),
                width: 2,
              ),
              right: BorderSide(
                color: repeatSelected ? Color(0xFFC0C0C0) : Color(0xFFE0E0E0),
                width: 2,
              ),
              left: BorderSide(
                color: repeatSelected ? Color(0xFFC0C0C0) : Color(0xFFE0E0E0),
                width: 2,
              ),
              bottom: BorderSide(
                color: repeatSelected ? Color(0xFFC0C0C0) : Color(0xFFE0E0E0),
                width: tapOnceHabit ? 2 : 6,
              ),
            ),
          ),
          child: Row(
            children: [
              SizedBox(width: 2),
              repeatSelected
                  ? SvgPicture.asset(
                      'assets/icon/repeatSelected.svg',
                      width: 30 * scale,
                      height: 30 * scale,
                    )
                  : SvgPicture.asset(
                      'assets/icon/repeatUnselected.svg',
                      width: 30 * scale,
                      height: 30 * scale,
                    ),
              Text(
                "Habit",
                style: TextStyle(
                  color: repeatSelected ? Color(0xFF333333) : Color(0xFF808080),
                  fontSize: 16 * scale,
                  fontWeight: FontWeight.w800,
                  fontFamily: "Hanken_Grotesk",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector dateSelectionButton(BuildContext context, double scale) {
    return GestureDetector(
      onTap: () async {
        final result =
            await showModalBottomSheet<
              ({
                String date,
                String month,
                String year,
                bool isSelected,
                DateTime selectedDateFromChild,
              })
            >(
              context: context,
              isScrollControlled: true,
              builder: (context) => Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Wrap(
                  children: [
                    DateAllocation(
                      selectedDateFromParent: dateTimeSelectedDate,
                    ),
                  ],
                ),
              ),
            );
        if (result != null) {
          selectedDate = result.date;
          selectedMonth = result.month;
          selectedYear = result.year;
          setState(() {
            dateSelected = result.isSelected;
          });
          dateTimeSelectedDate = result.selectedDateFromChild;
        }
      },
      child: Container(
        height: 45 * scale,
        width: dateSelected ? 102 * scale : 95 * scale,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(8),
          border: Border(
            top: BorderSide(
              color: dateSelected ? Color(0xFFC0C0C0) : Color(0xFFE0E0E0),
              width: 2,
            ),
            right: BorderSide(
              color: dateSelected ? Color(0xFFC0C0C0) : Color(0xFFE0E0E0),
              width: 2,
            ),
            left: BorderSide(
              color: dateSelected ? Color(0xFFC0C0C0) : Color(0xFFE0E0E0),
              width: 2,
            ),
            bottom: BorderSide(
              color: dateSelected ? Color(0xFFC0C0C0) : Color(0xFFE0E0E0),
              width: 6,
            ),
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 2),
            dateSelected
                ? SvgPicture.asset(
                    'assets/icon/selectedDate.svg',
                    width: 32 * scale,
                    height: 32 * scale,
                  )
                : SvgPicture.asset(
                    'assets/icon/calendarLightLight.svg',
                    width: 32 * scale,
                    height: 32 * scale,
                  ),
            SizedBox(width: dateSelected ? 6 : 2),

            dateSelected
                ? SizedBox(
                    child: Row(
                      children: [
                        Text(
                          selectedMonth,
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 16 * scale,
                            fontWeight: FontWeight.w800,
                            fontFamily: "Hanken_Grotesk",
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          selectedDate,
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 16 * scale,
                            fontWeight: FontWeight.w800,
                            fontFamily: "Hanken_Grotesk",
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    child: Text(
                      "Today",
                      style: TextStyle(
                        color: Color(0xFF808080),
                        fontSize: 16 * scale,
                        fontWeight: FontWeight.w800,
                        fontFamily: "Hanken_Grotesk",
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  GestureDetector priorityButton(double scale) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          priorityTapped = true;
        });
        await Duration(milliseconds: 100);
        setState(() {
          tapOncePriority = true;
        });
        await Duration(milliseconds: 100);
        setState(() {
          tapOncePriority = false;
        });
        setState(() {
          priority = !priority;
        });
      },
      child: Container(
        margin: EdgeInsets.only(
          top: tapOncePriority ? 4 : 0,
          left: 8,
          right: 8,
        ),
        height: 45 * scale,
        width: 45 * scale,
        decoration: BoxDecoration(
          color: priority ? Color(0xFF333333) : Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(8),
          border: Border(
            top: BorderSide(
              color: priority ? Color(0xFF262626) : Color(0xFFE0E0E0),
              width: 2,
            ),
            right: BorderSide(
              color: priority ? Color(0xFF262626) : Color(0xFFE0E0E0),
              width: 2,
            ),
            left: BorderSide(
              color: priority ? Color(0xFF262626) : Color(0xFFE0E0E0),
              width: 2,
            ),
            bottom: BorderSide(
              color: priority ? Color(0xFF262626) : Color(0xFFE0E0E0),
              width: tapOncePriority ? 2 : 6,
            ),
          ),
        ),
        child: Icon(
          Icons.outlined_flag_rounded,
          color: priority ? Colors.red : Color(0xFF808080),
          fill: priority ? 1 : 0,
          size: 32 * scale,
        ),
      ),
    );
  }

  GestureDetector saveTaskButton(double scale) {
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
            'isHighPriority': priority,
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
        height: 45 * scale,
        width: 45 * scale,
        decoration: BoxDecoration(
          color: saveIconColorChange ? Colors.red : Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Icon(Icons.arrow_upward, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  GestureDetector deleteTask(double scale) {
    return GestureDetector(
      onTap: () async {
        await Posthog().capture(eventName: "Task deleted");
        if (!mounted) return;
        Navigator.pop(context, {'delete': true});
      },
      child: Container(
        height: 40 * scale,
        width: 40 * scale,
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

  Widget taskName(double scale) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 80),
      margin: const EdgeInsets.only(bottom: 8),
      height: 50 * scale,
      width: 416 * scale,

      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 4,
            inset: true,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: taskBorderError ? Colors.red : Color(0xFFCCCCCC),
          width: 2,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Padding(
        padding: EdgeInsets.only(top: 2),
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
          cursorColor: taskBorderError ? Colors.red : Color(0xFF999999),
          style: TextStyle(
            color: Color(0xFF464545),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: taskBorderError
                ? "Enter task name to save"
                : "What's to be done?",
            hintStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: taskBorderError
                  ? Colors.red.withValues(alpha: 0.5)
                  : Color(0xFF999999),
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
