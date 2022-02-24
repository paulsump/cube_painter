import 'package:cube_painter/colors.dart';
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
          canvasColor: backgroundColor.withOpacity(0.4),
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: textColor,
                // displayColor: Colors.red,
                fontSizeFactor: 1.0,
              ),
          // for icon buttons only atm
          iconTheme:
              Theme.of(context).iconTheme.copyWith(color: enabledIconColor),
          // buttonTheme: Theme.of(context).buttonTheme.copyWith(
          //       buttonColor: Colors.red,
          //       splashColor: Colors.yellow,
          //     ),
          // buttonTheme: ButtonThemeData(
          //   buttonColor: Colors.deepPurple,     //  <-- dark color
          //   textTheme: ButtonTextTheme.primary, //  <-- this auto selects the right color
          // ),
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
