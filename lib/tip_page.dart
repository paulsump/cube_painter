import 'package:cube_painter/asset_icons.dart';
import 'package:cube_painter/buttons/flat_hexagon_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/transform/screen_size.dart';
import 'package:flutter/material.dart';

const _emphasisStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontStyle: FontStyle.italic,
  decoration: TextDecoration.underline,
);

class _Tip {
  final String fileName, title;
  final List<TextSpan> body;

  const _Tip(this.fileName, this.title, this.body);
}

const _tips = <_Tip>[
  _Tip('oneFinger', 'Add cubes', <TextSpan>[
    TextSpan(text: 'Drag with '),
    TextSpan(text: 'one', style: _emphasisStyle),
    TextSpan(text: ' finger.'),
  ]),
  _Tip('twoFinger', 'Pan and Zoom', <TextSpan>[
    TextSpan(text: 'Drag with '),
    TextSpan(text: 'two', style: _emphasisStyle),
    TextSpan(text: ' fingers.'),
  ]),
  _Tip('eraseLine', 'Erase cubes', <TextSpan>[
    TextSpan(
        text: 'Drag the over the cube(s)\n'
            'that you want to remove,\nthen release.')
  ]),
  _Tip('slicesMenu', 'Slices menu',
      <TextSpan>[TextSpan(text: 'Pick a cube slice')]),
  _Tip('placeSlice', 'Place a slice',
      <TextSpan>[TextSpan(text: 'Drag the slice into position.')]),
  _Tip('longPress', 'Button tips',
      <TextSpan>[TextSpan(text: 'Press and hold a button.')]),
];

/// Show a few little messages with an image to get them started.
void showHelp(BuildContext context) {
  //TODO this is a bit weird now, perhaps should use Navigator?
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return PageView(children: [
        for (_Tip tip in _tips) _TipPage(tip: tip),
      ]);
    },
  );
}

class _TipPage extends StatelessWidget {
  final _Tip tip;

  const _TipPage({Key? key, required this.tip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final image = Image(
      width: screenAdjust(0.5, context),
      image: AssetImage('images/${tip.fileName}.png'),
    );

    final titleText = RichText(
      text: TextSpan(
          text: '${tip.title}...',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenAdjust(0.08, context),
          )),
    );

    final bodyText = RichText(
      text: TextSpan(
        text: '\n',
        style: DefaultTextStyle.of(context).style.apply(
              fontSizeFactor: screenAdjust(0.004, context),
            ),
        children: tip.body,
      ),
    );

    final button = _Button(
      onPressed: Navigator.of(context).pop,
      icon: AssetIcons.thumbsUp,
      tip: 'Close the tips.',
    );

    return Container(
      color: helpColor,
      child: isPortrait(context)
          ? Column(
              children: [
                Align(alignment: Alignment.topLeft, child: button),
                SizedBox(height: screenAdjust(0.3, context)),
                titleText,
                SizedBox(height: screenAdjust(0.1, context)),
                image,
                SizedBox(height: screenAdjust(0.1, context)),
                bodyText,
                SizedBox(height: screenAdjust(0.1, context)),
              ],
            )
          : Column(
              children: [
                Align(alignment: Alignment.topLeft, child: button),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(width: screenAdjust(0.4, context)),
                  image,
                  SizedBox(width: screenAdjust(0.2, context)),
                  Column(children: [
                    SizedBox(height: screenAdjust(0.0, context)),
                    titleText,
                    bodyText,
                    SizedBox(height: screenAdjust(0.1, context)),
                  ]),
                ]),
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
    return IconFlatHexagonButton(
      icon: icon,
      iconSize: screenAdjustAssetIconSize(context),
      onPressed: onPressed,
      tip: tip,
    );
  }
}
