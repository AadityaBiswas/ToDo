// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:todo/pages/add_task.dart';
import 'package:todo/theme/app_theme.dart';

class ToDoTile extends StatefulWidget {
  final String taskName;
  final String taskHour;
  final String taskMinute;
  final String taskDate;
  final String taskMonth;
  final String taskYear;
  final void Function(
    ({
      String name,
      String hour,
      String minute,
      String date,
      String month,
      String year,
    }),
  )
  onEditedTask;
  const ToDoTile({
    super.key,
    required this.taskName,
    required this.taskHour,
    required this.taskMinute,
    required this.taskDate,
    required this.taskMonth,
    required this.taskYear,
    required this.onEditedTask,
  });
  @override
  State<ToDoTile> createState() => _ToDoTileState();
}

class _ToDoTileState extends State<ToDoTile> {
  bool editTask = false;
  String result = "";
  bool isCompleted = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        setState(() {
          editTask = true;
        });
        final result = await showModalBottomSheet(
          context: context,
          builder: (context) {
            return AddTask(
              editTask: editTask,
              taskName: widget.taskName,
              taskHour: widget.taskHour,
              taskMinute: widget.taskMinute,
              taskDate: widget.taskDate,
              taskMonth: widget.taskMonth,
              taskYear: widget.taskYear,
            );
          },
        );
        if (result != null) {
          widget.onEditedTask(result);
        }
        setState(() {
          editTask = false;
        });
      },
      onTap: () {
        setState(() {
          isCompleted = !isCompleted;
        });
      },
      child: SizedBox(
        height: 74,
        child: Stack(children: [bottomContainer(), topContainer()]),
      ),
    );
  }

  Container topContainer() {
    return Container(
      margin: EdgeInsets.only(top: isCompleted ? 6 : 0),
      padding: EdgeInsets.all(16),
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: isCompleted ? completedBorder() : defaultBorder(),
        gradient: isCompleted ? null : defaultGradient(),
        color: isCompleted ? Color(0xFF111216).withOpacity(0.2) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildTaskName(),
          if (!(widget.taskHour == "0" && widget.taskMinute == "0"))
            Row(children: [SizedBox(width: 4), timeAllocated()]),
        ],
      ),
    );
  }

  Text buildTaskName() {
    return Text(
      widget.taskName,
      style: AppTextStyles.taskTitle.copyWith(
        color: isCompleted ? AppColors.completedText : AppColors.activeText,
      ),
    );
  }

  Text timeAllocated() {
    return Text(
      widget.taskHour == "0" && widget.taskMinute == "0"
          ? ""
          : widget.taskHour == "0"
          ? "${widget.taskMinute}m"
          : widget.taskMinute == "0"
          ? "${widget.taskHour}h"
          : "${widget.taskHour}h ${widget.taskMinute}m",
      style: AppTextStyles.taskTime.copyWith(
        color: isCompleted ? AppColors.completedText : AppColors.secondaryText,
      ),
    );
  }

  LinearGradient defaultGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF535459), Color(0xFF494A4E), Color(0xFF414247)],
    );
  }

  Border defaultBorder() {
    return Border(
      top: BorderSide(color: Colors.white.withAlpha(48), width: 1.5),
      left: BorderSide(color: Colors.white.withAlpha(48), width: 1.5),
    );
  }

  Border completedBorder() {
    return Border(
      top: BorderSide(color: Colors.black, width: 3),
      left: BorderSide(color: Colors.black, width: 3),
      bottom: BorderSide(color: Colors.black, width: 0.5),
      right: BorderSide(color: Colors.black, width: 0.5),
    );
  }

  Container bottomContainer() {
    return Container(
      width: double.infinity,
      height: isCompleted ? 0 : 66,
      decoration: BoxDecoration(
        color: AppColors.tileBottom,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
