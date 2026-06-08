import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:todo/pages/time_allocation.dart';

class SchedulingSection extends StatefulWidget {
  final bool timeTapped;
  final ValueChanged<bool> onTimeToggled;
  final Function(String hour, String minute) onTimeSelected;
  final String selectedHour;
  final String selectedMinute;
  final bool isEditing;

  const SchedulingSection({
    super.key,
    required this.selectedHour,
    required this.selectedMinute,
    required this.timeTapped,
    required this.onTimeToggled,
    required this.onTimeSelected,
    this.isEditing = false,
  });

  @override
  State<SchedulingSection> createState() => _SchedulingSectionState();
}

class _SchedulingSectionState extends State<SchedulingSection> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [timeSelector(context)],
    );
  }

  GestureDetector timeSelector(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          _isPressed = true;
        });

        final result =
            await showModalBottomSheet<({String timeHour, String timeMinute})>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return TimeAllocation(
                  initialHour: widget.selectedHour,
                  initialMinute: widget.selectedMinute,
                  oneTime: false,
                  isEditing: widget.isEditing,
                );
              },
            );

        setState(() {
          _isPressed = false;
        });

        if (result != null) {
          widget.onTimeSelected(result.timeHour, result.timeMinute);
          widget.onTimeToggled(true);
        }
      },
      child: Stack(
        children: [
          // Base shadow layer
          AnimatedContainer(
            duration: const Duration(milliseconds: 50),
            height: 34,
            width: 82,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: _isPressed
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
          // Top animated physical layer
          AnimatedContainer(
            duration: const Duration(milliseconds: 80),
            curve: Curves.easeInOutCubic,
            height: 34,
            width: 82,
            margin: EdgeInsets.only(
              top: _isPressed ? 4 : 0, // Pushes down when pressed
            ),
            decoration: BoxDecoration(
              color: _isPressed
                  ? const Color(0xFFB3B3B3)
                  : const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(8),
              boxShadow: _isPressed
                  ? [
                      BoxShadow(
                        color: const Color(0xFF404040).withValues(alpha: 0.3),
                        blurRadius: 4,
                        inset: true,
                        offset: const Offset(0, 2),
                      ),
                      BoxShadow(
                        color: const Color(0xFFE5E5E5).withValues(alpha: 0.2),
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
          // Text Layer
          Container(
            margin: EdgeInsets.only(top: _isPressed ? 4 : 0),
            child: _buildTimeLabel(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeLabel() {
    final bool isZero =
        widget.selectedHour == "0" && widget.selectedMinute == "0";

    // Animate text color just like the high priority button
    final Color textColor = _isPressed
        ? const Color(0xFFD9D9D9)
        : const Color(0xFF4D4D4D);

    if (isZero) {
      return SizedBox(
        height: 34,
        width: 82,
        child: Center(
          child: Text(
            "Add time",
            style: TextStyle(
              fontSize: 14,
              color: textColor,
              fontFamily: "Hanken_Grotesk",
              fontWeight: FontWeight.bold, // matched to high priority button
            ),
          ),
        ),
      );
    }

    final String timeString = widget.selectedHour == "0"
        ? "${widget.selectedMinute}m"
        : widget.selectedMinute == "0"
        ? "${widget.selectedHour}h"
        : "${widget.selectedHour}h ${widget.selectedMinute}m";

    return SizedBox(
      height: 34,
      width: 82,
      child: Center(
        child: Text(
          timeString,
          style: TextStyle(
            fontFamily: "Hanken_Grotesk",
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
