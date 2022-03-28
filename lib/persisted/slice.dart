// © 2022, Paul Sumpner <sumpner@hotmail.com>

/// Like a slice of pizza, but you get half.
/// These enums say which half e.g. left or right half,
/// or whole for a normal, complete cube.
/// The values are go around anti clockwise from the left.
enum Slice { whole, left, bottomLeft, bottomRight, right, topRight, topLeft }

String getSliceName(Slice slice) => slice.toString().split('.').last;
