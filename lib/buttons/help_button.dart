import 'package:cube_painter/alert.dart';
import 'package:cube_painter/buttons/elevated_hexagon_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/transform/screen_size.dart';
import 'package:flutter/material.dart';

/// Pressing this button shows the [HelpAlert].
class HelpButton extends StatelessWidget {
  const HelpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedHexagonButton(
      child: Icon(
        Icons.help_outline_rounded,
        color: enabledIconColor,
        size: screenAdjustNormalIconSize(context),
      ),
      onPressed: () => _showHelp(context),
      tip: 'Display tips.',
    );
  }
}

const _titleStyle = TextStyle(fontWeight: FontWeight.bold);

const _emphasisStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontStyle: FontStyle.italic,
  decoration: TextDecoration.underline,
);

const _oneFingerTip = <TextSpan>[
  TextSpan(text: 'Add cubes', style: _titleStyle),
  TextSpan(text: '...\n\nDrag with '),
  TextSpan(text: 'one', style: _emphasisStyle),
  TextSpan(text: ' finger.'),
];

const _twoFingerTip = <TextSpan>[
  TextSpan(text: 'Pan and Zoom', style: _titleStyle),
  TextSpan(text: '...\n\nDrag with '),
  TextSpan(text: 'two', style: _emphasisStyle),
  TextSpan(text: ' fingers.'),
];

const _longPressTip = <TextSpan>[
  TextSpan(text: 'Button tips', style: _titleStyle),
  TextSpan(text: '...\n\nPress and hold a button.'),
];

final _tips = <_Tip>[
  const _Tip(textSpans: _oneFingerTip),
  const _Tip(textSpans: _twoFingerTip),
  const _Tip(textSpans: _longPressTip),
];

/// Show a little message to get them started.
void _showHelp(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Alert(
        title: 'Tips',
        child: isPortrait(context)
            ? Column(children: _tips)
            : Row(children: _tips),
        yesCallBack: () => Navigator.of(context).pop(),
        yesTip: 'Done',
      );
    },
  );
}

class _Tip extends StatelessWidget {
  final List<TextSpan> textSpans;

  const _Tip({Key? key, required this.textSpans}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '\n',
        style: DefaultTextStyle.of(context).style.apply(
              fontSizeFactor: screenAdjust(0.004, context),
            ),
        children: textSpans,
      ),
    );
  }
}
