# Cube Painter ![logo](https://github.com/paulsump/cube_painter/blob/98a52da01cb1108a178e1a22b418b98a05f2c382/android/app/src/main/res/mipmap-hdpi/ic_launcher.png)

A painting app, but the 'paint' is cubes.


## Getting Started

| Add lines of cubes  | Pan and zoom | Erase |
| ------------- | ------------- | ------------- |
| <img src="https://github.com/paulsump/cube_painter/blob/2049ca6da2a6231c3e980608b48249efaccac9b0/images/oneFinger.png" height="248">  | <img src="https://github.com/paulsump/cube_painter/blob/2049ca6da2a6231c3e980608b48249efaccac9b0/images/twoFinger.png" height="248"> | <img src="https://github.com/paulsump/cube_painter/blob/2049ca6da2a6231c3e980608b48249efaccac9b0/images/eraseLine.png" height="248"> | 

| Places slices of cubes... | ...that you pick from a menu |
| ------------- | ------------- |
| <img src="https://github.com/paulsump/cube_painter/blob/2049ca6da2a6231c3e980608b48249efaccac9b0/images/placeSlice.png" height="248"> | <img src="https://github.com/paulsump/cube_painter/blob/2049ca6da2a6231c3e980608b48249efaccac9b0/images/slicesMenu.png" height="248"> |

## Implementation
  - A standalone Flutter app working on Android and iOS using Provider.  
  - StatelessWidgets wherever possible.

## Main classes

- The main page is PainterPage.  This contains all the widgets that are draw.
- The Brusher draws AnimatedCubes while you drag a line of cubes.
- The Animator turns them into StaticCubes when you've finished dragging a line of cubes.
- The Persister saves the Position of each cube in a list of CubeInfos in the Painting class.
- Animator and Persister are mixins for the Paintings Provider.

## Packages used
- provider
- path_provider.

## Tests
- All the mathematical functions have tests.
- There are no widget tests per se.

## Persistence

Local files are persisted with jsonEncode & jsonDecode.

## Hexagon Buttons
ElevatedButton and TextButton ButtonStyle.shape is set to my HexagonBorder which extends OutlinedBorder in a similar way to CircleBorder.


## Flutter Widgets used
Stack
Transform
StatelessWidget
Tooltip
SizedBox
ElevatedButton
Column
Row
Container
Icon
Scaffold
Drawer
TextButton
StatefulWidget
CustomPainter
AlertDialog
SafeArea
LayoutBuilder
MaterialApp
WillPopScope
Divider
ListView
Center
Text

## Other Flutter classes used
ThemeData
BoxDecoration
TooltipThemeData
Clipboard
RichText
ChangeNotifierProvider
Offset
ButtonStyle
IconData
HexagonBorder extends OutlinedBorder
MaterialStateProperty
ShapeBorder
Path
Provider
List
Align
Navigator
AnimatedBuilder
SingleTickerProviderStateMixin
State
AnimationController
Duration
Paint
Alignment
LinearGradient
UnmodifiableListView
ChangeNotifier
BuildContext
BackdropFilter
Padding

