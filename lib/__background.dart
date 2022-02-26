import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          // colors: <Color>[Colors.red, Colors.black],
          colors: <Color>[Colors.red, Colors.black],
        ),
      ),
    );
  }
}
