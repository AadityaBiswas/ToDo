import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:todo/pages/timer.dart';
import 'package:todo/theme/app_theme.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class TimeAllocation extends StatefulWidget {
  final String initialHour;
  final String initialMinute;
  final bool oneTime;
  final bool isEditing;
  const TimeAllocation({
    super.key,
    required this.initialHour,
    required this.initialMinute,
    required this.oneTime,
    this.isEditing = false,
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
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 170,
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
              height: 170,
              width: screenWidth - 20,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
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
                  taskTime(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        height: 52,
                        width: 245,
                        decoration: BoxDecoration(
                          color: Color(0xFFBFBFBF),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.20),
                              blurRadius: 6,
                              inset: true,
                              offset: Offset(0, 3),
                            ),
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.20),
                              blurRadius: 4,
                              inset: true,
                              offset: Offset(0, -1),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTimePill(
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
                        width: widget.oneTime || !widget.isEditing ? 46 : 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (!widget.oneTime && widget.isEditing)
                              deleteButton(context),
                            saveButton(context),
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

  Widget taskTime() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      height: 80,
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
      padding: const EdgeInsets.all(12),
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
            child: Stack(
              children: [
                Container(
                  height: 45,
                  width: 45,
                  margin: EdgeInsets.only(top: 3),
                  decoration: BoxDecoration(
                    color: minusTapped
                        ? Color(0xFFBFBFBF).withValues(alpha: 0)
                        : Color(0xFFBFBFBF),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF333333).withValues(alpha: 0.25),
                        blurRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 80),
                  height: 45,
                  width: 45,
                  margin: EdgeInsets.only(top: minusTapped ? 3 : 0),
                  decoration: BoxDecoration(
                    color: minusTapped ? Color(0xFF999999) : Color(0xFFD9D9D9),
                    boxShadow: minusTapped
                        ? [
                            BoxShadow(
                              color: const Color(0xFF404040).withOpacity(0.3),
                              blurRadius: 4,
                              inset: true,
                              offset: const Offset(0, 2),
                            ),
                            BoxShadow(
                              color: const Color(0xFFE5E5E5).withOpacity(0.2),
                              blurRadius: 2,
                              inset: true,
                              offset: const Offset(0, -1),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Color(0xFF999999).withValues(alpha: 0.25),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 80),
                  height: 45,
                  width: 45,
                  margin: EdgeInsets.only(top: minusTapped ? 3 : 0),
                  child: Center(
                    child: Icon(
                      Icons.remove,
                      color: minusTapped ? Colors.white : Color(0xFF757575),
                      size: 25,
                    ),
                  ),
                ),
              ],
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
              fontSize: 38,
              color: Color(0xFF4D4D4D),
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
            child: Stack(
              children: [
                Container(
                  height: 45,
                  width: 45,
                  margin: EdgeInsets.only(top: 3),
                  decoration: BoxDecoration(
                    color: plusTapped
                        ? Color(0xFFBFBFBF).withValues(alpha: 0)
                        : Color(0xFFBFBFBF),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF333333).withValues(alpha: 0.25),
                        blurRadius: 2,
                        offset: Offset(0, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 80),
                  height: 45,
                  width: 45,
                  margin: EdgeInsets.only(top: plusTapped ? 3 : 0),
                  decoration: BoxDecoration(
                    color: plusTapped ? Color(0xFF999999) : Color(0xFFD9D9D9),
                    boxShadow: plusTapped
                        ? [
                            BoxShadow(
                              color: const Color(0xFF404040).withOpacity(0.3),
                              blurRadius: 4,
                              inset: true,
                              offset: const Offset(0, 2),
                            ),
                            BoxShadow(
                              color: const Color(0xFFE5E5E5).withOpacity(0.2),
                              blurRadius: 2,
                              inset: true,
                              offset: const Offset(0, -1),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Color(0xFF999999).withValues(alpha: 0.25),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 80),
                  height: 45,
                  width: 45,
                  margin: EdgeInsets.only(top: plusTapped ? 3 : 0),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: plusTapped ? Colors.white : Color(0xFF757575),
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector _buildTimePill({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // Base shadow layer
          AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            height: 32,
            width: 70,
            margin: const EdgeInsets.only(top: 3),
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFFBFBFBF).withValues(alpha: 0)
                  : const Color(0xFFBFBFBF),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF333333).withValues(alpha: 0.25),
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          // Top animating pill layer
          AnimatedContainer(
            duration: const Duration(milliseconds: 80),
            curve: Curves.easeInOutCubic,
            height: 32,
            width: 70,
            margin: EdgeInsets.only(top: isActive ? 3 : 0),
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFFB3B3B3)
                  : const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(8),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: const Color(0xFF404040).withOpacity(0.3),
                        blurRadius: 4,
                        inset: true,
                        offset: const Offset(0, 2),
                      ),
                      BoxShadow(
                        color: const Color(0xFFE5E5E5).withOpacity(0.2),
                        blurRadius: 2,
                        inset: true,
                        offset: const Offset(0, -1),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: const Color(0xFF999999).withValues(alpha: 0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
          ),
          // Text layer
          Container(
            height: 32,
            width: 70,
            margin: EdgeInsets.only(top: isActive ? 3 : 0),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: isActive
                      ? const Color(0xFFD9D9D9)
                      : const Color(0xFF4D4D4D),
                  fontFamily: "Hanken_Grotesk",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector saveButton(BuildContext context) {
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
        height: 46,
        width: 46,
        decoration: BoxDecoration(
          color: const Color(0xFF00BD00),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.45),
              blurRadius: 6,
              inset: true,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            widget.oneTime ? Icons.play_arrow : Icons.arrow_downward_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  GestureDetector deleteButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.pop(context, (timeHour: "0", timeMinute: "0"));
      },
      child: Container(
        height: 46,
        width: 46,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.45),
              blurRadius: 6,
              inset: true,
              offset: const Offset(0, 1),
            ),
          ],
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
