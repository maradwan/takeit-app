import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ItemTypeOptionList extends StatefulWidget {
  final String? selectedValue;
  const ItemTypeOptionList({Key? key, this.selectedValue}) : super(key: key);

  @override
  State<ItemTypeOptionList> createState() => _ItemTypeOptionListState();
}

class _ItemTypeOptionListState extends State<ItemTypeOptionList> {
  String? _selectedValue;

  @override
  void initState() {
    setState(() {
      _selectedValue = widget.selectedValue;
    });
    super.initState();
  }

  final _options = [
    [
      {'title': 'Parper', 'icon': FontAwesomeIcons.file},
      {'title': 'Medicine', 'icon': FontAwesomeIcons.capsules},
      {'title': 'Clothes', 'icon': FontAwesomeIcons.shirt},
    ],
    [
      {'title': 'Electronics', 'icon': FontAwesomeIcons.mobile},
      {'title': 'Bag', 'icon': FontAwesomeIcons.suitcaseRolling},
      {'title': 'Others', 'icon': FontAwesomeIcons.box},
    ]
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._options
            .map(
              (row) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: row
                    .map(
                      (option) => ChoiceChip(
                          labelPadding: const EdgeInsets.all(3),
                          label: Text(option['title'] as String),
                          selected: _selectedValue == option['title'] as String,
                          avatar: Icon(
                            option['icon'] as IconData,
                            size: 20,
                          ),
                          selectedColor: Colors.teal[200],
                          labelStyle: TextStyle(
                            color: _selectedValue == option['title'] as String
                                ? Colors.white
                                : Colors.black,
                          ),
                          onSelected: (bool selected) {
                            setState(() {
                              _selectedValue =
                                  selected ? option['title'] as String : null;
                            });
                          }),
                    )
                    .toList(),
              ),
            )
            .toList(),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            child: const Text('Select'),
            onPressed: () => Navigator.pop(context, _selectedValue),
          ),
        ),
      ],
    );
  }
}
