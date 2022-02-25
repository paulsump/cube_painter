import 'package:flutter/material.dart';

class SafePad extends StatelessWidget {
  const SafePad({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 10.0 + MediaQuery.of(context).padding.top);
  }
}
