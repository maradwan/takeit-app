import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:travel_app/model/request_status.dart';
import 'package:travel_app/model/requester_share_request.dart';
import 'package:travel_app/model/trip.dart';
import 'package:travel_app/service/share_request_service.dart';
import 'package:travel_app/util/app_theme.dart';
import 'package:travel_app/util/item_util.dart';
import 'package:travel_app/widgets/skeleton.dart';

class TripDetailsScreen extends StatefulWidget {
  static const String routeName = '/trip-details';

  const TripDetailsScreen({Key? key}) : super(key: key);

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  RequesterShareRquest? existingShareRquest;
  bool isLoading = true;
  bool isSendingRequest = false;
  RequestStatus requestStatus = RequestStatus.pending;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final trip = ModalRoute.of(context)!.settings.arguments as Trip;
      try {
        var request = await ShareRequestService().findRequesterRequest(
            trip.created!, trip.username!, RequestStatus.pending);
        request = request ??
            await ShareRequestService().findRequesterRequest(
                trip.created!, trip.username!, RequestStatus.accepted);
        request = request ??
            await ShareRequestService().findRequesterRequest(
                trip.created!, trip.username!, RequestStatus.declined);

        setState(() {
          existingShareRquest = request;
        });
      } on HttpException catch (e) {
        debugPrint(e.message);
      }
      setState(() {
        isLoading = false;
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
    final trip = ModalRoute.of(context)!.settings.arguments as Trip;

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
                    Text(
                      formatter.format(trip.trDate),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...trip.allowedItems.map((item) {
                        return ListTile(
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                ItemUtil.itemToIcon[item.name],
                                size: 32,
                              ),
                            ],
                          ),
                          title: Text(
                            trip.allowedItems.length == 1 &&
                                    item.name == 'Others'
                                ? 'Anything'
                                : item.name,
                            style: AppTheme.title,
                          ),
                          subtitle: Text(item.name == 'Paper'
                              ? ''
                              : 'Avaliable  ${item.kg.toStringAsFixed(item.kg.truncateToDouble() == item.kg ? 0 : 1)} KG'),
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item.price == 0
                                    ? 'Free'
                                    : '${item.price.toStringAsFixed(item.price.truncateToDouble() == item.price ? 0 : 1)} ${trip.currency}',
                                style: AppTheme.title,
                              ),
                              if (item.price > 0) const Text('Per KG'),
                            ],
                          ),
                        );
                      }),
                      if (!isLoading)
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Disclaimer'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: const <Widget>[
                                        Text(
                                          'Please read the following carefully, and by continuing, you consent to the following:\n\n'
                                              'All my contacts will be shared with the Requester/Sender or Traveler.\n'
                                              '"Take IT" is not liable for any loss, theft, or damage to your package.\n'
                                              '"Take IT" is not liable for compensation.\n'
                                              '"Take IT" bears no liability for Requester/Sender or traveler for their packages.\n'
                                              '"Take IT is not responsible, but travelers are fully responsible for any duties, customs, or items they carry in their baggage.\n'
                                              '"Take IT requires the Traveler not to take any items directly from the Requester/Sender; only travelers may obtain items from verified and legal companies like Amazon.\n'
                                              'Travelers understand that they will be solely responsible, including facing legal consequences, if illegal items are found in their possession.\n'
                                              '"Take IT" is the only social media app that connects Requesters/Senders with travelers. There is no guarantee of any party in the app, we haven\'t verified the users.\n'
                                              'You will follow the arrival and departure country laws, rules and policies.',
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Close'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text(
                            'Read Disclaimer',
                            style: TextStyle(color: Colors.blue, fontSize: 12),
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: isLoading
                            ? const Skeleton(
                                width: double.infinity,
                                height: 40,
                              )
                            : ElevatedButton(
                                onPressed: existingShareRquest != null
                                    ? null
                                    : () async {
                                        if (isSendingRequest) {
                                          return;
                                        }
                                        try {
                                          setState(() {
                                            isSendingRequest = true;
                                          });
                                          try {
                                            await ShareRequestService()
                                                .createRequest(
                                              trip.username!,
                                              trip.created!,
                                              trip.trDate,
                                            );
                                            _showSnackbar(
                                                'Request sent successfully',
                                                'success');
                                            setState(() {
                                              existingShareRquest =
                                                  RequesterShareRquest(
                                                      'pending',
                                                      '',
                                                      DateTime.now(),
                                                      '');
                                            });
                                          } on HttpException catch (e) {
                                            debugPrint(e.message);
                                            _showSnackbar(
                                                'Something went wrong, try again',
                                                'error');
                                          }
                                          setState(() {
                                            isSendingRequest = false;
                                          });
                                        } on HttpException catch (e) {
                                          debugPrint(e.message);
                                          _showSnackbar(
                                              'Something went wrong, try again',
                                              'error');
                                        }
                                      },
                                child: const Text('Send Request'),
                              ),
                      )
                    ],
                  ),
                ),
              ),
              if (!isLoading && existingShareRquest != null)
                RichText(
                  text: TextSpan(
                    text: 'Request sent on ',
                    style: TextStyle(color: Colors.grey[600]),
                    children: [
                      TextSpan(
                          text: formatter.format(existingShareRquest!.dtime),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
              if (!isLoading && existingShareRquest != null)
                const SizedBox(height: 5),
              if (!isLoading && existingShareRquest != null)
                RichText(
                  text: TextSpan(
                    text: 'Status is ',
                    style: TextStyle(color: Colors.grey[600]),
                    children: [
                      TextSpan(
                          text:
                              existingShareRquest!.created.contains('accepted')
                                  ? 'accepted'
                                  : existingShareRquest!.created
                                          .contains('declined')
                                      ? 'declined'
                                      : 'pending',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
