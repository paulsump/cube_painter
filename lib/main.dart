import 'dart:async';

import 'package:cube_painter/colors.dart';
import 'package:cube_painter/gestures/brush.dart';
import 'package:cube_painter/gestures/pan_zoom.dart';
import 'package:cube_painter/help_page.dart';
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
      ],
      child: MaterialApp(
          theme: _buildThemeData(context),
          initialRoute: '/painter',
          routes: {
            '/painter': (context) => const _PainterPage(),
            '/help': (context) => const HelpPage(),
          }),
    );
  }

  ThemeData _buildThemeData(BuildContext context) {
    return ThemeData(
      canvasColor: menuColor,
      textTheme: Theme.of(context).textTheme.apply(bodyColor: textColor),
      // for icon buttons only atm
      iconTheme: Theme.of(context).iconTheme.copyWith(
            color: enabledIconColor,
          ),
      tooltipTheme: TooltipThemeData(
        /// TODO Responsive to screen size - removed magic numbers
        verticalOffset: 55,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: tipColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        primary: buttonColor,
      )),
    );
  }
}

class _PainterPage extends StatelessWidget {
  const _PainterPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxHeight == 0) {
          return Container();
        } else {
          final panZoomNotifier = getPanZoomNotifier(context, listen: false);

          // Initialize once only
          if (panZoomNotifier.scale == 0) {
            panZoomNotifier.initializeScale(screenAdjust(0.06494, context));

            unawaited(getPaintingBank(context).setup(context));
          }

          // final
          return WillPopScope(
            onWillPop: () async => false,
            child: Stack(
              children: const [
                PainterPage(),
                if (false) HelpPage(),
              ],
            ),
          );
        }
      },
    );
  }
}
