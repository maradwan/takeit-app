import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:travel_app/model/contacts.dart';
import 'package:travel_app/model/requester_share_request.dart';
import 'package:travel_app/model/trip.dart';
import 'package:travel_app/service/contacts_service.dart';
import 'package:travel_app/widgets/form_section.dart';

class RequesterRequestContactInfoScreen extends StatefulWidget {
  static const String routeName = '/requester-request-contact';

  const RequesterRequestContactInfoScreen({Key? key}) : super(key: key);

  @override
  RequesterRequestContactInfoScreenState createState() =>
      RequesterRequestContactInfoScreenState();
}

class RequesterRequestContactInfoScreenState
    extends State<RequesterRequestContactInfoScreen> {
  bool isLoadingContacts = true;
  Contacts? contacts;

  Future<Contacts?> _findContacts(RequesterShareRquest request) async {
    try {
      return await ContactsService().findContacts(
        request.tripId,
        request.created.split('_')[2],
        true,
      );
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  bool isNoContactsShared(Contacts? userContacts) {
    return userContacts == null ||
        (userContacts.name == null &&
            userContacts.mobile == null &&
            userContacts.email == null &&
            userContacts.facebook == null &&
            userContacts.instagram == null &&
            userContacts.twitter == null &&
            userContacts.linkedIn == null &&
            userContacts.telegram == null);
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final argsMap =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final request = argsMap['request'] as RequesterShareRquest;
      final travelerContacts = await _findContacts(request);
      setState(() {
        contacts = travelerContacts;
        isLoadingContacts = false;
      });
    });
    super.initState();
  }

  void _showSnackbar(String message, String type) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: type == 'error' ? Colors.red[700] : Colors.teal[700],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final argsMap =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final trip = argsMap['trip'] as Trip;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        titleTextStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(trip.fromCity.split('-')[0]),
                const SizedBox(width: 10),
                const Icon(FontAwesomeIcons.plane, size: 14),
                const SizedBox(width: 10),
                Text(trip.toCity.split('-')[0]),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.flight_land),
                const SizedBox(width: 5),
                Text(formatter.format(trip.trDate)),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(15),
          child: isLoadingContacts
              ? const FormSection(
                  children: [
                    Center(
                      child: SizedBox(
                        width: 60,
                        child: LoadingIndicator(
                          strokeWidth: 1,
                          indicatorType: Indicator.ballPulse,
                        ),
                      ),
                    ),
                  ],
                )
              : isNoContactsShared(contacts)
                  ? FormSection(
                      children: [
                        Center(
                          child: Text(
                            'No contacts found',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        )
                      ],
                    )
                  : FormSection(
                      children: [
                        if (contacts!.name != null)
                          ListTile(
                            leading: const Icon(FontAwesomeIcons.solidUser),
                            title: Text(contacts!.name!),
                            trailing: InkWell(
                                onTap: () {
                                  Clipboard.setData(
                                      ClipboardData(text: contacts!.name));
                                  _showSnackbar('Name copied', 'success');
                                },
                                child: const Icon(Icons.copy)),
                          ),
                        if (contacts!.mobile != null)
                          ListTile(
                            leading: const Icon(FontAwesomeIcons.phone),
                            title: Text(contacts!.mobile!),
                            trailing: InkWell(
                                onTap: () {
                                  Clipboard.setData(
                                      ClipboardData(text: contacts!.mobile));
                                  _showSnackbar('Mobile copied', 'success');
                                },
                                child: const Icon(Icons.copy)),
                          ),
                        if (contacts!.email != null)
                          ListTile(
                            leading: const Icon(FontAwesomeIcons.solidEnvelope),
                            title: Text(contacts!.email!),
                            trailing: InkWell(
                                onTap: () {
                                  Clipboard.setData(
                                      ClipboardData(text: contacts!.email));
                                  _showSnackbar('Email copied', 'success');
                                },
                                child: const Icon(Icons.copy)),
                          ),
                        if (contacts!.facebook != null)
                          ListTile(
                            leading: const Icon(FontAwesomeIcons.facebook),
                            title: Text(contacts!.facebook!),
                            trailing: InkWell(
                                onTap: () {
                                  Clipboard.setData(
                                      ClipboardData(text: contacts!.facebook));
                                  _showSnackbar('Facebook copied', 'success');
                                },
                                child: const Icon(Icons.copy)),
                          ),
                        if (contacts!.instagram != null)
                          ListTile(
                            leading: const Icon(FontAwesomeIcons.instagram),
                            title: Text(contacts!.instagram!),
                            trailing: InkWell(
                                onTap: () {
                                  Clipboard.setData(
                                      ClipboardData(text: contacts!.instagram));
                                  _showSnackbar('Instagram copied', 'success');
                                },
                                child: const Icon(Icons.copy)),
                          ),
                        if (contacts!.twitter != null)
                          ListTile(
                            leading: const Icon(FontAwesomeIcons.twitter),
                            title: Text(contacts!.twitter!),
                            trailing: InkWell(
                                onTap: () {
                                  Clipboard.setData(
                                      ClipboardData(text: contacts!.twitter));
                                  _showSnackbar('Twitter copied', 'success');
                                },
                                child: const Icon(Icons.copy)),
                          ),
                        if (contacts!.linkedIn != null)
                          ListTile(
                            leading: const Icon(FontAwesomeIcons.linkedin),
                            title: Text(contacts!.linkedIn!),
                            trailing: InkWell(
                                onTap: () {
                                  Clipboard.setData(
                                      ClipboardData(text: contacts!.linkedIn));
                                  _showSnackbar('LinkedIn copied', 'success');
                                },
                                child: const Icon(Icons.copy)),
                          ),
                        if (contacts!.telegram != null)
                          ListTile(
                            leading: const Icon(FontAwesomeIcons.telegram),
                            title: Text(contacts!.telegram!),
                            trailing: InkWell(
                                onTap: () {
                                  Clipboard.setData(
                                      ClipboardData(text: contacts!.telegram));
                                  _showSnackbar('Telegram copied', 'success');
                                },
                                child: const Icon(Icons.copy)),
                          ),
                      ],
                    ),
        ),
      ),
    );
  }
}
