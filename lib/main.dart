import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ui/components/app.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(const App());
}
