import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infonimalapp/main.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.grey.shade500, brightness: Brightness.light),
      home: MainPage(),
    );
  }
}
