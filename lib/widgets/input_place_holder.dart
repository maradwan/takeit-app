import 'package:flutter/material.dart';

class InputPlaceholder extends StatelessWidget {
  final String text;
  final IconData icon;
  final String placeholderText;
  final bool showPlaceHolder;
  final double padding;
  final Function() onClick;

  const InputPlaceholder({
    Key? key,
    required this.text,
    required this.icon,
    required this.placeholderText,
    required this.showPlaceHolder,
    required this.padding,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Text(
              showPlaceHolder ? placeholderText : text,
              style: showPlaceHolder
                  ? TextStyle(fontSize: 18, color: Colors.grey[500])
                  : const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
