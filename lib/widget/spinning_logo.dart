import 'package:flutter/material.dart';
import 'dart:math' as math;

class SpinningContainer extends AnimatedWidget {
  const SpinningContainer({
    super.key,
    required AnimationController controller,
  }) : super(listenable: controller);
  Animation<double> get _progress => listenable as Animation<double>;
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: _progress.value * 25.0 * math.pi,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/logo/ic_launcher.png"))
        ),
      ),
    );
  }
}