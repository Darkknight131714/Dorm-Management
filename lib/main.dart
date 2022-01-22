import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'admin_homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const Loginpage(),
      //theme: ThemeData.(),
      theme: ThemeData.light().copyWith(
          appBarTheme: AppBarTheme(color: Color(0xFF3FC979)),
          scaffoldBackgroundColor: Color(0xFFE5E5E5),
          // accentColor: Color(0xFF1DA1F2),
          canvasColor: Color(0xFFE5E5E5)),
    );
  }
}
