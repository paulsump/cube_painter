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

### Main classes

- The main page is PainterPage.  This contains all the widgets that are draw.
- The Brusher draws AnimatedCubes while you drag a line of cubes.
- The Animator turns them into StaticCubes when you've finished dragging a line of cubes.
- The Persister saves the Position of each cube in a list of CubeInfos in the Painting class.
- Animator and Persister are mixins for the Paintings Provider.

### Hexagon Buttons
ElevatedButton and TextButton ButtonStyle.shape is set to my HexagonBorder which extends OutlinedBorder in a similar way to CircleBorder.


### Tests
- All the mathematical functions have tests.
- All the persisted classes have json tests.
- There are no widget tests per se.


## Dependencies

### Packages

- provider
- path_provider.

### Persistence

Local files are persisted with jsonEncode & jsonDecode.

### Flutter Widgets

StatelessWidget StatefulWidget Stack Transform Tooltip SizedBox ElevatedButton TextButton Row Column
Container Icon Scaffold Drawer CustomPaint AlertDialog SafeArea LayoutBuilder MaterialApp
WillPopScope Divider ListView Center Text RichText Provider Align Navigator AnimatedBuilder
SingleTickerProviderStateMixin State BackdropFilter Padding

### Other Flutter classes
ThemeData
BoxDecoration
TooltipThemeData
Clipboard
ChangeNotifierProvider
Offset
ButtonStyle IconData OutlinedBorder MaterialStateProperty
ShapeBorder
Path
List
AnimationController
Duration
Paint
Alignment
LinearGradient
UnmodifiableListView
ChangeNotifier
BuildContext

