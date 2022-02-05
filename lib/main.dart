import 'package:cube_painter/widgets/background.dart';
import 'package:flutter/material.dart';

void main() => runApp(createApp());
Widget createApp() => const CubePainterApp();

class CubePainterApp extends StatelessWidget {
  const CubePainterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cube Painter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Background(),
    );
  }
}
