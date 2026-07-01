import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:rive/rive.dart' as rive;
import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:todo/pages/add_task.dart';
import 'package:todo/theme/app_theme.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:todo/pages/timer.dart';
import 'dart:math' as math;

import 'package:flutter_svg/flutter_svg.dart';

class ToDoTile extends StatefulWidget {
  final List<bool>? habitDays;
  final bool isHabit;
  final bool isTimerActive;
  final String taskName;
  final String taskHour;
  final String taskMinute;
  final String taskDate;
  final String taskMonth;
  final String taskYear;
  final bool isCompleted;
  final bool isHighPriority;
  final VoidCallback onTimerTap;
  final void Function(Map<String, dynamic>) onEditedTask;
  const ToDoTile({
    super.key,
    this.habitDays,
    this.isHabit = false,
    required this.isHighPriority,
    required this.onTimerTap,
    required this.isTimerActive,
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
  bool showRiveEditTaskBorder = false;
  bool editTask = false;
  String result = "";
  bool tapOnce = false;
  late final rive.FileLoader riveFileLoader;
  @override
  void initState() {
    super.initState();
    riveFileLoader = rive.FileLoader.fromAsset(
      'assets/animations/bottombaselongclick.riv',
      riveFactory: rive.Factory.rive,
    );
  }

  @override
  void dispose() {
    riveFileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = math.min(size.width / 440, size.height / 956);

    return GestureDetector(
      onLongPress: () async {
        await Posthog().capture(eventName: "Opened Edited task");
        setState(() {
          editTask = true;
          showRiveEditTaskBorder = true;
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
              isHighPriority: widget.isHighPriority,
              isHabit: widget.isHabit,
              habitDays: widget.habitDays ?? List.filled(7, false),
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
      onTap: () async {
        if (widget.taskHour == "0" && widget.taskMinute == "0" ||
            widget.isCompleted) {
          Map<String, dynamic> updatedTask = {
            'name': widget.taskName,
            'hour': widget.taskHour,
            'minute': widget.taskMinute,
            'date': widget.taskDate,
            'month': widget.taskMonth,
            'year': widget.taskYear,
            'isCompleted': !widget.isCompleted,
            'isHighPriority': widget.isHighPriority,
            'isHabit': widget.isHabit,
            'habitDays': widget.habitDays,
          };
          widget.onEditedTask(updatedTask);
          await Posthog().capture(eventName: "Task Completed");
        } else {
          if (widget.isTimerActive) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TimerScreen(
                  timeHour: widget.taskHour,
                  timeMinute: widget.taskMinute,
                ),
              ),
            );
            widget.onTimerTap();
            if (result != null) {
              int returnedHour = int.tryParse(result['hour'].toString()) ?? 0;
              int returnedMinute =
                  int.tryParse(result['minute'].toString()) ?? 0;
              bool isNegative = result['isNegative'] as bool? ?? false;

              int allocatedHour = int.tryParse(widget.taskHour) ?? 0;
              int allocatedMinute = int.tryParse(widget.taskMinute) ?? 0;

              int totalAllocatedMins = (allocatedHour * 60) + allocatedMinute;
              int returnedMins = (returnedHour * 60) + returnedMinute;

              int actualTimeSpentMins;
              if (isNegative) {
                actualTimeSpentMins = totalAllocatedMins + returnedMins;
              } else {
                actualTimeSpentMins = totalAllocatedMins - returnedMins;
              }

              if (isNegative || returnedMins == 0) {
                int finalHours = actualTimeSpentMins ~/ 60;
                int finalMinutes = actualTimeSpentMins % 60;

                Map<String, dynamic> updatedTask = {
                  'name': widget.taskName,
                  'hour': finalHours.toString(),
                  'minute': finalMinutes.toString(),
                  'date': widget.taskDate,
                  'month': widget.taskMonth,
                  'year': widget.taskYear,
                  'isCompleted': true,
                  'isHighPriority': widget.isHighPriority,
                  'isHabit': widget.isHabit,
                  'habitDays': widget.habitDays,
                };
                widget.onEditedTask(updatedTask);
              } else {
                Map<String, dynamic> updatedTask = {
                  'name': widget.taskName,
                  'hour': returnedHour.toString(),
                  'minute': returnedMinute.toString(),
                  'date': widget.taskDate,
                  'month': widget.taskMonth,
                  'year': widget.taskYear,
                  'isCompleted': widget.isCompleted,
                  'isHighPriority': widget.isHighPriority,
                  'isHabit': widget.isHabit,
                  'habitDays': widget.habitDays,
                };
                widget.onEditedTask(updatedTask);
              }
            }
          } else {
            setState(() {
              tapOnce = true;
            });
            await Future.delayed(Duration(milliseconds: 120));
            widget.onTimerTap();
            await Future.delayed(Duration(milliseconds: 60));
            setState(() {
              tapOnce = false;
            });
          }
        }
      },
      child: SizedBox(
        height: 58 * scale,
        width: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: widget.isCompleted || tapOnce ? 6 * scale : 0,
              left: 0,
              right: 0,
              child: taskContainer(scale),
            ),
          ],
        ),
      ),
    );
  }

  Widget taskContainer(double scale) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double tileWidth = widget.isHabit ? 190 * scale : 400 * scale;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18 * scale),
      width: tileWidth,
      height: widget.isHabit ? 60 * scale : 50 * scale,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.isHabit ? 14 : 10),
        color: widget.isTimerActive
            ? Color(0xFF333333)
            : AppColors.bgTaskCardIncomplete,
        border: Border(
          bottom: BorderSide(
            color: widget.isTimerActive ? Color(0xFF262626) : Color(0xFFCCCCCC),
            width: widget.isCompleted || tapOnce
                ? widget.isHabit
                      ? 3 * scale
                      : 2 * scale
                : widget.isHabit
                ? 9 * scale
                : 8 * scale,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          top: BorderSide(
            color: widget.isTimerActive ? Color(0xFF262626) : Color(0xFFCCCCCC),
            width: widget.isHabit ? 3 : 2,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          left: BorderSide(
            color: widget.isTimerActive ? Color(0xFF262626) : Color(0xFFCCCCCC),
            width: widget.isHabit ? 3 : 2,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          right: BorderSide(
            color: widget.isTimerActive ? Color(0xFF262626) : Color(0xFFCCCCCC),
            width: widget.isHabit ? 3 : 2,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildTaskName(),
            if (!(widget.taskHour == "0" && widget.taskMinute == "0"))
              Row(
                children: [
                  SizedBox(
                    height: 20 * scale,
                    width: 60 * scale,
                    child: timeAllocated(scale),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget buildTaskName() {
    return Row(
      children: [
        if (widget.isHighPriority)
          SizedBox(child: Icon(Icons.circle, size: 8, color: Colors.red)),
        SizedBox(width: widget.isHighPriority ? 6 : 0),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          style: AppTextStyles.taskText.copyWith(
            color: widget.isTimerActive
                ? const Color(0xFFF2F2F2)
                : const Color(0xFF0D0D0D),
          ),
          child: Text(
            widget.isTimerActive ? "Start timer" : widget.taskName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: widget.isHabit ? FontWeight.w700 : FontWeight.bold,
              fontSize: widget.isTimerActive
                  ? 16
                  : widget.isHabit
                  ? 18
                  : 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget timeAllocated(double scale) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/icon/clock.svg',
          width: 12 * scale,
          height: 12 * scale,
        ),
        SizedBox(width: 4),
        Text(
          widget.taskHour == "0" && widget.taskMinute == "0"
              ? ""
              : widget.taskHour == "0"
              ? "${widget.taskMinute}m"
              : widget.taskMinute == "0"
              ? "${widget.taskHour}h"
              : "${widget.taskHour}h ${widget.taskMinute}m",
          style: AppTextStyles.taskTime,
        ),
      ],
    );
  }
}
