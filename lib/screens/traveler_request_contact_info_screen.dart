import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_app/model/request_status.dart';
import 'package:travel_app/model/traveler_share_request.dart';
import 'package:travel_app/service/share_request_service.dart';

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
    final argsMap =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final request = argsMap['request'] as TravelerShareRquest;
    final requestStatus = argsMap['status'] as RequestStatus;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        title: const Text('Contact info'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(8).copyWith(top: 20),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: const Text('+440757512781'),
                        trailing: InkWell(
                            onTap: () {}, child: const Icon(Icons.copy)),
                      ),
                      ListTile(
                        leading: const Icon(FontAwesomeIcons.envelope),
                        title: const Text('akhaled.saleh@gmail.com'),
                        trailing: InkWell(
                            onTap: () {}, child: const Icon(Icons.copy)),
                      ),
                      ListTile(
                        leading: const Icon(FontAwesomeIcons.facebookSquare),
                        title: const Text('amr.khaled.505960'),
                        trailing: InkWell(
                            onTap: () {}, child: const Icon(Icons.copy)),
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
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (requestStatus == RequestStatus.pending ||
                    requestStatus == RequestStatus.accepted)
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
                              Navigator.pop(context);
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
                if (requestStatus == RequestStatus.pending)
                  const SizedBox(width: 15),
                if (requestStatus == RequestStatus.pending ||
                    requestStatus == RequestStatus.declined)
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
                              Navigator.pop(context);
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
