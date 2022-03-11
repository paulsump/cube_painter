// Copyright (c) 2022, Paul Sumpner.  All rights reserved.

import 'dart:math';

/// Calculate a value between 0 and 1 but goes up and down like a sine wave.
double calcUnitPingPong(double unitValue) => (1 + sin(2 * pi * unitValue)) / 2;
