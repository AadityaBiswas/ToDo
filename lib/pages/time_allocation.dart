import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:todo/pages/timer.dart';
import 'package:todo/theme/app_theme.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'dart:math' as math;

class TimeAllocation extends StatefulWidget {
  final String initialHour;
  final String initialMinute;
  final bool oneTime;
  const TimeAllocation({
    super.key,
    required this.initialHour,
    required this.initialMinute,
    required this.oneTime,
  });

  @override
  State<TimeAllocation> createState() => _TimeAllocationState();
}

class _TimeAllocationState extends State<TimeAllocation> {
  bool minusTapped = false;
  bool plusTapped = false;
  bool thirty = false;
  bool fortyFive = false;
  bool oneHour = false;
  bool saveTime = false;
  late int localHour;
  late int localMinute;
  @override
  void initState() {
    super.initState();
    localHour = int.tryParse(widget.initialHour) ?? 0;
    localMinute = int.tryParse(widget.initialMinute) ?? 0;
    if (localHour == 0 && localMinute == 0) {
      localHour = 0;
      localMinute = 30;
      thirty = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = math.min(size.width / 440, size.height / 956);
    bool isEditing = (widget.initialHour != "0" || widget.initialMinute != "0");
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            height: 134 * scale,
            width: size.width,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                taskTime(scale),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 38 * scale,
                      width: 204 * scale,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTimePill(
                            scale,
                            label: "1h",
                            isActive: oneHour,
                            onTap: () async {
                              if (oneHour ||
                                  (localHour == 1 && localMinute == 0)) {
                                setState(() {
                                  oneHour = false;
                                });
                                await Future.delayed(
                                  const Duration(milliseconds: 10),
                                );
                                setState(() {
                                  localHour = 0;
                                  localMinute = 0;
                                });
                                return; // Exit early!
                              }

                              setState(() {
                                oneHour = true;
                                fortyFive = false;
                                thirty = false;
                              });
                              await Future.delayed(
                                const Duration(milliseconds: 10),
                              );
                              setState(() {
                                localHour = 1;
                                localMinute = 0;
                              });
                            },
                          ),

                          _buildTimePill(
                            scale,
                            label: "45m",
                            isActive: fortyFive,
                            onTap: () async {
                              if (fortyFive ||
                                  (localHour == 0 && localMinute == 45)) {
                                setState(() {
                                  fortyFive = false;
                                });
                                await Future.delayed(
                                  const Duration(milliseconds: 10),
                                );
                                setState(() {
                                  localHour = 0;
                                  localMinute = 0;
                                });
                                return;
                              }

                              setState(() {
                                oneHour = false;
                                fortyFive = true;
                                thirty = false;
                              });
                              await Future.delayed(
                                const Duration(milliseconds: 10),
                              );
                              setState(() {
                                localHour = 0;
                                localMinute = 45;
                              });
                            },
                          ),

                          _buildTimePill(
                            scale,
                            label: "30m",
                            isActive: thirty,
                            onTap: () async {
                              if (thirty ||
                                  (localHour == 0 && localMinute == 30)) {
                                setState(() {
                                  thirty = false;
                                });
                                await Future.delayed(
                                  const Duration(milliseconds: 10),
                                );
                                setState(() {
                                  localHour = 0;
                                  localMinute = 0;
                                });
                                return;
                              }

                              setState(() {
                                oneHour = false;
                                fortyFive = false;
                                thirty = true;
                              });
                              await Future.delayed(
                                const Duration(milliseconds: 10),
                              );
                              setState(() {
                                localHour = 0;
                                localMinute = 30;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 46,
                      width: widget.oneTime || !isEditing ? 46 : 90,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (!widget.oneTime && isEditing)
                            deleteButton(context, scale),
                          saveButton(context, scale),
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
    );
  }

  Widget taskTime(double scale) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      height: 60 * scale,
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
        border: Border.all(color: Color(0xFFCCCCCC), width: 2),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              setState(() {
                minusTapped = true;
              });

              await Future.delayed(Duration(milliseconds: 10));
              if (localMinute == 45 && localHour == 0) {
                localMinute = 44;
              } else {
                int decrement = (localHour > 0)
                    ? (localHour == 1) && (localMinute == 0)
                          ? 2
                          : 5
                    : 2;
                localMinute -= decrement;
                if (localMinute < 0) {
                  if (localHour > 0) {
                    localHour -= 1;
                    localMinute += 60;
                  } else {
                    localMinute = 0;
                    localHour = 0;
                  }
                }
              }
              setState(() {
                oneHour = (localHour == 1 && localMinute == 0);
                fortyFive = (localHour == 0 && localMinute == 45);
                thirty = (localHour == 0 && localMinute == 30);
              });
              await Future.delayed(Duration(milliseconds: 100));
              setState(() {
                minusTapped = false;
              });
            },
            child: Container(
              margin: EdgeInsets.only(top: minusTapped ? 4 : 0),
              height: 40 * scale,
              width: 40 * scale,
              decoration: BoxDecoration(
                color: Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(8),
                border: Border(
                  top: BorderSide(color: Color(0xFFE0E0E0), width: 2),
                  right: BorderSide(color: Color(0xFFE0E0E0), width: 2),
                  left: BorderSide(color: Color(0xFFE0E0E0), width: 2),
                  bottom: BorderSide(
                    color: Color(0xFFE0E0E0),
                    width: minusTapped ? 2 : 6,
                  ),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.remove,
                  color: Color(0xFF757575),
                  size: 25 * scale,
                ),
              ),
            ),
          ),
          Text(
            (localHour == 0 && localMinute == 0)
                ? "${localMinute}m"
                : (localHour == 0)
                ? "${localMinute}m"
                : localMinute == 0
                ? "${localHour}h"
                : "${localHour}h ${localMinute}m",
            style: TextStyle(
              fontFamily: "Hanken_Grotesk",
              fontSize: 32 * scale,
              color: Color(0xFF999999),
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () async {
              setState(() {
                plusTapped = true;
              });
              await Future.delayed(Duration(milliseconds: 10));
              if (localMinute == 45 && localHour == 0) {
                localMinute = 46;
              } else if (localHour < 3) {
                int increment = (localHour > 0) ? 5 : 2;
                localMinute += increment;
                if (localMinute >= 60) {
                  localHour += 1;
                  localMinute -= 60;
                }
              }
              setState(() {
                oneHour = (localHour == 1 && localMinute == 0);
                fortyFive = (localHour == 0 && localMinute == 45);
                thirty = (localHour == 0 && localMinute == 30);
              });
              await Future.delayed(Duration(milliseconds: 100));
              setState(() {
                plusTapped = false;
              });
            },
            child: Container(
              margin: EdgeInsets.only(top: plusTapped ? 4 : 0),
              height: 40 * scale,
              width: 40 * scale,
              decoration: BoxDecoration(
                color: Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(8),
                border: Border(
                  top: BorderSide(color: Color(0xFFE0E0E0), width: 2),
                  right: BorderSide(color: Color(0xFFE0E0E0), width: 2),
                  left: BorderSide(color: Color(0xFFE0E0E0), width: 2),
                  bottom: BorderSide(
                    color: Color(0xFFE0E0E0),
                    width: plusTapped ? 2 : 6,
                  ),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.add,
                  color: Color(0xFF757575),
                  size: 25 * scale,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector _buildTimePill(
    double scale, {
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: isActive ? 4 : 0),
        height: 36 * scale,
        width: 60 * scale,
        decoration: BoxDecoration(
          color: isActive ? Color(0xFF333333) : Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(8),
          border: Border(
            top: BorderSide(
              color: isActive ? Color(0xFF242424) : Color(0xFFE0E0E0),
              width: 2,
            ),
            right: BorderSide(
              color: isActive ? Color(0xFF242424) : Color(0xFFE0E0E0),
              width: 2,
            ),
            left: BorderSide(
              color: isActive ? Color(0xFF242424) : Color(0xFFE0E0E0),
              width: 2,
            ),
            bottom: BorderSide(
              color: isActive ? Color(0xFF242424) : Color(0xFFE0E0E0),
              width: isActive ? 2 : 6,
            ),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Color(0xFFF2F2F2) : Color(0xFF666666),
              fontFamily: "Hanken_Grotesk",
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector saveButton(BuildContext context, double scale) {
    return GestureDetector(
      onTap: () async {
        if (!context.mounted) return;

        if (widget.oneTime) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TimerScreen(
                timeHour: localHour.toString(),
                timeMinute: localMinute.toString(),
              ),
            ),
          );
          await Posthog().capture(eventName: "One time timer Started");
        } else {
          await Posthog().capture(eventName: "Task timer Started");
          String timeHour = localHour == 0 ? "0" : localHour.toString();
          String timeMinute = localMinute == 0 ? "0" : localMinute.toString();

          if (timeHour.isNotEmpty || timeMinute.isNotEmpty) {
            setState(() {
              saveTime = true;
            });

            if (!context.mounted) return;

            Navigator.pop(context, (
              timeHour: timeHour,
              timeMinute: timeMinute,
            ));
          } else {
            setState(() {
              saveTime = true;
            });
            await Future.delayed(const Duration(milliseconds: 150));

            if (!context.mounted) return;

            setState(() {
              saveTime = false;
            });
          }
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: saveTime ? 4 : 0),
        height: 40 * scale,
        width: 40 * scale,
        decoration: BoxDecoration(
          color: Color(0xFF333333),
          borderRadius: BorderRadius.circular(10),
          border: Border(
            top: BorderSide(color: Color(0xFF242424), width: 2),
            right: BorderSide(color: Color(0xFF242424), width: 2),
            left: BorderSide(color: Color(0xFF242424), width: 2),
            bottom: BorderSide(
              color: Color(0xFF242424),
              width: saveTime ? 2 : 6,
            ),
          ),
        ),
        child: Center(
          child: Icon(
            widget.oneTime ? Icons.play_arrow : Icons.arrow_downward_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }

  GestureDetector deleteButton(BuildContext context, double scale) {
    return GestureDetector(
      onTap: () async {
        Navigator.pop(context, (timeHour: "0", timeMinute: "0"));
      },
      child: Container(
        height: 40 * scale,
        width: 40 * scale,
        decoration: BoxDecoration(
          color: Color(0xFFFF6669),
          borderRadius: BorderRadius.circular(10),
          border: Border(
            top: BorderSide(color: Color(0xFFFF383C), width: 2),
            right: BorderSide(color: Color(0xFFFF383C), width: 2),
            left: BorderSide(color: Color(0xFFFF383C), width: 2),
            bottom: BorderSide(color: Color(0xFFFF383C), width: 6),
          ),
        ),
        child: Center(
          child: Icon(
            Icons.delete_outline_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}
