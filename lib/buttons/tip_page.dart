import 'package:cube_painter/alert.dart';
import 'package:cube_painter/transform/screen_size.dart';
import 'package:flutter/material.dart';


const _emphasisStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontStyle: FontStyle.italic,
  decoration: TextDecoration.underline,
);

class TipText {
  final String title;
  final List<TextSpan> body;

  const TipText(this.title, this.body);
}

const _tips = <String, TipText>{
  'oneFinger': TipText(
    'Add cubes',
    <TextSpan>[
      TextSpan(text: 'Drag with '),
      TextSpan(text: 'one', style: _emphasisStyle),
      TextSpan(text: ' finger.'),
    ],
  ),
  'twoFinger': TipText(
    'Pan and Zoom',
    <TextSpan>[
      TextSpan(text: 'Drag with '),
      TextSpan(text: 'two', style: _emphasisStyle),
      TextSpan(text: ' fingers.'),
    ],
  ),
  'longPress': TipText(
    'Button tips',
    <TextSpan>[
      TextSpan(text: 'Press and hold a button.'),
    ],
  ),
};

/// Show a few little message with an image to get them started.
void showHelp(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
//TODO replace this Alert with pageViews at the the start or when press help button
      return Alert(
        title: 'Tips',
        child: const _Tip(name: 'oneFinger'),
        yesCallBack: () => Navigator.of(context).pop(),
        yesTip: 'Done',
      );
    },
  );
}

class _Tip extends StatelessWidget {
  final String name;

  const _Tip({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final p = isPortrait(context);

    final image = Image(
      width: screenAdjust(p ? 0.5 : 0.5, context),
      image: AssetImage('images/$name.png'),
    );

    final tipText = _tips[name];

    final titleText = RichText(
      text: TextSpan(
          text: '${tipText?.title}...\n',
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
        children: tipText?.body,
      ),
    );

    return p
        ? Column(children: [titleText, image, bodyText])
        : Row(children: [
            image,
            Column(children: [titleText, bodyText])
          ]);
  }
}
