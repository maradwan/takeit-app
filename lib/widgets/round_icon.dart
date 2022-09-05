import 'package:flutter/material.dart';

class RoundIcon extends StatelessWidget {
  final IconData icon;
  final double radius;
  final double iconSize;
  final Color backgroundColor;
  final Color iconColor;

  const RoundIcon({
    required this.icon,
    required this.radius,
    required this.iconSize,
    required this.backgroundColor,
    required this.iconColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor,
      ),
    );
  }
}
