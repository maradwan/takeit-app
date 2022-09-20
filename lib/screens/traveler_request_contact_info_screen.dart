import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:travel_app/model/request_status.dart';
import 'package:travel_app/model/traveler_share_request.dart';
import 'package:travel_app/model/trip.dart';
import 'package:travel_app/service/share_request_service.dart';
import 'package:travel_app/widgets/form_section.dart';

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
  double declineWidth = 110;
  double acceptWidth = 110;

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
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
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
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(15),
              child: FormSection(
                children: [
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('+440757512781'),
                    trailing:
                        InkWell(onTap: () {}, child: const Icon(Icons.copy)),
                  ),
                  ListTile(
                    leading: const Icon(FontAwesomeIcons.envelope),
                    title: const Text('akhaled.saleh@gmail.com'),
                    trailing:
                        InkWell(onTap: () {}, child: const Icon(Icons.copy)),
                  ),
                  ListTile(
                    leading: const Icon(FontAwesomeIcons.facebookSquare),
                    title: const Text('amr.khaled.505960'),
                    trailing:
                        InkWell(onTap: () {}, child: const Icon(Icons.copy)),
                  ),
                  ListTile(
                    leading: const Icon(FontAwesomeIcons.instagramSquare),
                    title: const Text('amrkhaled135'),
                    trailing: InkWell(
                        onTap: () {
                          Clipboard.setData(
                              const ClipboardData(text: 'amrkhaled135'));
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
