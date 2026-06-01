import 'dart:async'; // 1. ADD THIS IMPORT
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class TimerScreen extends StatefulWidget {
  final String timeHour;
  final String timeMinute;
  const TimerScreen({
    super.key,
    required this.timeHour,
    required this.timeMinute,
  });

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;
  bool negativeTimer = false;
  bool pauseTimer = false;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    WakelockPlus.enable();
    _hours = int.tryParse(widget.timeHour) ?? 0;
    _minutes = int.tryParse(widget.timeMinute) ?? 0;
    _seconds = 0;

    _startTimer();
  }

  void _startTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (pauseTimer) return;
        if (negativeTimer) {
          _seconds++;
          if (_seconds == 60) {
            _minutes++;
            _seconds = 0;
          }
          if (_minutes == 60) {
            _hours++;
            _minutes = 0;
          }
        } else {
          if (_seconds > 0) {
            _seconds--;
          } else {
            if (_minutes > 0) {
              _minutes--;
              _seconds = 59;
            } else {
              if (_hours > 0) {
                _hours--;
                _minutes = 59;
                _seconds = 59;
              } else {
                negativeTimer = true;
              }
            }
          }
        }
      });
    });
  }

  void completeAndExit() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    WakelockPlus.disable();
    _countdownTimer?.cancel();
    Navigator.pop(context, {
      'hour': _hours.toString(),
      'minute': _minutes.toString(),
      'isNegative': negativeTimer,
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    WakelockPlus.disable();
    _countdownTimer?.cancel();
    super.dispose();
  }

  Widget _buildTimeSegment(String time, String label, {bool showColon = true}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: TextStyle(
            color: pauseTimer ? Color(0xFF666666) : Colors.white,
            fontFamily: "dseg7",
            fontSize: 130,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 4.0),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: "dseg7",
              fontSize: 30,
              color: Color(0xFF999999),
            ),
          ),
        ),
        if (showColon)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              ":",
              style: TextStyle(
                color: pauseTimer ? Color(0xFF666666) : Colors.white,
                fontFamily: "dseg7",
                fontSize: 130,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onLongPress: () => completeAndExit(),
        onDoubleTap: () {
          setState(() {
            pauseTimer = !pauseTimer;
          });
        },
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (negativeTimer)
                    Text(
                      "-",
                      style: const TextStyle(
                        color: Colors.red,
                        fontFamily: "dseg7",
                        fontSize: 120,
                      ),
                    ),
                  if (_hours > 0)
                    _buildTimeSegment(_hours.toString().padLeft(2, '0'), "H"),

                  _buildTimeSegment(
                    _minutes.toString().padLeft(2, '0'),
                    "M",
                    showColon: true,
                  ),

                  _buildTimeSegment(
                    _seconds.toString().padLeft(2, '0'),
                    "S",
                    showColon: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
