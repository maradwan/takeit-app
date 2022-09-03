import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_app/util/app_theme.dart';
import 'package:travel_app/widgets/input_place_holder.dart';
import 'package:travel_app/widgets/item_type_option_list.dart';

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  String name = '';
  double kg = 0;
  double price = 0;

  @override
  Widget build(BuildContext context) {
    return Form(
      //key: _ingredientsFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          InputPlaceholder(
            padding: 10,
            text: name,
            placeholderText: 'Item type',
            fontSize: 16,
            showPlaceHolder: name == '',
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
                        selectedValue: name,
                      ),
                    ],
                  ),
                ),
              );
              setState(() {
                name = selectedValue ?? '';
              });
            },
          ),
          const SizedBox(height: 10),
          InputPlaceholder(
            padding: 10,
            text: '',
            placeholderText: 'Avaliable KGs',
            fontSize: 16,
            showPlaceHolder: true,
            icon: FontAwesomeIcons.weightHanging,
            onClick: () async {},
          ),
          const SizedBox(height: 10),
          InputPlaceholder(
            padding: 10,
            text: '',
            placeholderText: 'Price per KG',
            fontSize: 16,
            showPlaceHolder: true,
            icon: FontAwesomeIcons.moneyCheck,
            onClick: () async {},
          ),
        ],
      ),
    );
  }
}
