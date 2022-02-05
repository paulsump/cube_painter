
import 'package:cube_painter/shared/colors.dart';
import 'package:cube_painter/shared/screen.dart';
import 'package:flutter/material.dart';


/// animated background
class Background extends StatefulWidget {
  const Background({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BackgroundState();
}

class BackgroundState extends State<Background>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 80),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Screen.init(context);

    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              children: [
                Container(
                  color: colorSequence
                      .evaluate(AlwaysStoppedAnimation(_controller.value)),
                ),
                // const ExtruderWidget(),
              ],
            );
          },
        ),
      ),
    );
  }
}
