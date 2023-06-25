import 'package:flutter/material.dart';

class TitleView extends StatelessWidget {
  final String titleTxt;
  final double paddingValue;

  const TitleView({
    Key? key,
    this.titleTxt = "",
    this.paddingValue = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: paddingValue, right: paddingValue),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              titleTxt,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                letterSpacing: 0.5,
                color: Color(0xFF4A6572),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
