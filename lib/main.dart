import 'package:cube_painter/background.dart';
import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/cube_group_notifier.dart';
import 'package:cube_painter/mode.dart';
import 'package:cube_painter/painter_page.dart';
import 'package:cube_painter/transform/zoom_pan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(createApp());

Widget createApp() => const CubePainterApp();

class CubePainterApp extends StatelessWidget {
  const CubePainterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PanZoomNotifier()),
        ChangeNotifierProvider(create: (_) => CubeGroupNotifier()),
        ChangeNotifierProvider(create: (_) => ModeNotifier()),
        ChangeNotifierProvider(create: (_) => CropNotifier()),
      ],
      child: const MaterialApp(
        title: 'Cube Painter',
        home: Background(
          child: PainterPage(),
        ),
      ),
    );
  }
}
