import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import '../../ui/pages/index.dart';
import '../styles/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter study',
      debugShowCheckedModeBanner: false,
      theme: makeAppTheme(),
      home: const LoginPage(),
    );
  }
}
