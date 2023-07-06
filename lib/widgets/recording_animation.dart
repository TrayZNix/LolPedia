import 'package:flutter/material.dart';

class RecordingIndicator extends StatefulWidget {
  @override
  _RecordingIndicatorState createState() => _RecordingIndicatorState();
}

class _RecordingIndicatorState extends State<RecordingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _animationController.value >= 0.5
                ? Colors.red
                : Colors.transparent,
            border: Border.all(color: Colors.red, width: 2),
          ),
        );
      },
    );
  }
}

class MyFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.white,
      onPressed: () {},
      child: Stack(
        alignment: Alignment.center,
        children: [
          RecordingIndicator(),
          Icon(Icons.camera_alt, color: Colors.black),
        ],
      ),
    );
  }
}
