import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:travel_app/model/contacts.dart';
import 'package:travel_app/model/request_status.dart';
import 'package:travel_app/model/traveler_share_request.dart';
import 'package:travel_app/model/trip.dart';
import 'package:travel_app/service/contacts_service.dart';
import 'package:travel_app/service/share_request_service.dart';
import 'package:travel_app/widgets/form_section.dart';
import 'package:url_launcher/url_launcher.dart';

class TravelerRequestContactInfoScreen extends StatefulWidget {
  static const String routeName = '/traveler-request-contact';

  const TravelerRequestContactInfoScreen({Key? key}) : super(key: key);

  @override
  TravelerRequestContactInfoScreenState createState() =>
      TravelerRequestContactInfoScreenState();
}

class TravelerRequestContactInfoScreenState
    extends State<TravelerRequestContactInfoScreen> {
  bool isUpdating = false;
  bool isLoadingContacts = true;
  double declineWidth = 110;
  double acceptWidth = 110;
  Contacts? contacts;

  Future<Contacts?> _findContacts(TravelerShareRquest request) async {
    try {
      return await ContactsService().findContacts(
        request.tripId,
        request.created.split('_')[2],
        false,
      );
    } on HttpException catch (e) {
      debugPrint(e.message);
    }
    return null;
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
      final request = argsMap['request'] as TravelerShareRquest;
      final requesterContacts = await _findContacts(request);
      setState(() {
        contacts = requesterContacts;
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
    final request = argsMap['request'] as TravelerShareRquest;
    final requestStatus = argsMap['status'] as RequestStatus;
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
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.55,
              child: FittedBox(
                child: Row(
                  children: [
                    Center(
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        trip.fromCity.split('-')[0],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    const Icon(FontAwesomeIcons.plane, size: 14),
                    const SizedBox(width: 7),
                    Center(
                      child: Text(
                        overflow: TextOverflow.ellipsis,
                        trip.toCity.split('-')[0],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: FittedBox(
                child: Row(
                  children: [
                    const Icon(
                      Icons.flight_land,
                    ),
                    const SizedBox(width: 5),
                    Text(formatter.format(trip.trDate),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
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
                                      Clipboard.setData(ClipboardData(
                                          text: contacts!.name ?? ''));
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
                                      Clipboard.setData(ClipboardData(
                                          text: contacts!.mobile ?? ''));
                                      _showSnackbar('Mobile copied', 'success');
                                    },
                                    child: const Icon(Icons.copy)),
                              ),
                            if (contacts!.email != null)
                              ListTile(
                                leading:
                                    const Icon(FontAwesomeIcons.solidEnvelope),
                                title: Text(contacts!.email!),
                                trailing: InkWell(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                          text: contacts!.email ?? ''));
                                      _showSnackbar('Email copied', 'success');
                                    },
                                    child: const Icon(Icons.copy)),
                              ),
                            if (contacts!.facebook != null)
                              ListTile(
                                leading: const Icon(FontAwesomeIcons.facebook),
                                title: GestureDetector(
                                  onTap: () {
                                    _launchURL(contacts!.facebook!);
                                  },
                                  child: Text(contacts!.facebook!),
                                ),
                                trailing: InkWell(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                          text: contacts!.facebook ?? ''));
                                      _showSnackbar(
                                          'Facebook copied', 'success');
                                    },
                                    child: const Icon(Icons.copy)),
                              ),
                            if (contacts!.instagram != null)
                              ListTile(
                                leading: const Icon(
                                    FontAwesomeIcons.squareInstagram),
                                title: GestureDetector(
                                  onTap: () {
                                    _launchURL(contacts!.instagram!);
                                  },
                                  child: Text(contacts!.instagram!),
                                ),
                                trailing: InkWell(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                          text: contacts!.instagram ?? ''));
                                      _showSnackbar(
                                          'Instagram copied', 'success');
                                    },
                                    child: const Icon(Icons.copy)),
                              ),
                            if (contacts!.twitter != null)
                              ListTile(
                                leading: const Icon(FontAwesomeIcons.twitter),
                                title: GestureDetector(
                                  onTap: () {
                                    _launchURL(contacts!.twitter!);
                                  },
                                  child: Text(contacts!.twitter!),
                                ),
                                trailing: InkWell(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                          text: contacts!.twitter ?? ''));
                                      _showSnackbar(
                                          'Twitter copied', 'success');
                                    },
                                    child: const Icon(Icons.copy)),
                              ),
                            if (contacts!.linkedIn != null)
                              ListTile(
                                leading: const Icon(FontAwesomeIcons.linkedin),
                                title: GestureDetector(
                                  onTap: () {
                                    _launchURL(contacts!.linkedIn!);
                                  },
                                  child: Text(contacts!.linkedIn!),
                                ),
                                trailing: InkWell(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                          text: contacts!.linkedIn ?? ''));
                                      _showSnackbar(
                                          'LinkedIn copied', 'success');
                                    },
                                    child: const Icon(Icons.copy)),
                              ),
                            if (contacts!.telegram != null)
                              ListTile(
                                leading: const Icon(FontAwesomeIcons.telegram),
                                title: GestureDetector(
                                  onTap: () {
                                    _launchURL(contacts!.telegram!);
                                  },
                                  child: Text(contacts!.telegram!),
                                ),
                                trailing: InkWell(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                          text: contacts!.telegram ?? ''));
                                      _showSnackbar(
                                          'Telegram copied', 'success');
                                    },
                                    child: const Icon(Icons.copy)),
                              ),
                          ],
                        ),
            ),
            if (requestStatus == RequestStatus.pending)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      child: SizedBox(
                        width: declineWidth,
                        height: 40,
                        child: ElevatedButton.icon(
                          icon: isUpdating
                              ? Container()
                              : const Icon(FontAwesomeIcons.xmark),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[600]),
                          onPressed: () async {
                            if (isUpdating) {
                              return;
                            }
                            setState(() {
                              isUpdating = true;
                              declineWidth = 235;
                              acceptWidth = 0;
                            });
                            try {
                              await ShareRequestService()
                                  .declineRequest(request.created);
                              if (!mounted) return;
                              _showSnackbar('Request declined', 'success');
                              Navigator.pop(context, true);
                            } on HttpException catch (e) {
                              debugPrint(e.message);
                              setState(() {
                                isUpdating = false;
                                declineWidth = 110;
                                acceptWidth = 110;
                              });
                              _showSnackbar(
                                  'Something went wrong, try again', 'error');
                            }
                          },
                          label: isUpdating
                              ? const SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Decline'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Flexible(
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      child: SizedBox(
                        width: acceptWidth,
                        height: 40,
                        child: ElevatedButton.icon(
                          icon: isUpdating
                              ? Container()
                              : const Icon(FontAwesomeIcons.check),
                          onPressed: () async {
                            if (isUpdating) {
                              return;
                            }
                            setState(() {
                              isUpdating = true;
                              declineWidth = 0;
                              acceptWidth = 235;
                            });
                            try {
                              await ShareRequestService()
                                  .acceptRequest(request.created);
                              if (!mounted) return;
                              _showSnackbar('Request accepted', 'success');
                              Navigator.pop(context, true);
                            } on HttpException catch (e) {
                              debugPrint(e.message);
                              setState(() {
                                isUpdating = false;
                                declineWidth = 110;
                                acceptWidth = 110;
                              });
                              _showSnackbar(
                                  'Something went wrong, try again', 'error');
                            }
                          },
                          label: isUpdating
                              ? const SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Accept'),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
