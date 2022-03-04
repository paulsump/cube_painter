import 'dart:async';

import 'package:cube_painter/colors.dart';
import 'package:cube_painter/gestures/brush.dart';
import 'package:cube_painter/gestures/pan_zoom.dart';
import 'package:cube_painter/out.dart';
import 'package:cube_painter/painter_page.dart';
import 'package:cube_painter/persisted/painting_bank.dart';
import 'package:cube_painter/transform/screen_size.dart';
import 'package:cube_painter/undo_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// prevent 'organise imports' from removing imports
/// when temporarily commenting out.
const noWarn = out;

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
        ChangeNotifierProvider(create: (_) => BrushNotifier()),
        ChangeNotifierProvider(create: (_) => UndoNotifier()),
      ],
      child: MaterialApp(
        title: 'Cube Painter',
        theme: ThemeData(
          // transparent menu
          canvasColor: backgroundColor.withOpacity(0.1),
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: textColor,
                fontSizeFactor: 1.0,
              ),
          // for icon buttons only atm
          iconTheme: Theme.of(context).iconTheme.copyWith(
                color: enabledIconColor,
              ),
          tooltipTheme: TooltipThemeData(
            // textStyle: TextStyle(fontSize: 14),

            /// TODO Responsive to screen size- magic numbers
            /// I'd have to move it to a place with a valid context
            /// to calcTooltipOffsetY(context)
            verticalOffset: 55,
            // verticalOffset: calcTooltipOffsetY(context),
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
              final panZoomNotifier =
                  getPanZoomNotifier(context, listen: false);

              // Initialize once only
              if (panZoomNotifier.scale == 0) {
                panZoomNotifier
                    .initializeScale(0.06494 * getShortestEdge(context));

                unawaited(getPaintingBank(context).setup(context));
              }

              return WillPopScope(
                  onWillPop: () async => false, child: const PainterPage());
            }
          },
        ),
      ),
    );
  }
}
