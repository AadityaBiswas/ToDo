import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';
import 'package:todo/pages/time_allocation.dart';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';

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
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scale = math.min(size.width / 440, size.height / 956);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [timeSelector(context, scale)],
    );
  }

  GestureDetector timeSelector(BuildContext context, double scale) {
    return GestureDetector(
      onTap: () async {
        setState(() {});

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
                );
              },
            );

        setState(() {});

        if (result != null) {
          widget.onTimeSelected(result.timeHour, result.timeMinute);
          widget.onTimeToggled(true);
        }
      },
      child: Stack(
        children: [
          // Top animated physical layer
          if (!(widget.selectedHour == "0" && widget.selectedMinute == "0"))
            Container(
              height: 45 * scale,
              width: widget.selectedHour != "0" && widget.selectedMinute != "0"
                  ? 70 * scale
                  : 60 * scale,
              decoration: BoxDecoration(
                color: Color(0xFF333333),
                borderRadius: BorderRadius.circular(8),
                border: Border(
                  top: BorderSide(color: Color(0xFF262626), width: 2),
                  right: BorderSide(color: Color(0xFF262626), width: 2),
                  left: BorderSide(color: Color(0xFF262626), width: 2),
                  bottom: BorderSide(color: Color(0xFF262626), width: 6),
                ),
              ),
            ),
          // Text Layer
          Container(child: _buildTimeLabel(scale)),
        ],
      ),
    );
  }

  Widget _buildTimeLabel(double scale) {
    final bool isZero =
        widget.selectedHour == "0" && widget.selectedMinute == "0";

    if (isZero) {
      return Container(
        height: 45 * scale,
        width: 45 * scale,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.circular(8),
          border: Border(
            top: BorderSide(color: Color(0xFFE0E0E0), width: 2),
            right: BorderSide(color: Color(0xFFE0E0E0), width: 2),
            left: BorderSide(color: Color(0xFFE0E0E0), width: 2),
            bottom: BorderSide(color: Color(0xFFE0E0E0), width: 6),
          ),
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/icon/light_clock.svg',
            width: 32 * scale,
            height: 32 * scale,
          ),
        ),
      );
    }

    final String timeString = widget.selectedHour == "0"
        ? "${widget.selectedMinute}m"
        : widget.selectedMinute == "0"
        ? "${widget.selectedHour}h"
        : "${widget.selectedHour}h ${widget.selectedMinute}m";

    return Container(
      padding: EdgeInsets.only(bottom: 4),
      height: 45 * scale,
      width: widget.selectedHour != "0" && widget.selectedMinute != "0"
          ? 70 * scale
          : 60 * scale,
      child: Center(
        child: Text(
          timeString,
          style: TextStyle(
            fontFamily: "Hanken_Grotesk",
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF2F2F2),
          ),
        ),
      ),
    );
  }
}
