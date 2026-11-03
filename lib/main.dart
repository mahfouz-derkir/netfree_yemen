import 'package:flutter/material.dart';
import 'views/home_screen.dart';

void main() {
  runApp(const NetFreeYemenApp());
}

class NetFreeYemenApp extends StatelessWidget {
  const NetFreeYemenApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NetFree Yemen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}