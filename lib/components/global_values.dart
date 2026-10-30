import 'package:flutter/material.dart';

class GlobalValues {
  // 0 -> noche
  // 1 -> día
  // 2 -> warm
  static ValueNotifier<int> banTheme = ValueNotifier<int>(1);
}
