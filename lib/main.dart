import 'package:cube_painter/buttons/mode_holder.dart';
import 'package:cube_painter/home_page.dart';
import 'package:cube_painter/model/cube_store.dart';
import 'package:cube_painter/transform/screen_transform.dart';
import 'package:cube_painter/widgets/scafolding/background.dart';
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
