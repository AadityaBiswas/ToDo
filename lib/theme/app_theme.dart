import 'package:flutter/material.dart';

class AppColors {
  // Dark Mode
  // static const bgDark = Color(0xFF000000);
  // static const bgLight = Color(0xFF0d0d0d);
  // static const bgLighter = Color(0xFF262626);
  // static const bgLightest = Color(0xFF333333);
  // static const bgCompleted = Color(0xFF1a1a1a);
  // static const bgBottomBar = Color(0xFF1F1F1F);

  // static const activeText = Color(0xFFf2f2f2);
  // static const secondaryText = Color(0xFFa6a6a6);
  // static const inactiveText = Color(0xFF595959);
  // Light Mode
  static const bgDark = Color(0xFFB3B3B3);
  static const bgLight = Color(0xFFF2F2F2);
  static const bgLighter = Color(0xFFD9D9D9);
  static const bgLightest = Color(0xFFFFFFFF);
  static const bgCompleted = Color(0xFFE6E6E6);
  static const bgBottomBar = Color(0xFFE0E0E0);
  static const bgFabDark = Color(0xFF999999);
  static const bgFabLight = Color(0xFFBFBFBF);

  static const activeText = Color(0xFF0D0D0D);
  static const secondaryText = Color(0xFFa6a6a6);
  static const inactiveText = Color(0xFFA6A6A6);
}

class AppTextStyles {
  static const taskTitle = TextStyle(
    color: AppColors.activeText,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const taskTime = TextStyle(
    color: AppColors.secondaryText,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const inactiveTaskTitle = TextStyle(
    color: AppColors.inactiveText,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
}
