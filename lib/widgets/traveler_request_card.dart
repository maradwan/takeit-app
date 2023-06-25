import 'dart:io';

import 'package:flutter/material.dart';
import 'package:travel_app/model/contacts.dart';
import 'package:travel_app/model/request_status.dart';
import 'package:travel_app/model/traveler_share_request.dart';
import 'package:travel_app/model/trip.dart';
import 'package:travel_app/providers/traveler_requests_provider.dart';
import 'package:travel_app/service/contacts_service.dart';
import 'package:travel_app/service/trip_service.dart';
import 'package:travel_app/widgets/skeleton.dart';
import 'package:travel_app/widgets/weight_card.dart';

class TravelerRequestCard extends StatefulWidget {
  final TravelerShareRquest request;
  final RequestStatus requestStatus;
  final TravelerRequestsProvider requestsProvider;
  final Function(Trip trip) onTap;

  const TravelerRequestCard({
    Key? key,
    required this.request,
    required this.requestStatus,
    required this.requestsProvider,
    required this.onTap,
  }) : super(key: key);

  @override
  TravelerRequestCardState createState() => TravelerRequestCardState();
}

class TravelerRequestCardState extends State<TravelerRequestCard> {
  Trip? trip;
  Contacts? contacts;
  bool showRequestCard = true;
  var isLoading = true;

  Future<dynamic> _findTrip() async {
    try {
      return await TripService()
          .findTrip(widget.request.tripId, widget.request.username);
    } on HttpException catch (e) {
      debugPrint(e.message);
    }
    return null;
  }

  Future<dynamic> _findContacts() async {
    try {
      return await ContactsService().findContacts(
        widget.request.tripId,
        widget.request.created.split('_')[2],
        false,
      );
    } on HttpException catch (e) {
      if (!e.message.contains('You are not allowed')) {
        setState(() {
          showRequestCard = false;
        });
      }
      debugPrint(e.message);
    }
    return null;
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      try {
        Future.wait<dynamic>([_findTrip(), _findContacts()])
            .then((List<dynamic> result) {
          setState(() {
            trip = result[0] is Trip ? result[0] : result[1];
            contacts = result[0] is Contacts ? result[0] : result[1];
            isLoading = false;
          });
        });
      } on HttpException catch (e) {
        debugPrint(e.message);
        setState(() {
          isLoading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Skeleton(
                    width: double.infinity,
                    height: 20,
                  ),
                  SizedBox(height: 20),
                  Skeleton(
                    width: double.infinity,
                    height: 20,
                  ),
                ],
              ),
            ),
          )
        : trip == null
            ? Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                      child: Text(
                    'Trip is no longer avaliable',
                    style: TextStyle(color: Colors.grey[600]),
                  )),
                ),
              )
            : !showRequestCard
                ? const SizedBox()
                : WeightCard(
                    name: contacts?.name,
                    detailsButtonText: 'View contact info',
                    trip: trip!,
                    onTap: () => widget.onTap(trip!),
                  );
  }
}
