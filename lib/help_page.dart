import 'package:cube_painter/asset_icons.dart';
import 'package:cube_painter/buttons/flat_hexagon_button.dart';
import 'package:cube_painter/colors.dart';
import 'package:cube_painter/transform/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

bool getShowHelp(BuildContext context, {bool listen = false}) =>
    getHelpNotifier(context, listen: listen).show;

void setShowHelp(bool show, BuildContext context) =>
    getHelpNotifier(context, listen: false).setShow(show);

HelpNotifier getHelpNotifier(BuildContext context, {required bool listen}) =>
    Provider.of<HelpNotifier>(context, listen: listen);

class HelpNotifier extends ChangeNotifier {
  bool _show = false;

  bool get show => _show;

  void setShow(bool value) {
    _show = value;
    notifyListeners();
  }
}

const _emphasisStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontStyle: FontStyle.italic,
  decoration: TextDecoration.underline,
);

class _Tip {
  final String fileName, title;
  final List<TextSpan> body;
  final Offset landscapeImageOffset, landscapeTextOffset;
  final Offset portraitImageOffset, portraitTextOffset;

  const _Tip({
    required this.fileName,
    required this.title,
    required this.body,
    required this.landscapeImageOffset,
    required this.landscapeTextOffset,
    required this.portraitImageOffset,
    required this.portraitTextOffset,
  });
}


/// Show a few little messages with an image to get them started.
class HelpPage extends StatefulWidget {
  const HelpPage({
    Key? key,
  }) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  int _pageIndex = 0;

  final _pageController = PageController();
  late List<_TipPage> _pages;

  @override
  void initState() {
    _pages = _tips
        .map((tip) => _TipPage(tip: tip, forward: () => _incrementPage(1)))
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: helpColor,
      child: SafeArea(
        left: false,
        child: PageView(
          children: _pages,
          onPageChanged: (index) {
            setState(() => _pageIndex = index);
          },
          controller: _pageController,
        ),
      ),
    );
  }

  void _incrementPage(int increment) {
    _pageIndex += increment;
    if (_pageIndex < 0) {
      _pageIndex = 0;
    } else if (_pageIndex >= _pages.length) {
      _pageIndex = _pages.length - 1;
    }
    _pageController.animateToPage(_pageIndex,
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }
}

class _TipPage extends StatelessWidget {
  final _Tip tip;

  final VoidCallback forward;

  const _TipPage({
    Key? key,
    required this.tip,
    required this.forward,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final assetImage = AssetImage('images/${tip.fileName}.png');

    final image = Container(
      color: bottomLeftColor,
      child: Padding(
        padding: const EdgeInsets.all(4), // Border radius
        child: isPortrait(context)
            ? Image(width: screenAdjust(0.7, context), image: assetImage)
            : Image(height: screenAdjust(0.7, context), image: assetImage),
      ),
    );

    final titleText = RichText(
      text: TextSpan(
          text: tip.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenAdjust(0.06, context),
            color: bottomRightColor,
          )),
    );

    final bodyText = RichText(
      text: TextSpan(
        text: '\n',
        style: TextStyle(
          fontSize: screenAdjust(0.04, context),
          color: bottomRightColor,
        ),
        children: tip.body,
      ),
    );

    final doneButton = IconFlatHexagonButton(
      onPressed: () => setShowHelp(false, context),
      icon: AssetIcons.cancelOutline,
      iconSize: screenAdjustAssetIconSize(context),
      tip: 'Close the tips.',
    );

    final forwardButton = IconFlatHexagonButton(
      onPressed: forward,
      iconSize: screenAdjustNormalIconSize(context),
      icon: Icons.forward_outlined,
      tip: 'Show the next tip.\nYou can also swipe to navigate',
    );

    final buttonRow = Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        doneButton,
        forwardButton,
      ],
    );

    final text = Container(
      color: bottomLeftColor,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          color: tipColor,
          child: Padding(
            padding: const EdgeInsets.all(14), // Border radius
            child: Column(children: [
              SizedBox(height: screenAdjust(0.0, context)),
              titleText,
              bodyText,
            ]),
          ),
        ),
      ),
    );

    return isPortrait(context)
        ? Column(
            children: [
              buttonRow,
              Stack(children: [
                Transform.translate(
                  offset: (const Offset(-2.5, 4.5) + tip.portraitImageOffset) *
                      screenAdjust(0.1, context),
                  child: image,
                ),
                Transform.translate(
                  offset: (const Offset(2, 5) + tip.portraitTextOffset) *
                      screenAdjust(0.1, context),
                  child: text,
                ),
              ]),
            ],
          )
        : Column(
            children: [
              buttonRow,
              Stack(children: [
                Transform.translate(
                  offset: (const Offset(-2, -0.5) + tip.landscapeImageOffset) *
                      screenAdjust(0.1, context),
                  child: image,
                ),
                Transform.translate(
                  offset: (const Offset(1, 2) + tip.landscapeTextOffset) *
                      screenAdjust(0.1, context),
                  child: text,
                ),
              ]),
            ],
          );
  }
}

