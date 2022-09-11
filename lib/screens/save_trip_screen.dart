import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:travel_app/model/item.dart';
import 'package:travel_app/model/trip.dart';
import 'package:travel_app/service/trip_service.dart';
import 'package:travel_app/util/app_theme.dart';
import 'package:travel_app/util/item_util.dart';
import 'package:travel_app/widgets/add_item.dart';
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
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  var isSaving = false;
  bool isInit = true;
  late Map<String, dynamic> _formData;

  @override
  void didChangeDependencies() {
    if (isInit) {
      final argMap =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final trip = argMap['trip'] as Trip?;
      final currencyService = CurrencyService();

      _formData = {
        'created': trip?.created,
        'fromCountry': trip?.fromCity.split('-')[1],
        'fromCity': trip?.fromCity.split('-')[0],
        'toCountry': trip?.toCity.split('-')[1],
        'toCity': trip?.toCity.split('-')[0],
        'deptDate': trip == null ? null : formatter.format(trip.trDate),
        'acceptFrom': trip == null ? null : formatter.format(trip.acceptFrom),
        'acceptTo': trip == null ? null : formatter.format(trip.acceptTo),
        'currencyName': currencyService.findByCode(trip?.currency)?.name,
        'currencyCode': trip?.currency,
        'items': trip == null ? <Item>[] : trip.allowedItems,
      };
    }
    isInit = false;
    super.didChangeDependencies();
  }

  bool validateAcceptDates(String? from, String? to) {
    if (from == null || to == null) {
      return true;
    }

    final fromDate = formatter.parse(from);
    final toDate = formatter.parse(to);
    return fromDate.isAtSameMomentAs(toDate) || fromDate.isBefore(toDate);
  }

  void _showSnackbar(String message, String type) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: type == 'error' ? Colors.red[700] : Colors.teal[700],
    ));
  }

  Future<void> _saveTrip() async {
    final items = _formData['items'] as List<Item>;

    if (_formData['fromCountry'] == null ||
        _formData['fromCity'] == null ||
        _formData['toCountry'] == null ||
        _formData['toCity'] == null ||
        _formData['deptDate'] == null ||
        _formData['acceptFrom'] == null ||
        _formData['acceptTo'] == null ||
        _formData['currencyCode'] == null ||
        items.isEmpty) {
      _showSnackbar(
          items.isEmpty
              ? 'You must add at least one allowed item'
              : 'Enter all trip details',
          'error');
      return;
    }
    setState(() {
      isSaving = true;
    });

    final trip = Trip(
      _formData['created'],
      formatter.parse(_formData['acceptFrom']),
      formatter.parse(_formData['acceptTo']),
      formatter.parse(_formData['deptDate']),
      '${_formData['fromCity']}-${_formData['fromCountry']}',
      '${_formData['toCity']}-${_formData['toCountry']}',
      _formData['currencyCode'],
      items,
    );
    try {
      final savedTrip = _formData['created'] == null
          ? await TripService().save(trip)
          : await TripService().updateTrip(trip);

      if (!mounted) {
        return;
      }
      _showSnackbar('Trip saved successfully', 'success');
      Navigator.pop(context, savedTrip);
    } on Exception catch (e) {
      debugPrint(e.toString());
      _showSnackbar('Something went wrong, please try again', 'error');
    }
    setState(() {
      isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = _formData['items'] as List<Item>;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        title: Text(_formData['created'] == null ? 'Add Trip' : 'Edit Trip'),
        foregroundColor: Colors.white,
        actions: [
          isSaving
              ? Container(
                  width: 60,
                  alignment: Alignment.center,
                  child: const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                )
              : SizedBox(
                  width: 60,
                  child: TextButton(
                      onPressed: _saveTrip,
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                )
        ],
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
                                  _showSnackbar(
                                      'Accept from date should be before or equal to accept to date',
                                      'error');
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
                                  _showSnackbar(
                                      'Accept from date should be before or equal to accept to date',
                                      'error');
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
                    ReorderableListView(
                      shrinkWrap: true,
                      children: [
                        for (int index = 0; index < items.length; index += 1)
                          Column(
                            key: Key('$index'),
                            children: [
                              Slidable(
                                key: Key('$index'),
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (_) => _showItemsDialog(
                                          context, items[index], index),
                                      foregroundColor: Colors.blue,
                                      icon: Icons.edit,
                                      label: 'Edit',
                                    ),
                                    SlidableAction(
                                      onPressed: (_) => setState(() {
                                        items.removeAt(index);
                                      }),
                                      foregroundColor: const Color(0xFFFE4A49),
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        ItemUtil.itemToIcon[items[index].name],
                                        size: 32,
                                      ),
                                    ],
                                  ),
                                  title: Text(
                                    items[index].name,
                                    style: AppTheme.title,
                                  ),
                                  subtitle: Text(items[index].name == 'Paper'
                                      ? ''
                                      : 'Avaliable  ${items[index].kg.toStringAsFixed(items[index].kg.truncateToDouble() == items[index].kg ? 0 : 1)} KG'),
                                  trailing: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Price'),
                                      Text(
                                        items[index].price == 0
                                            ? 'Free'
                                            : '${_formData['currencyCode'] ?? ''}${items[index].price.toStringAsFixed(items[index].price.truncateToDouble() == items[index].price ? 0 : 1)} /KG',
                                        style: AppTheme.title,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (index < items.length - 1)
                                const Divider(
                                  color: Colors.black38,
                                ),
                            ],
                          ),
                      ],
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final Item item = items.removeAt(oldIndex);
                          items.insert(newIndex, item);
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showItemsDialog(BuildContext context, Item? item, int index) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            scrollable: true,
            title: Text(item == null ? 'Add Item' : 'Edit ${item.name}'),
            insetPadding: const EdgeInsets.all(20),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: AddItem(
                itemType: item?.name,
                kg: item?.kg,
                price: item?.price,
                items: _formData['items'] as List<Item>,
              ),
            ),
          );
        });
  }
}
