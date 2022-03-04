import 'dart:ui';

import 'package:cube_painter/asset_icons.dart';
import 'package:cube_painter/buttons/flat_hexagon_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/transform/screen_size.dart';
import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  final String title;

  final Widget child;

  final VoidCallback yesCallBack;
  final String? yesTip;

  final VoidCallback? noCallBack;
  final String? noTip;

  final VoidCallback? cancelCallBack;
  final String? cancelTip;

  const Alert({
    Key? key,
    required this.title,
    required this.child,
    required this.yesCallBack,
    this.yesTip,
    this.noCallBack,
    this.noTip,
    this.cancelCallBack,
    this.cancelTip,
  }) : super(key: key);

  static const double _blur = 2;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: _blur, sigmaY: _blur),
      child: AlertDialog(
        backgroundColor: alertColor,
        title: Text(title),
        content: child,
        actions: <Widget>[
          _Button(
            onPressed: yesCallBack,
            icon: AssetIcons.thumbsUp,
            tip: yesTip ?? 'Yes - Confirm that you do want to do this.',
          ),
          if (noCallBack != null)
            _Button(
              onPressed: noCallBack,
              icon: AssetIcons.thumbsDown,
              tip: noTip ?? 'No - Do it, but say no to the question.',
            ),
          if (cancelCallBack != null)
            _Button(
              onPressed: cancelCallBack,
              icon: AssetIcons.cancelOutline,
              tip: cancelTip ?? 'Cancel.\n\n(Do nothing).',
            ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String tip;

  const _Button({
    Key? key,
    this.onPressed,
    required this.icon,
    required this.tip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: IconFlatHexagonButton(
        icon: icon,
        iconSize: screenAdjustAssetIconSize(context),
        onPressed: onPressed,
        tip: tip,
      ),
    );
  }
}
