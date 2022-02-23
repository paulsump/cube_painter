import 'dart:ui';

import 'package:cube_painter/colors.dart';
import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback yesCallBack;
  final VoidCallback noCallBack;
  final VoidCallback cancelCallBack;

  Alert({
    Key? key,
    required this.title,
    required this.content,
    required this.yesCallBack,
    required this.noCallBack,
    required this.cancelCallBack,
  }) : super(key: key);

  final TextStyle textStyle = TextStyle(color: textColor);
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
          TextButton(
            child: Text("Yes", style: textStyle),
            onPressed: yesCallBack,
          ),
          TextButton(
            child: Text("No", style: textStyle),
            onPressed: noCallBack,
          ),
          TextButton(
            child: Text("Cancel", style: textStyle),
            onPressed: cancelCallBack,
          ),
        ],
      ),
    );
  }
}
