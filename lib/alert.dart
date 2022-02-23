import 'dart:ui';

import 'package:cube_painter/buttons/hexagon_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback yesCallBack;
  final VoidCallback? noCallBack;
  final VoidCallback cancelCallBack;

  Alert({
    Key? key,
    required this.title,
    required this.content,
    required this.yesCallBack,
    required this.noCallBack,
    required this.cancelCallBack,
  }) : super(key: key);

  // final TextStyle textStyle = TextStyle(color: textColor);
  static const double _blur = 2;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: _blur, sigmaY: _blur),
      child: AlertDialog(
        backgroundColor: backgroundColor.withOpacity(0.6),
        title: Text(
          title,
        ),
        content: Text(
          content,
        ),
        actions: <Widget>[
          HexagonButton(
            child: const Icon(Icons.check_sharp),
            // child: Text("Yes", style: textStyle),
            onPressed: yesCallBack,
            // TODO pass yes tip in
            tip: 'Confirm that you do want to do this.',
          ),
          if (noCallBack != null)
            HexagonButton(
              child: const Icon(Icons.do_not_disturb_alt_sharp),
              // child: Text("No", style: textStyle),
              onPressed: noCallBack,
              // TODO pass no tip in
              tip: 'Do the operation, but say no to the question.',
            ),
          HexagonButton(
            child: const Icon(Icons.cancel_presentation_sharp),
            // child: Text("Cancel", style: textStyle),
            onPressed: cancelCallBack,
            tip: 'Do nothing.',
          ),
        ],
      ),
    );
  }
}
