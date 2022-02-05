
import 'package:flutter/material.dart';

class Background extends StatefulWidget {
  const Background({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'TODO',
            ),
          ],
        ),
      ),
    );
  }
}
