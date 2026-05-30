import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:todo/pages/add_task.dart';
import 'package:todo/theme/app_theme.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class ToDoTile extends StatefulWidget {
  final String taskName;
  final String taskHour;
  final String taskMinute;
  final String taskDate;
  final String taskMonth;
  final String taskYear;
  final bool isCompleted;
  final void Function(Map<String, dynamic>) onEditedTask;
  const ToDoTile({
    super.key,
    required this.isCompleted,
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
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
        Map<String, dynamic> updatedTask = {
          'name': widget.taskName,
          'hour': widget.taskHour,
          'minute': widget.taskMinute,
          'date': widget.taskDate,
          'month': widget.taskMonth,
          'year': widget.taskYear,
          'isCompleted': !widget.isCompleted,
        };
        widget.onEditedTask(updatedTask);
      },
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          base(screenWidth),
          bottomContainer(screenWidth),
          topContainer(screenWidth),
        ],
      ),
    );
  }

  Container base(double screenWidth) {
    return Container(
      margin: EdgeInsets.only(top: 14, bottom: 5),
      height: 64,
      width: screenWidth - 40 - 15,
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Container bottomContainer(double screenWidth) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      width: screenWidth - 40 - 20,
      height: widget.isCompleted ? 0 : 60,
      decoration: BoxDecoration(
        color: AppColors.bgLighter,
        borderRadius: BorderRadius.circular(16),
        boxShadow: widget.isCompleted ? null : defaultBoxShadowBottomTile(),
      ),
    );
  }

  Container topContainer(double screenWidth) {
    return Container(
      margin: EdgeInsets.only(top: widget.isCompleted ? 16 : 0),
      padding: EdgeInsets.all(16),
      width: screenWidth - 40 - 20,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        // gradient: widget.isCompleted ? null : defaultGradient(),
        boxShadow: widget.isCompleted
            ? completedBoxShadowTopTile()
            : defaultBoxShadowTopTile(),
        color: widget.isCompleted
            ? AppColors.bgCompleted
            : AppColors.bgLightest,
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
        color: widget.isCompleted
            ? AppColors.inactiveText
            : AppColors.activeText,
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
        color: widget.isCompleted
            ? AppColors.inactiveText
            : AppColors.secondaryText,
      ),
    );
  }

  List<BoxShadow> defaultBoxShadowBottomTile() {
    return [
      BoxShadow(
        color: Color(0xFF0A0A0A).withOpacity(0.25),
        spreadRadius: 2,
        blurRadius: 4,
        offset: Offset(0, 4),
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.25),
        blurRadius: 4,
        offset: Offset(0, 4),
      ),
    ];
  }

  List<BoxShadow> defaultBoxShadowTopTile() {
    return [
      BoxShadow(
        color: Color(0xFF999999).withOpacity(0.20),
        blurRadius: 8,
        inset: true,
        offset: Offset(0, 6),
      ),
      BoxShadow(
        color: Color(0xFF262626).withOpacity(0.25),
        spreadRadius: 2,
        blurRadius: 4,
        offset: Offset(0, 4),
      ),
      BoxShadow(
        color: Color(0xFF1A1A1A).withOpacity(0.25),
        blurRadius: 4,
        offset: Offset(0, 4),
      ),
    ];
  }

  List<BoxShadow> completedBoxShadowTopTile() {
    return [
      BoxShadow(
        color: Color(0xFF0d0d0d).withOpacity(0.18),
        blurRadius: 6,
        inset: true,
        offset: Offset(0, 1),
      ),
      BoxShadow(
        color: Color(0xFF595959).withOpacity(0.17),
        blurRadius: 8,
        inset: true,
        offset: Offset(0, -4),
      ),
    ];
  }
}
