import 'package:cube_painter/colors.dart';
import 'package:cube_painter/gesture_mode.dart';
import 'package:cube_painter/gestures/pan_zoom.dart';
import 'package:cube_painter/painter_page.dart';
import 'package:cube_painter/persisted/painting_bank.dart';
import 'package:cube_painter/undo_notifier.dart';
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
        ChangeNotifierProvider(create: (_) => PaintingBank()),
        ChangeNotifierProvider(create: (_) => GestureModeNotifier()),
        ChangeNotifierProvider(create: (_) => UndoNotifier()),
      ],
      child: MaterialApp(
        title: 'Cube Painter',
        // theme:
        // ThemeData.dark()
        //     .copyWith(scaffoldBackgroundColor: backgroundColor),
        theme: ThemeData(
          // primaryColor: Colors.red,
          // backgroundColor: Colors.red,
          // transparent menu
          canvasColor: backgroundColor.withOpacity(0.1),
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: textColor,
                // displayColor: Colors.red,
                fontSizeFactor: 1.0,
              ),
          // for icon buttons only atm
          iconTheme:
              Theme.of(context).iconTheme.copyWith(color: enabledIconColor),
          tooltipTheme: TooltipThemeData(
            // textStyle: TextStyle(
            //   color: Colors.white,
            //   fontFamily: "Questrial",
            //   fontWeight: FontWeight.bold,
            // ),
            /// TODO Responsive to screen size- magic numbers
            verticalOffset: 55,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: tipColor),
          ),
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
              return WillPopScope(
                  onWillPop: () async => false, child: const PainterPage());
            }
          },
        ),
      ),
    );
  }
}
