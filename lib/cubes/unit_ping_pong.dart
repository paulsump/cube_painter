import 'dart:math';
import 'dart:ui';

/// a value between 0 and 1 but goes up and down like a sine wave.
double calcUnitPingPong(double unitValue) => (1 + sin(2 * pi * unitValue)) / 2;

/// just calls lerpDouble with the bang operator
/// TODO REMOVE lerp
double lerp(double start, double end, unitValue) =>
    lerpDouble(start, end, unitValue)!;
