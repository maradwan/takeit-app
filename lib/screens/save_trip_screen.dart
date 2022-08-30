import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_app/widgets/city_search_delegate.dart';
import 'package:travel_app/widgets/form_section.dart';
import 'package:travel_app/widgets/input_place_holder.dart';

class SaveTripScreen extends StatefulWidget {
  static const String routeName = '/save-trip';
  const SaveTripScreen({Key? key}) : super(key: key);

  @override
  SaveTripScreenState createState() => SaveTripScreenState();
}

class SaveTripScreenState extends State<SaveTripScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
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
                      text: '',
                      placeholderText: 'From: City',
                      showPlaceHolder: true,
                      icon: Icons.flight_takeoff,
                      onClick: () async {
                        final result = await showSearch(
                          context: context,
                          delegate: CitySearchDelegate(),
                        );
                        if (result != null) {
                          // setState(() {
                          //   takeoffCountry = result['country'];
                          //   takeoffCity = result['city'];
                          // });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    InputPlaceholder(
                      padding: 10,
                      text: '',
                      placeholderText: 'To: City',
                      showPlaceHolder: true,
                      icon: Icons.flight_land,
                      onClick: () async {
                        final result = await showSearch(
                          context: context,
                          delegate: CitySearchDelegate(),
                        );
                        if (result != null) {
                          // setState(() {
                          //   takeoffCountry = result['country'];
                          //   takeoffCity = result['city'];
                          // });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    InputPlaceholder(
                      padding: 10,
                      text: '',
                      placeholderText: 'Departure date',
                      showPlaceHolder: true,
                      icon: Icons.calendar_month,
                      onClick: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2100));
                        if (pickedDate != null) {
                          // setState(() {
                          //   takeoffCountry = result['country'];
                          //   takeoffCity = result['city'];
                          // });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Flexible(
                          child: InputPlaceholder(
                            padding: 10,
                            text: '',
                            placeholderText: 'Accept from',
                            showPlaceHolder: true,
                            icon: Icons.calendar_month,
                            onClick: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2100));
                              if (pickedDate != null) {
                                // setState(() {
                                //   takeoffCountry = result['country'];
                                //   takeoffCity = result['city'];
                                // });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: InputPlaceholder(
                            padding: 10,
                            text: '',
                            placeholderText: 'Accept to',
                            showPlaceHolder: true,
                            icon: Icons.calendar_month,
                            onClick: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2100));
                              if (pickedDate != null) {
                                // setState(() {
                                //   takeoffCountry = result['country'];
                                //   takeoffCity = result['city'];
                                // });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    InputPlaceholder(
                      padding: 10,
                      text: '',
                      placeholderText: 'Currency',
                      showPlaceHolder: true,
                      icon: FontAwesomeIcons.dollarSign,
                      onClick: () async {
                        showCurrencyPicker(
                          context: context,
                          showFlag: true,
                          showCurrencyName: true,
                          showCurrencyCode: true,
                          onSelect: (Currency currency) {
                            print('Select currency: ${currency.code}');
                          },
                        );
                      },
                    ),
                  ],
                ),
                const FormSection(
                  title: 'Allowed Items',
                  children: [],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
