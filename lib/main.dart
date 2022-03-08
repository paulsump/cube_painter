import 'dart:async';

import 'package:cube_painter/gestures/brush.dart';
import 'package:cube_painter/gestures/pan_zoom.dart';
import 'package:cube_painter/help_page.dart';
import 'package:cube_painter/hue.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/painter_page.dart';
import 'package:cube_painter/persisted/painting_bank.dart';
import 'package:cube_painter/transform/screen_size.dart';
import 'package:cube_painter/undo_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// ## Main classes
///
/// - The main page is PainterPage.  This contains all the widgets that are draw.
/// - The Brusher draws AnimatedCubes while you drag a line of cubes.
/// - The Animator turns them into StaticCubes when you've finished dragging a line of cubes.
/// - The Persister saves the Position of each cube in a list of CubeInfos in the Painting class.
/// - Animator and Persister are mixins for the Paintings Provider.

/// prevent 'organise imports' from removing imports
/// when temporarily commenting out.
const noWarn = out;

void main() => runApp(createApp());

Widget createApp() => const CubePainterApp();

/// The only App in this app.
class CubePainterApp extends StatelessWidget {
  const CubePainterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PanZoomNotifier()),
        ChangeNotifierProvider(create: (_) => PaintingBank()),
        ChangeNotifierProvider(create: (_) => BrushNotifier()),
        ChangeNotifierProvider(create: (_) => UndoNotifier()),
        ChangeNotifierProvider(create: (_) => HelpNotifier()),
      ],
      child: MaterialApp(
        theme: _buildThemeData(context),
        home: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxHeight == 0) {
              return Container();
            } else {
              final panZoomNotifier =
                  getPanZoomNotifier(context, listen: false);

              // Initialize once only
              if (panZoomNotifier.scale == 0) {
                panZoomNotifier.initializeScale(screenAdjust(0.06494, context));

                unawaited(getPaintingBank(context).setup(context));
              }

              // final
              return WillPopScope(
                onWillPop: () async => false,
                child: Stack(
                  children: [
                    const PainterPage(),
                    if (getShowHelp(context, listen: true)) const HelpPage(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  ThemeData _buildThemeData(BuildContext context) {
    return ThemeData(
      canvasColor: Hue.menuColor,
      textTheme: Theme.of(context).textTheme.apply(bodyColor: Hue.textColor),
      // for icon buttons only atm
      iconTheme: Theme.of(context).iconTheme.copyWith(
            color: Hue.enabledIconColor,
          ),
      tooltipTheme: TooltipThemeData(
        /// TODO Responsive to screen size - removed magic numbers
        verticalOffset: 55,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Hue.tipColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Hue.buttonColor,
      )),
    );
  }
}
