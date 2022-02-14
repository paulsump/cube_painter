import 'package:cube_painter/data/crop.dart';
import 'package:cube_painter/data/cube_group.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/painter_page.dart';
import 'package:cube_painter/transform/pan_zoom.dart';
import 'package:cube_painter/transform/screen.dart';
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
        ChangeNotifierProvider(create: (_) => ScreenNotifier()),
        ChangeNotifierProvider(create: (_) => PanZoomNotifier()),
        ChangeNotifierProvider(create: (_) => CubeGroupNotifier()),
        ChangeNotifierProvider(create: (_) => GestureModeNotifier()),
        ChangeNotifierProvider(create: (_) => CropNotifier()),
      ],
      child: MaterialApp(
        title: 'Cube Painter',
        home: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            storeScreenSize(context, constraints);
            return const SafeArea(child: PainterPage());
          },
        ),
      ),
    );
  }
}
