import 'package:flutter/material.dart';
import 'package:travel_app/widgets/title_view.dart';

class FormSection extends StatelessWidget {
  const FormSection({this.title, required this.children, Key? key})
      : super(key: key);

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null && title != '')
          Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TitleView(
                      titleTxt: title!,
                      paddingValue: 8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }
}
