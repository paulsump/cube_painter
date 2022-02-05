import 'package:cube_painter/background.dart';
import 'package:flutter/material.dart';

void main() => runApp(createApp());
Widget createApp() => const MyApp();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cube Painter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Background(title: 'Home Page'),
    );
  }
}
