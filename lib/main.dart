import 'package:cube_painter/home_page.dart';
import 'package:cube_painter/notifiers/crop_notifier.dart';
import 'package:cube_painter/notifiers/cube_store.dart';
import 'package:cube_painter/notifiers/mode_notifier.dart';
import 'package:cube_painter/notifiers/zoom_pan_notifier.dart';
import 'package:cube_painter/widgets/background.dart';
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
        ChangeNotifierProvider(create: (_) => ZoomPan()),
        ChangeNotifierProvider(create: (_) => CubeStore()),
        ChangeNotifierProvider(create: (_) => ModeHolder()),
        ChangeNotifierProvider(create: (_) => CropNotifier()),
      ],
      child: const MaterialApp(
        title: 'Cube Painter',
        home: Background(
          child: HomePage(),
        ),
      ),
    );
  }
}
