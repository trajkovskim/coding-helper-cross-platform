import 'package:flutter/material.dart';

defaultShadow(double radius) {
  return BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(radius)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        spreadRadius: -4,
        blurRadius: 4,
        offset: const Offset(0, 1),
      ),
    ],
  );
}

class ShadowContainer extends StatelessWidget {
  const ShadowContainer({Key? key, required this.radius, this.child}) : super(key: key);

  final double radius;
  final Widget? child;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: defaultShadow(radius),
      child: child,
    );
  }
}


