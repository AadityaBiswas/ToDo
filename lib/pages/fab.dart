import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class FabButton extends StatefulWidget {
  final bool tapped;
  final VoidCallback onToggle; // Added callback

  const FabButton({super.key, required this.tapped, required this.onToggle});

  @override
  State<FabButton> createState() => _FabButtonState();
}

class _FabButtonState extends State<FabButton> {
  bool startTimer = false;
  bool addTask = false;

  bool isSquished = false;
  bool isBaseExpanded = false;
  bool isTopExpanded = false;
  bool showButtons = false;

  @override
  void didUpdateWidget(covariant FabButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tapped != oldWidget.tapped) {
      if (widget.tapped) {
        _runOpenSequence();
      } else {
        _runCloseSequence();
      }
    }
  }

  void _runOpenSequence() async {
    // 1. Squish Down (Quick tap feel)
    setState(() => isSquished = true);
    await Future.delayed(const Duration(milliseconds: 100)); // was 120
    if (!mounted) return;

    // 2. Expand Base
    setState(() => isBaseExpanded = true);
    await Future.delayed(const Duration(milliseconds: 120)); // was 150
    if (!mounted) return;

    // 3. Expand Top
    setState(() => isTopExpanded = true);
    await Future.delayed(const Duration(milliseconds: 150)); // was 200
    if (!mounted) return;

    // 4. Show Buttons
    setState(() => showButtons = true);
  }

  void _runCloseSequence() async {
    // 1. Hide buttons instantly
    setState(() {
      showButtons = false;
      startTimer = false;
      addTask = false;
    });
    await Future.delayed(const Duration(milliseconds: 30)); // was 50
    if (!mounted) return;

    // 2. Collapse Top
    setState(() => isTopExpanded = false);
    await Future.delayed(const Duration(milliseconds: 120)); // was 150
    if (!mounted) return;

    // 3. Collapse Base
    setState(() => isBaseExpanded = false);
    await Future.delayed(const Duration(milliseconds: 120)); // was 150
    if (!mounted) return;

    // 4. Un-squish
    setState(() => isSquished = false);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 260,
      child: GestureDetector(
        // Instead of running local logic, we tell the HomePage we were tapped
        onTap: widget.onToggle,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // 1. Base Layer (Expands second)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: isBaseExpanded ? 260 : 80,
              height: 80,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF999999),
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFA6A6A6).withValues(alpha: 0.5),
                    inset: true,
                    offset: const Offset(0, 2),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),

            // 2. Middle Shadow Layer (Squishes instantly)
            AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: 64,
              height: isSquished ? 0 : 64,
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: isSquished
                    ? const Color(0xFFBFBFBF).withValues(alpha: 0)
                    : const Color(0xFFBFBFBF),
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF242424).withValues(alpha: 0.25),
                    offset: const Offset(0, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),

            // 3. Top Interactive Layer
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              height: 64,
              width: isTopExpanded ? 245 : 64,
              margin: EdgeInsets.only(top: isSquished ? 16 : 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: isSquished
                    ? const Color(0xFF808080)
                    : const Color(0xFFE0E0E0),
                boxShadow: isSquished
                    ? [
                        BoxShadow(
                          color: const Color(0xFF404040).withOpacity(0.3),
                          blurRadius: 4,
                          inset: true,
                          offset: const Offset(0, 4),
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
                          color: const Color(0xFFB2B2B2).withOpacity(0.25),
                          blurRadius: 4,
                          inset: true,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
            ),

            // 4. Inner Content
            if (showButtons)
              Container(
                height: 64,
                width: 245,
                margin: const EdgeInsets.only(top: 16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Start Timer Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            startTimer = !startTimer;
                          });
                        },
                        child: Stack(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 60),
                              margin: const EdgeInsets.only(top: 6),
                              height: 40,
                              width: 105,
                              decoration: BoxDecoration(
                                color: startTimer
                                    ? const Color(
                                        0xFFBFBFBF,
                                      ).withValues(alpha: 0)
                                    : const Color(0xFFBFBFBF),
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF333333,
                                    ).withValues(alpha: 0.25),
                                    offset: const Offset(0, 2),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 80),
                              margin: EdgeInsets.only(top: startTimer ? 6 : 0),
                              height: 40,
                              width: 105,
                              decoration: BoxDecoration(
                                color: startTimer
                                    ? const Color(0xFF595959)
                                    : const Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: startTimer
                                    ? [
                                        const BoxShadow(
                                          color: Colors.transparent,
                                        ),
                                      ]
                                    : [
                                        BoxShadow(
                                          inset: true,
                                          color: const Color(
                                            0xFFB2B2B2,
                                          ).withValues(alpha: 0.25),
                                          offset: const Offset(0, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                              ),
                              child: Center(
                                child: Text(
                                  "Start timer",
                                  style: TextStyle(
                                    fontFamily: "Hanken_Grotesk",
                                    fontSize: 15,
                                    color: startTimer
                                        ? const Color(0xFFA6A6A6)
                                        : const Color(0xFF0D0D0D),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Add Task Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            addTask = !addTask;
                          });
                        },
                        child: Stack(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 60),
                              margin: const EdgeInsets.only(top: 6),
                              height: 40,
                              width: 105,
                              decoration: BoxDecoration(
                                color: addTask
                                    ? const Color(
                                        0xFFBFBFBF,
                                      ).withValues(alpha: 0)
                                    : const Color(0xFFBFBFBF),
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF333333,
                                    ).withValues(alpha: 0.25),
                                    offset: const Offset(0, 2),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 80),
                              height: 40,
                              width: 105,
                              margin: EdgeInsets.only(top: addTask ? 6 : 0),
                              decoration: BoxDecoration(
                                color: addTask
                                    ? const Color(0xFF595959)
                                    : const Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: addTask
                                    ? [
                                        const BoxShadow(
                                          color: Colors.transparent,
                                        ),
                                      ]
                                    : [
                                        BoxShadow(
                                          inset: true,
                                          color: const Color(
                                            0xFFB2B2B2,
                                          ).withValues(alpha: 0.25),
                                          offset: const Offset(0, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                              ),
                              child: Center(
                                child: Text(
                                  "Add task",
                                  style: TextStyle(
                                    fontFamily: "Hanken_Grotesk",
                                    fontSize: 15,
                                    color: addTask
                                        ? const Color(0xFFA6A6A6)
                                        : const Color(0xFF0D0D0D),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
