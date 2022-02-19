import 'package:flutter/material.dart';
import 'package:tycka/ui/components.dart';

abstract class ThemeUtils {
  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color backgroundColor(BuildContext context) {
    return isDark(context) ? TyckaUI.backgroundColor : Colors.white;
  }
}
