import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
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

class _TimerScreenState extends State<TimerScreen>
    with TickerProviderStateMixin {
  double? x;
  double? y;
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;
  bool negativeTimer = false;
  bool pauseTimer = false;

  Timer? _countdownTimer;
  Timer? _pressDelayTimer; // Added: Timer to track the 2-second hold delay

  late AnimationController _blinkController;
  late AnimationController _holdController;
  late Animation<double> _circleSize;
  late Animation<double> _textScale;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    WakelockPlus.enable();

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _blinkController.value = 1.0;

    _holdController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _circleSize = Tween<double>(
      begin: 0,
      end: 2500,
    ).animate(CurvedAnimation(parent: _holdController, curve: Curves.easeIn));

    _textScale = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(parent: _holdController, curve: Curves.easeOut));

    _holdController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        HapticFeedback.heavyImpact();
        completeAndExit();
      }
    });

    _hours = int.tryParse(widget.timeHour) ?? 0;
    _minutes = int.tryParse(widget.timeMinute) ?? 0;
    _seconds = 0;

    _startTimer();
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

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
                _seconds = 1;
              }
            }
          }
        }
      });
    });
  }

  void _togglePause() {
    setState(() {
      pauseTimer = !pauseTimer;
      if (pauseTimer) {
        _blinkController.repeat(reverse: true);
      } else {
        _blinkController.stop();
        _blinkController.value = 1.0;
      }
    });
  }

  void completeAndExit() async {
    await Posthog().capture(eventName: "timer Stopped");

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    WakelockPlus.disable();
    _countdownTimer?.cancel();
    _pressDelayTimer?.cancel();

    if (!mounted) return;

    Navigator.pop(context, {
      'hour': _hours.toString(),
      'minute': _minutes.toString(),
      'second': _seconds.toString(),
      'isNegative': negativeTimer,
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    WakelockPlus.disable();
    _countdownTimer?.cancel();
    _pressDelayTimer?.cancel(); // Dispose of the delay timer
    _blinkController.dispose();
    _holdController.dispose();
    super.dispose();
  }

  // Added: Helper method to handle finger lift / cancellation
  void _cancelPress() {
    _pressDelayTimer?.cancel();

    // If animation started, reverse it. Otherwise, just clear coordinates.
    if (_holdController.value > 0) {
      _holdController.reverse().then((_) {
        if (mounted) {
          setState(() {
            x = null;
            y = null;
          });
        }
      });
    } else {
      setState(() {
        x = null;
        y = null;
      });
    }
  }

  Widget _buildTimeSegment(String time, String label, {bool showColon = true}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: TextStyle(
            color: pauseTimer ? const Color(0xFF666666) : Colors.white,
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
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FadeTransition(
              opacity: pauseTimer
                  ? _blinkController
                  : const AlwaysStoppedAnimation(1.0),
              child: Text(
                ":",
                style: TextStyle(
                  color: pauseTimer ? const Color(0xFF666666) : Colors.white,
                  fontFamily: "dseg7",
                  fontSize: 130,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Replaced GestureDetector long press fields with a raw Listener
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (event) {
        setState(() {
          x = event.localPosition.dx;
          y = event.localPosition.dy;
        });

        // Start the 2-second delay timer
        _pressDelayTimer?.cancel();
        _pressDelayTimer = Timer(const Duration(seconds: 1), () {
          if (mounted) {
            _holdController.forward();
          }
        });
      },
      onPointerUp: (_) => _cancelPress(),
      onPointerCancel: (_) => _cancelPress(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onDoubleTap: () => _togglePause(),
        child: Scaffold(
          backgroundColor: Colors.black,
          body: AnimatedBuilder(
            animation: _holdController,
            builder: (context, child) {
              return Stack(
                children: [
                  if (x != null && y != null)
                    Positioned(
                      left: x! - (_circleSize.value / 2),
                      top: y! - (_circleSize.value / 2),
                      child: Container(
                        width: _circleSize.value,
                        height: _circleSize.value,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  Center(
                    child: Transform.scale(
                      scale: _textScale.value,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (negativeTimer)
                                const Text(
                                  "-",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontFamily: "dseg7",
                                    fontSize: 120,
                                  ),
                                ),
                              if (_hours > 0)
                                _buildTimeSegment(_hours.toString(), "h"),
                              _buildTimeSegment(
                                _minutes.toString().padLeft(2, '0'),
                                "m",
                                showColon: true,
                              ),
                              _buildTimeSegment(
                                _seconds.toString().padLeft(2, '0'),
                                "s",
                                showColon: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
