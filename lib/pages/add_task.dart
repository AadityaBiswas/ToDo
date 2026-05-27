import 'package:flutter/material.dart';
import 'package:todo/theme/app_theme.dart';
import 'category_selector.dart';
import 'scheduling_section.dart';

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
  bool saveClicked = false;
  // int selectedCategory = -1;
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
    return Container(
      height: 320,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF151518),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: Colors.white.withAlpha(24), width: 1),
          left: BorderSide(color: Colors.white.withAlpha(24), width: 1),
        ),
      ),
      child: Column(
        children: [
          dragHandle(),
          taskName(),

          // CategorySelector(
          //   selectedCategory: selectedCategory,
          //   onCategorySelected: (newIndex) {
          //     setState(() {
          //       selectedCategory = newIndex;
          //     });
          //   },
          // ),
          SchedulingSection(
            selectedDate: selectedDate,
            selectedMonth: selectedMonth,
            selectedYear: selectedYear,
            selectedHour: selectedHour,
            selectedMinute: selectedMinute,
            dateTapped: dateTapped,
            timeTapped: timeTapped,
            onDateToggled: (newValue) {
              setState(() {
                dateTapped = newValue;
              });
            },
            onDateSelected: ((date, month, year) {
              setState(() {
                selectedDate = date;
                selectedMonth = month.toString();
                selectedYear = year.toString();
                dateTapped = true;
              });
            }),
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
          saveTaskButton(context),
        ],
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
          Navigator.pop(context, (
            name: taskText,
            hour: selectedHour,
            minute: selectedMinute,
            date: selectedDate,
            month: selectedMonth.toString(),
            year: selectedYear.toString(),
          ));
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
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 16),
            height: saveClicked ? 0 : 70,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(64),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: saveClicked ? 18 : 16),
            height: 64,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: saveClicked ? AppColors.secondaryText : Colors.white,
              borderRadius: BorderRadius.circular(64),
            ),
            child: Center(
              child: Text(
                "Save Task",
                style: TextStyle(
                  fontFamily: "HankenGrostek",
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: saveClicked ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dragHandle() {
    return Container(
      width: 48,
      height: 5,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(80),
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }

  Widget taskName() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF111216).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          top: BorderSide(color: Colors.black, width: 3),
          left: BorderSide(color: Colors.black, width: 3),
          bottom: BorderSide(color: Colors.black, width: 0.5),
          right: BorderSide(color: Colors.black, width: 0.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: TextField(
          controller: _taskName,
          cursorColor: Colors.white60,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: "What needs to be done",
            hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
