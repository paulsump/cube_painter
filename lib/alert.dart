// © 2022, Paul Sumpner <sumpner@hotmail.com>

import 'dart:ui';

import 'package:cube_painter/asset_icons.dart';
import 'package:cube_painter/buttons/flat_hexagon_button.dart';
import 'package:cube_painter/hue.dart';
import 'package:cube_painter/transform/screen_adjust.dart';
import 'package:flutter/material.dart';

/// Wraps the [AlertDialog] used for
/// all information / question dialogs
/// in this app.
class Alert extends StatelessWidget {
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

  final String title;
  final Widget child;

  final VoidCallback yesCallBack;
  final String? yesTip;

  final VoidCallback? noCallBack;
  final String? noTip;

  final VoidCallback? cancelCallBack;
  final String? cancelTip;

  static const double _blur = 2;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: _blur, sigmaY: _blur),
      child: AlertDialog(
        backgroundColor: Hue.alert,
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

/// A convenient [IconFlatHexagonButton] with some padding.
class _Button extends StatelessWidget {
  const _Button({
    Key? key,
    this.onPressed,
    required this.icon,
    required this.tip,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final IconData icon;

  final String tip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: screenAdjust(0.017312, context)),
      child: IconFlatHexagonButton(
        icon: icon,
        iconSize: screenAdjustAssetIconSize(context),
        onPressed: onPressed,
        tip: tip,
      ),
    );
  }
}
