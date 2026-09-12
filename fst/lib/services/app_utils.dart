import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Gracefully pops system navigation and terminates the app process.
void quitGame() {
  SystemNavigator.pop();
  if (!kIsWeb) {
    exit(0);
  }
}
