# Cube Painter ![logo](https://github.com/paulsump/cube_painter/blob/98a52da01cb1108a178e1a22b418b98a05f2c382/android/app/src/main/res/mipmap-hdpi/ic_launcher.png)

A painting app, but the 'paint' is cubes.  
For making paintings that don’t make sense, like Escher did.  
It's a free app on iOS and Android.  It's just a demo to get a Flutter job (Here's my [cv](https://docs.google.com/document/d/1pJ0Z6Hwg2_puwV0F2RATEuoNEGqLUk81_d2qdfV6PC8/edit?usp=sharing))!


## Getting Started

[Video](https://www.dropbox.com/s/fj40rq3rd2d5led/C0606.MP4?dl=0)

| Add lines of cubes  | Pan and zoom | Erase |
| ------------- | ------------- | ------------- |
| <img src="https://github.com/paulsump/cube_painter/blob/2049ca6da2a6231c3e980608b48249efaccac9b0/images/oneFinger.png" width="248">  | <img src="https://github.com/paulsump/cube_painter/blob/2049ca6da2a6231c3e980608b48249efaccac9b0/images/twoFinger.png" width="248"> | <img src="https://github.com/paulsump/cube_painter/blob/2049ca6da2a6231c3e980608b48249efaccac9b0/images/eraseLine.png" width="248"> | 

| Places slices of cubes... | ...that you pick from a menu |
| ------------- | ------------- |
| <img src="https://github.com/paulsump/cube_painter/blob/2049ca6da2a6231c3e980608b48249efaccac9b0/images/placeSlice.png" width="248"> | <img src="https://github.com/paulsump/cube_painter/blob/2049ca6da2a6231c3e980608b48249efaccac9b0/images/slicesMenu.png" width="248"> |

## Implementation
  - A standalone Flutter app working on Android and iOS using Provider.
  - StatelessWidgets wherever possible.
  - There's a documentation comment at the top of every class.

### Main classes

- The main page is PainterPage. This contains all the widgets that are draw.
- The Brusher draws AnimatedCubes while you drag a line of cubes.
- The Animator turns them into StaticCubes when you've finished dragging a line of cubes.
- The Persister saves the Position of each cube in a list of CubeInfos in the Painting class.
- Animator and Persister are mixins for the Paintings Provider.

### Source Folders

#### buttons/

All buttons are hexagon shaped to match the angles of the isometric grid.  There have Icons, AssetIcons (downloaded from fluttericon.com), Cubes and Thumbnails of Paintings.

##### Hexagon Buttons

ElevatedButton and TextButton ButtonStyle.shape is set to my HexagonBorder which extends
OutlinedBorder in a similar way to CircleBorder.

#### cubes/

There are StaticCubes and animated cubes (BrushCubes and GrowingCubes).  Their appearance can be WholeUnitCube, SliceUnitCube or WireUnitCube.

#### gestures/

The Gesturer passes onScale* and onTap* gesture to two types of GestureHandler, Brusher and
PanZoomer The Brusher creates or erases lines of cubes or single Slices of cube. The PanZoomer
modifies the PanZoom.scale and PanZoom.offset

#### persisted/

The Persister stores and persists the position and type of cubes (CubeInfo) in a map of <fileName,
Painting>. The PaintingBank uses mixin Persister, but also mixin Animator because it needs to
animate the current painting when it is being created and loaded.

#### transform/

There are three coordinate spaces, screen, UnitOffset and Position.  
These classes transform positions between them. Position is in a skewed grid space allowing an
isometric grid to be saved in x, y integer Positions. The UnitOffset comes out of the grid space
into normal cartesian coordinates, but without the PanZoom scale and offset factored in. The screen
space is the unit offset transformed by the PanZoom scale and offset.

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

