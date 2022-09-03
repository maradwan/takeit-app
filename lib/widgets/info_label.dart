import 'package:flutter/material.dart';
import 'package:travel_app/util/app_theme.dart';

class InfoLabel extends StatelessWidget {
  final String label;
  const InfoLabel({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          Icon(
            Icons.info,
            color: Colors.blue[300],
            size: 20,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTheme.subtitle,
          ),
        ],
      ),
    );
  }
}
