/// The vertex / corner of the cube
/// Used to represent the side of the cube
/// anti clockwise from top right
// TODO Rename to side
enum Side {
  // 0 top
  t,
  // 1 bottom left
  bl,
  // 2 bottom right
  br
}

/// The direction to crop a cube in is like the
/// normal vector to the slice line.
/// So it's sliced perpendicular to the cropping direction
/// anti clockwise from right
enum Crop {
  // 0 center
  c,
  // 1 right
  r,
  // 2 up right
  ur,
  // 3 up left
  ul,
  // 4 left
  l,
  // 5 down left
  dl,
  // 6 down right
  dr,
}
