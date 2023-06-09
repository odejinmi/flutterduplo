import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

const primarycolour = Color(0xff5019CE);

// bool isDarkMode(context) {
//   final ThemeData theme = Theme.of(context);
//   return theme.brightness == appDarkTheme().brightness
// }
bool get isDarkMode {
  var brightness = SchedulerBinding.instance.window.platformBrightness;
  return brightness == Brightness.dark;
}
