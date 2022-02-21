import 'package:cube_painter/colors.dart';
import 'package:cube_painter/cubes/cube_sides.dart';
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
        // theme:
        // ThemeData.dark()
        //     .copyWith(scaffoldBackgroundColor: backgroundColor),
        theme: ThemeData(
          // primaryColor: Colors.red,
          // backgroundColor: Colors.red,
          canvasColor: Colors.transparent,
          //or any other color you want. e.g Colors.blue.withOpacity(0.5)
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: getColor(Side.br),
                // displayColor: Colors.red,
                fontSizeFactor: 1.5,
              ),
          // iconTheme: IconTheme(
          //   data: IconThemeData(color: Colors.blue),
          // ),
          // iconTheme: IconThemeData(color: Colors.pink),
          // iconTheme: Theme.of(context)
          //     .iconTheme
          //     .copyWith(color: getColor(Side.br)), // -> ignored
          // buttonTheme: Theme.of(context).buttonTheme.copyWith(
          //       buttonColor: Colors.red,
          //       splashColor: Colors.red,
          //     ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                primary: buttonColor,
              )),
        ),
        home: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxHeight == 0) {
              return Container();
            } else {
              storeScreenSize(context, constraints);
              return WillPopScope(
                  onWillPop: () async => false, child: const PainterPage());
            }
          },
        ),
      ),
    );
  }
}
