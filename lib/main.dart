import 'package:flutter/material.dart';
import 'package:gps/home_page/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {homeScreen.routeName: (context) => homeScreen()},
      initialRoute: homeScreen.routeName,
      debugShowCheckedModeBanner: false,
    );
  }
}
