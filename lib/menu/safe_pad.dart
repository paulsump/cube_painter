import 'package:flutter/material.dart';

/// padding for the safe area at the top
class SafePad extends StatelessWidget {
  const SafePad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      SizedBox(height: 10.0 + MediaQuery.of(context).padding.top);
}
