import 'dart:ui';

import 'package:cube_painter/asset_icons.dart';
import 'package:cube_painter/buttons/elevated_hexagon_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/constants.dart';
import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback yesCallBack;
  final VoidCallback? noCallBack;
  final VoidCallback cancelCallBack;

  const Alert({
    Key? key,
    required this.title,
    required this.content,
    required this.yesCallBack,
    required this.noCallBack,
    required this.cancelCallBack,
  }) : super(key: key);

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
          ElevatedHexagonButton(
            child: const Icon(
              AssetIcons.thumbsUp,
              size: assetIconSize,
            ),
            onPressed: yesCallBack,
            // TODO pass yes tip in
            tip: 'Yes - Confirm that you do want to do this.',
          ),
          if (noCallBack != null)
            ElevatedHexagonButton(
              child: const Icon(
                AssetIcons.thumbsDown,
                size: assetIconSize,
              ),
              onPressed: noCallBack,
              // TODO pass no tip in
              tip: 'No - Do the operation, but say no to the question.',
            ),
          ElevatedHexagonButton(
            child: const Icon(
              AssetIcons.cancelOutline,
              size: assetIconSize,
            ),
            onPressed: cancelCallBack,
            tip: 'Cancel - Do nothing.',
          ),
        ],
      ),
    );
  }
}
