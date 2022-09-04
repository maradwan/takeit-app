import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_app/model/item.dart';
import 'package:travel_app/util/app_theme.dart';
import 'package:travel_app/widgets/input_place_holder.dart';
import 'package:travel_app/widgets/input_widget.dart';
import 'package:travel_app/widgets/item_type_option_list.dart';

class AddItem extends StatefulWidget {
  final String? itemType;
  final double? kg;
  final double? price;
  final List<Item> items;

  const AddItem({
    Key? key,
    this.itemType,
    this.kg,
    this.price,
    required this.items,
  }) : super(key: key);

  @override
  AddItemState createState() => AddItemState();
}

class AddItemState extends State<AddItem> {
  String? itemType;
  double? kg;
  double? price;

  @override
  void initState() {
    itemType = widget.itemType;
    kg = widget.kg;
    price = widget.price;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.itemType == null)
          InputPlaceholder(
            padding: 10,
            text: itemType ?? '',
            placeholderText: 'Item type',
            fontSize: 16,
            showPlaceHolder: itemType == null,
            icon: FontAwesomeIcons.box,
            onClick: () async {
              final selectedValue = await showModalBottomSheet(
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                backgroundColor: Colors.white,
                context: context,
                builder: (ctx) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Select item type',
                        style: AppTheme.title,
                      ),
                      const SizedBox(height: 10),
                      const Divider(thickness: 1),
                      const SizedBox(height: 10),
                      ItemTypeOptionList(
                        selectedValue: itemType,
                        disabledValues:
                            widget.items.map((item) => item.name).toSet(),
                      ),
                    ],
                  ),
                ),
              );
              if (selectedValue != null) {
                setState(() {
                  itemType = selectedValue ?? '';
                  if (selectedValue == 'Paper') {
                    kg = null;
                  }
                });
              }
            },
          ),
        const SizedBox(height: 10),
        if (itemType != 'Paper')
          InputWidget(
            suffixIcon: FontAwesomeIcons.weightHanging,
            hintText: 'Avaliable KGs',
            keyboardType: TextInputType.number,
            initialValue: kg?.toString(),
            onchaged: (value) {
              if (value == null || double.tryParse(value) == null) {
                setState(() {
                  kg = null;
                });
                return;
              }
              setState(() {
                kg = double.parse(value);
              });
            },
          ),
        const SizedBox(height: 10),
        InputWidget(
          suffixIcon: FontAwesomeIcons.moneyBillWave,
          hintText:
              'Price ${itemType != '' ? itemType == 'Paper' ? 'per document' : 'per KG' : ''}',
          keyboardType: TextInputType.number,
          initialValue: price?.toString(),
          onchaged: (value) {
            if (value == null || double.tryParse(value) == null) {
              setState(() {
                price = null;
              });
              return;
            }
            setState(() {
              price = double.parse(value);
            });
          },
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              onSurface: Colors.teal,
            ),
            onPressed: (itemType != null && kg != null && price != null) ||
                    (itemType == 'Paper' && price != null)
                ? () {
                    if (widget.itemType == null) {
                      widget.items.add(Item(itemType!, price!, kg ?? 0));
                    } else {
                      final index = widget.items
                          .indexWhere((item) => item.name == widget.itemType);
                      if (index != -1) {
                        widget.items.removeAt(index);
                        widget.items.insert(
                            index, Item(widget.itemType!, price!, kg ?? 0));
                      }
                    }
                    Navigator.pop(context, widget.items);
                  }
                : null,
            child: const Text('Save'),
          ),
        )
      ],
    );
  }
}
