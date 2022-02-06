import 'package:cube_painter/painter_page.dart';
import 'package:cube_painter/shared/screen_transform.dart';
import 'package:cube_painter/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(createApp());
Widget createApp() => const CubePainterApp();

class CubePainterApp extends StatelessWidget {
  const CubePainterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ZoomPan(),
      child: const MaterialApp(
        title: 'Cube Painter',
        home: Background(
          child: PainterPage(),
        ),
      ),
    );
  }
}