const _tips = <_Tip>[
  _Tip(
    fileName: 'oneFinger',
    title: 'Add cubes',
    body: <TextSpan>[
      TextSpan(text: 'Drag with '),
      TextSpan(text: 'one', style: _emphasisStyle),
      TextSpan(text: ' finger.'),
    ],
    landscapeImageOffset: Offset(2.5, -0.5),
    landscapeTextOffset: Offset(-2.5, 2),
    portraitImageOffset: Offset(3.0, -1.0),
    portraitTextOffset: Offset(-2.5, 2),
  ),
  _Tip(
    fileName: 'twoFinger',
    title: 'Pan and Zoom',
    body: <TextSpan>[
      TextSpan(text: 'Drag with '),
      TextSpan(text: 'two', style: _emphasisStyle),
      TextSpan(text: ' fingers.'),
    ],
    landscapeImageOffset: Offset(3.0, -0.5),
    landscapeTextOffset: Offset(-2, 2),
    portraitImageOffset: Offset(3.0, -1.0),
    portraitTextOffset: Offset(-2, 2),
  ),
  _Tip(
    fileName: 'eraseLine',
    title: 'Erase cubes',
    body: <TextSpan>[
      TextSpan(
          text: 'Drag the over the cube(s)\n'
              'that you want to remove,\nthen release.')
    ],
    landscapeImageOffset: Offset(3.0, -0.5),
    landscapeTextOffset: Offset(-3, 1),
    portraitImageOffset: Offset(3.0, -0.5),
    portraitTextOffset: Offset(-3, 2),
  ),
  _Tip(
    fileName: 'slicesMenu',
    title: 'Slices menu',
    body: <TextSpan>[TextSpan(text: 'Pick a cube slice')],
    landscapeImageOffset: Offset(3.0, -0.5),
    landscapeTextOffset: Offset(-1.8, 2),
    portraitImageOffset: Offset(3.0, -0.5),
    portraitTextOffset: Offset(-2.8, 2),
  ),
  _Tip(
    fileName: 'placeSlice',
    title: 'Place a slice',
    body: <TextSpan>[TextSpan(text: 'Drag the slice\ninto position.')],
    landscapeImageOffset: Offset(2.0, -0.5),
    landscapeTextOffset: Offset(-2, 1.5),
    portraitImageOffset: Offset(3.0, -0.5),
    portraitTextOffset: Offset(-2, 1.5),
  ),
  _Tip(
    fileName: 'longPress',
    title: 'Button tips',
    body: <TextSpan>[TextSpan(text: 'Press and hold a button.')],
    landscapeImageOffset: Offset(3.0, -0.5),
    landscapeTextOffset: Offset(-2, 2),
    portraitImageOffset: Offset(3.0, -0.5),
    portraitTextOffset: Offset(-2, 2),
  ),
];