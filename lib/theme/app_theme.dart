import 'package:flutter/material.dart';

class AppColors {
  static const bgDark = Color(0xFF000000);
  static const bgLight = Color(0xFF0d0d0d);
  static const bgLighter = Color(0xFF262626);
  static const bgLightest = Color(0xFF333333);
  static const bgCompleted = Color(0xFF1a1a1a);
  static const bgBottomBar = Color(0xFF1F1F1F);

  static const activeText = Color(0xFFf2f2f2);
  static const secondaryText = Color(0xFFa6a6a6);
  static const inactiveText = Color(0xFF595959);
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
