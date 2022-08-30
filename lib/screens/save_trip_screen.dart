import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:travel_app/model/item.dart';
import 'package:travel_app/widgets/city_search_delegate.dart';
import 'package:travel_app/widgets/form_section.dart';
import 'package:travel_app/widgets/info_label.dart';
import 'package:travel_app/widgets/input_place_holder.dart';

class SaveTripScreen extends StatefulWidget {
  static const String routeName = '/save-trip';
  const SaveTripScreen({Key? key}) : super(key: key);

  @override
  SaveTripScreenState createState() => SaveTripScreenState();
}

class SaveTripScreenState extends State<SaveTripScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final DateFormat formatter = DateFormat('dd.MM.yyyy');

  final Map<String, dynamic> _formData = {
    'fromCountry': null,
    'fromCity': null,
    'toCountry': null,
    'toCity': null,
    'deptDate': null,
    'acceptFrom': null,
    'acceptTo': null,
    'currencyName': null,
    'currencyCode': null,
    'items': <Item>[Item('Clothes', 10, 5), Item('Electronics', 20, 25)],
  };

  bool validateAcceptDates(String? from, String? to) {
    if (from == null || to == null) {
      return true;
    }

    final fromDate = formatter.parse(from);
    final toDate = formatter.parse(to);
    return fromDate.isAtSameMomentAs(toDate) || fromDate.isBefore(toDate);
  }

  @override
  Widget build(BuildContext context) {
    final items = _formData['items'] as List<Item>;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        title: const Text('Save Trip'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                FormSection(
                  title: 'Trip Details',
                  children: [
                    InputPlaceholder(
                      padding: 10,
                      text:
                          '${_formData['fromCountry']}, ${_formData['fromCity']}',
                      placeholderText: 'From: City',
                      showPlaceHolder: _formData['fromCity'] == null,
                      fontSize: 16,
                      icon: Icons.flight_takeoff,
                      onClick: () async {
                        final result = await showSearch(
                          context: context,
                          delegate: CitySearchDelegate(),
                        );
                        if (result != null) {
                          setState(() {
                            _formData['fromCountry'] = result['country'];
                            _formData['fromCity'] = result['city'];
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    InputPlaceholder(
                      padding: 10,
                      text: '${_formData['toCountry']}, ${_formData['toCity']}',
                      placeholderText: 'To: City',
                      fontSize: 16,
                      showPlaceHolder: _formData['toCity'] == null,
                      icon: Icons.flight_land,
                      onClick: () async {
                        final result = await showSearch(
                          context: context,
                          delegate: CitySearchDelegate(),
                        );
                        if (result != null) {
                          setState(() {
                            setState(() {
                              _formData['toCountry'] = result['country'];
                              _formData['toCity'] = result['city'];
                            });
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    InputPlaceholder(
                      padding: 10,
                      text: '${_formData['deptDate']}',
                      placeholderText: 'Departure date',
                      fontSize: 16,
                      showPlaceHolder: _formData['deptDate'] == null,
                      icon: Icons.calendar_month,
                      onClick: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100));
                        if (pickedDate != null) {
                          setState(() {
                            _formData['deptDate'] =
                                formatter.format(pickedDate);
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(
                          child: InputPlaceholder(
                            padding: 10,
                            text: '${_formData['acceptFrom']}',
                            placeholderText: 'Accept from',
                            fontSize: 16,
                            showPlaceHolder: _formData['acceptFrom'] == null,
                            icon: Icons.calendar_month,
                            onClick: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: _formData['acceptFrom'] != null
                                      ? formatter
                                          .parse(_formData['acceptFrom']!)
                                      : DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100));
                              if (pickedDate != null) {
                                if (!validateAcceptDates(
                                    formatter.format(pickedDate),
                                    _formData['acceptTo'])) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: const Text(
                                        'Accept from date should be before or equal to accept to date'),
                                    backgroundColor: Colors.red[700],
                                  ));
                                  return;
                                }
                                setState(() {
                                  _formData['acceptFrom'] =
                                      formatter.format(pickedDate);
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: InputPlaceholder(
                            padding: 10,
                            text: '${_formData['acceptTo']}',
                            placeholderText: 'Accept to',
                            fontSize: 16,
                            showPlaceHolder: _formData['acceptTo'] == null,
                            icon: Icons.calendar_month,
                            onClick: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: _formData['acceptTo'] != null
                                      ? formatter.parse(_formData['acceptTo']!)
                                      : _formData['acceptFrom'] != null
                                          ? formatter
                                              .parse(_formData['acceptFrom']!)
                                          : DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100));
                              if (pickedDate != null) {
                                if (!validateAcceptDates(
                                    _formData['acceptFrom'],
                                    formatter.format(pickedDate))) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: const Text(
                                        'Accept from date should be before or equal to accept to date'),
                                    backgroundColor: Colors.red[700],
                                  ));
                                  return;
                                }
                                setState(() {
                                  _formData['acceptTo'] =
                                      formatter.format(pickedDate);
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    InputPlaceholder(
                      padding: 10,
                      text:
                          '${_formData['currencyName']} (${_formData['currencyCode']})',
                      placeholderText: 'Currency',
                      fontSize: 16,
                      showPlaceHolder: _formData['currencyName'] == null,
                      icon: FontAwesomeIcons.dollarSign,
                      onClick: () async {
                        showCurrencyPicker(
                          context: context,
                          showFlag: true,
                          showCurrencyName: true,
                          showCurrencyCode: true,
                          onSelect: (Currency currency) {
                            setState(() {
                              _formData['currencyName'] = currency.name;
                              _formData['currencyCode'] = currency.code;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
                FormSection(
                  title: 'Allowed Items',
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: TextButton.icon(
                          onPressed: () => _showItemsDialog(context, null, 0),
                          icon: const Icon(
                            Icons.add_circle,
                            size: 32,
                          ),
                          label: const Text('Add Item')),
                    ),
                    if (items.length > 1)
                      const InfoLabel(label: 'Long press to reorder the list'),
                    // ReorderableListView(
                    //   shrinkWrap: true,
                    //   children: [
                    //     for (int index = 0;
                    //         index < _ingredients.length;
                    //         index += 1)
                    //       Column(
                    //         key: Key('$index'),
                    //         children: [
                    //           Slidable(
                    //             key: Key('$index'),
                    //             endActionPane: ActionPane(
                    //               motion: const ScrollMotion(),
                    //               children: [
                    //                 SlidableAction(
                    //                   onPressed: (_) =>
                    //                       _showIngredientsDialog(context,
                    //                           _ingredients[index], index),
                    //                   foregroundColor:
                    //                       FitnessAppTheme.nearlyBlue,
                    //                   icon: Icons.edit,
                    //                   label: 'Edit',
                    //                 ),
                    //                 SlidableAction(
                    //                   onPressed: (_) => setState(() {
                    //                     _ingredients.removeAt(index);
                    //                   }),
                    //                   foregroundColor: Color(0xFFFE4A49),
                    //                   icon: Icons.delete,
                    //                   label: 'Delete',
                    //                 ),
                    //               ],
                    //             ),
                    //             child: ListTile(
                    //               title:
                    //                   Text('${_ingredients[index].name}'),
                    //               subtitle: Text(
                    //                   '${_ingredients[index].amount} ${_ingredients[index].unit}'),
                    //             ),
                    //           ),
                    //           if (index < _ingredients.length - 1)
                    //             Divider(
                    //               color: Colors.black12,
                    //             ),
                    //         ],
                    //       ),
                    //   ],
                    //   onReorder: (int oldIndex, int newIndex) {
                    //     setState(() {
                    //       if (oldIndex < newIndex) {
                    //         newIndex -= 1;
                    //       }
                    //       final Ingredient item =
                    //           _ingredients.removeAt(oldIndex);
                    //       _ingredients.insert(newIndex, item);
                    //     });
                    //   },
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showItemsDialog(BuildContext context, Item? item, int index) {
    final items = _formData['items'] as List<Item>;

    String name = item != null ? item.name : "";
    double kg = item != null ? item.kg : 0;
    double price = item != null ? item.price : 0;

    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Items'),
            insetPadding: const EdgeInsets.all(20),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Form(
                //key: _ingredientsFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InputPlaceholder(
                      padding: 10,
                      text: '',
                      placeholderText: 'Item type',
                      fontSize: 16,
                      showPlaceHolder: true,
                      icon: FontAwesomeIcons.box,
                      onClick: () async {},
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
                      icon: FontAwesomeIcons.dollarSign,
                      onClick: () async {},
                    ),
                  ],
                ),
              ),
            ),
            actionsPadding: const EdgeInsets.all(15),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: const Text('close'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              )
            ],
          );
        });
  }
}
