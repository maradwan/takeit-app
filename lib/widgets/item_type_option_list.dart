import 'package:flutter/material.dart';
import 'package:travel_app/util/item_util.dart';

class ItemTypeOptionList extends StatefulWidget {
  final String? selectedValue;
  final Set<String> disabledValues;
  const ItemTypeOptionList({
    Key? key,
    this.selectedValue,
    required this.disabledValues,
  }) : super(key: key);

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
    ['Paper', 'Medicine', 'Clothes'],
    ['Electronics', 'Bag', 'Others']
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: row
                    .map(
                      (option) => Column(
                        children: [
                          ChoiceChip(
                            labelPadding: const EdgeInsets.all(3),
                            label: Text(option),
                            selected: _selectedValue == option,
                            avatar: Icon(
                              ItemUtil.itemToIcon[option],
                              size: 20,
                            ),
                            selectedColor: Colors.teal[200],
                            labelStyle: TextStyle(
                              color: _selectedValue == option
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            onSelected: !widget.disabledValues.contains(option)
                                ? (bool selected) {
                                    setState(() {
                                      _selectedValue = selected ? option : null;
                                    });
                                  }
                                : null,
                          ),
                          const SizedBox(height: 10), // Add Y spacing here
                        ],
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            child: const Text('Done'),
            onPressed: () => Navigator.pop(context, _selectedValue),
          ),
        ),
      ],
    );
  }
}
