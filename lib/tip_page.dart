import 'package:cube_painter/asset_icons.dart';
import 'package:cube_painter/buttons/flat_hexagon_button.dart';
import 'package:cube_painter/transform/screen_size.dart';
import 'package:flutter/material.dart';

const _emphasisStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontStyle: FontStyle.italic,
  decoration: TextDecoration.underline,
);

class Tip {
  final String fileName, title;
  final List<TextSpan> body;

  const Tip(this.fileName, this.title, this.body);
}

const _tips = <Tip>[
  Tip('oneFinger', 'Add cubes', <TextSpan>[
    TextSpan(text: 'Drag with '),
    TextSpan(text: 'one', style: _emphasisStyle),
    TextSpan(text: ' finger.'),
  ]),
  Tip('twoFinger', 'Pan and Zoom', <TextSpan>[
    TextSpan(text: 'Drag with '),
    TextSpan(text: 'two', style: _emphasisStyle),
    TextSpan(text: ' fingers.'),
  ]),
  Tip('longPress', 'Button tips', <TextSpan>[
    TextSpan(text: 'Press and hold a button.'),
  ]),
  Tip('slicesMenu', 'Slices menu', <TextSpan>[
    TextSpan(text: 'Pick a cube slice'),
  ]),
  Tip('placeSlice', 'Place a slice', <TextSpan>[
    TextSpan(text: 'Drag the slice into position.'),
  ]),
  Tip('eraseLine', 'Erase cubes', <TextSpan>[
    TextSpan(
        text:
            'Drag the over the cube(s)\nthat you want to remove,\nthen release.'),
  ]),
];

/// Show a few little messages with an image to get them started.
void showHelp(BuildContext context) {
  //TODO this is a bit weird now, perhaps should use Navigator?
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const TipsPageView();
    },
  );
}

class TipsPageView extends StatelessWidget {
  const TipsPageView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(children: [
      for (Tip tip in _tips) TipPage(tip: tip),
    ]);
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

class TipPage extends StatelessWidget {
  final Tip tip;

  const TipPage({Key? key, required this.tip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final image = Image(
      width: screenAdjust(0.5, context),
      image: AssetImage('images/${tip.fileName}.png'),
    );

    final titleText = RichText(
      text: TextSpan(
          text: '${tip.title}...\n',
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

    return isPortrait(context)
        ? Column(
            children: [
              SizedBox(height: screenAdjust(0.3, context)),
              titleText,
              image,
              bodyText,
              SizedBox(height: screenAdjust(0.1, context)),
              button,
            ],
          )
        : Row(children: [
            SizedBox(width: screenAdjust(0.4, context)),
            image,
            SizedBox(width: screenAdjust(0.2, context)),
            Column(children: [
              SizedBox(height: screenAdjust(0.2, context)),
              titleText,
              bodyText,
              SizedBox(height: screenAdjust(0.1, context)),
              button,
            ]),
          ]);
  }
}
