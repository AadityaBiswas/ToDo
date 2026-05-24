// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:todo/theme/app_theme.dart';

class ToDoTile extends StatefulWidget {
  final String taskName;
  final String taskHour;
  final String taskMinute;
  const ToDoTile({
    super.key,
    required this.taskName,
    required this.taskHour,
    required this.taskMinute,
  });
  @override
  State<ToDoTile> createState() => _ToDoTileState();
}

class _ToDoTileState extends State<ToDoTile> {
  String result = "";
  bool isCompleted = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isCompleted = !isCompleted;
        });
      },
      child: Stack(children: [bottomContainer(), topContainer()]),
    );
  }

  Container topContainer() {
    return Container(
      margin: EdgeInsets.only(top: isCompleted ? 6 : 0, bottom: 8),
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
    if (isCompleted) {
      return Container();
    } else {
      return Container(
        width: double.infinity,
        height: 66,
        decoration: BoxDecoration(
          color: AppColors.tileBottom,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.only(bottom: 8),
      );
    }
  }
}
