import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:rive/rive.dart' as rive;
import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:todo/pages/add_task.dart';
import 'package:todo/theme/app_theme.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:todo/pages/timer.dart';

class ToDoTile extends StatefulWidget {
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
    double screenWidth = MediaQuery.of(context).size.width;

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
        height: 80,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            base(screenWidth),
            bottomContainer(screenWidth),
            topContainer(screenWidth),
          ],
        ),
      ),
    );
  }

  Widget base(double screenWidth) {
    return Positioned(
      bottom: 0,
      child: Container(
        height: 62,
        width: screenWidth - 40 - 10,
        decoration: BoxDecoration(
          color: widget.isTimerActive ? Color(0xFF0D0D0D) : AppColors.bgLight,
          borderRadius: BorderRadius.circular(18),
        ),
        // child: ClipRRect(
        //   borderRadius: BorderRadius.circular(18),
        //   child: AnimatedOpacity(
        //     opacity: showRiveEditTaskBorder ? 1.0 : 0.0,
        //     duration: const Duration(milliseconds: 150),
        //     child: rive.RiveWidgetBuilder(
        //       fileLoader: riveFileLoader,
        //       builder: (context, state) => switch (state) {
        //         rive.RiveLoading() => const SizedBox.shrink(),
        //         rive.RiveFailed() => const SizedBox.shrink(),
        //         rive.RiveLoaded() => rive.RiveWidget(
        //           controller: state.controller,
        //           fit: rive.Fit.cover,
        //         ),
        //       },
        //     ),
        //   ),
        // ),
      ),
    );
  }

  AnimatedContainer bottomContainer(double screenWidth) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 20),
      margin: EdgeInsets.only(top: 12),
      width: screenWidth - 40 - 20,
      height: widget.isCompleted || tapOnce ? 0 : 60,
      decoration: BoxDecoration(
        color: widget.isTimerActive ? Color(0xFF262626) : AppColors.bgLighter,
        borderRadius: BorderRadius.circular(16),
        boxShadow: defaultBoxShadowBottomTile(),
      ),
    );
  }

  AnimatedContainer topContainer(double screenWidth) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 80),
      curve: Curves.easeInOutCubic,
      margin: EdgeInsets.only(top: widget.isCompleted || tapOnce ? 21 : 6),
      padding: EdgeInsets.all(16),
      width: screenWidth - 40 - 20,
      height: widget.isCompleted || tapOnce ? 54 : 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: widget.isTimerActive
            ? transparentBoxShadow()
            : widget.isCompleted || tapOnce
            ? completedBoxShadowTopTile()
            : defaultBoxShadowTopTile(),
        color: widget.isTimerActive
            ? Color(0xFF333333)
            : widget.isCompleted || tapOnce
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

  Widget buildTaskName() {
    return AnimatedDefaultTextStyle(
      duration: Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      style: AppTextStyles.taskTitle.copyWith(
        color: widget.isTimerActive
            ? Colors.white
            : widget.isCompleted || tapOnce
            ? AppColors.inactiveText
            : AppColors.activeText,
      ),

      child: Expanded(
        child: Text(
          widget.isTimerActive ? "Start timer" : widget.taskName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Text timeAllocated() {
    return Text(
      widget.taskHour == "0" && widget.taskMinute == "0" || widget.isTimerActive
          ? ""
          : widget.taskHour == "0"
          ? "${widget.taskMinute}m"
          : widget.taskMinute == "0"
          ? "${widget.taskHour}h"
          : "${widget.taskHour}h ${widget.taskMinute}m",
      style: AppTextStyles.taskTime.copyWith(
        color: widget.isCompleted || tapOnce
            ? AppColors.inactiveText
            : AppColors.secondaryText,
      ),
    );
  }

  List<BoxShadow> defaultBoxShadowBottomTile() {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 5,
        offset: Offset(0, 2),
      ),
    ];
  }

  List<BoxShadow> defaultBoxShadowTopTile() {
    return [
      BoxShadow(
        color: Color(0xFFFFFFFF).withOpacity(0.25),
        blurRadius: 8,
        inset: true,
        offset: Offset(0, 6),
      ),
      BoxShadow(
        color: Color(0xFF262626).withOpacity(0.05),
        spreadRadius: 2,
        blurRadius: 4,
        offset: Offset(0, 4),
      ),
    ];
  }

  List<BoxShadow> completedBoxShadowTopTile() {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.4),
        blurRadius: 6,
        inset: true,
        offset: Offset(0, 3),
      ),
      BoxShadow(
        color: Colors.white.withValues(alpha: 0.45),
        blurRadius: 12,
        inset: true,
        offset: Offset(0, -2),
      ),
    ];
  }

  List<BoxShadow> transparentBoxShadow() {
    return [
      BoxShadow(color: Colors.transparent, blurRadius: 0, offset: Offset.zero),
      BoxShadow(color: Colors.transparent, blurRadius: 0, offset: Offset.zero),
    ];
  }
}
