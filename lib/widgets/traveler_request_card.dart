import 'dart:io';

import 'package:flutter/material.dart';
import 'package:travel_app/model/request_status.dart';
import 'package:travel_app/model/traveler_share_request.dart';
import 'package:travel_app/model/trip.dart';
import 'package:travel_app/providers/traveler_requests_provider.dart';
import 'package:travel_app/screens/traveler_request_contact_info_screen.dart';
import 'package:travel_app/service/trip_service.dart';
import 'package:travel_app/widgets/skeleton.dart';
import 'package:travel_app/widgets/weight_card.dart';

class TravelerRequestCard extends StatefulWidget {
  final TravelerShareRquest request;
  final RequestStatus requestStatus;
  final TravelerRequestsProvider requestsProvider;
  final Function() onTap;

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
  var isLoading = true;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      try {
        final requestTrip = await TripService()
            .findTrip(widget.request.tripId, widget.request.username);
        setState(() {
          trip = requestTrip;
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

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: const [
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
            : WeightCard(
                detailsButtonText: 'Contact Info',
                trip: trip!,
                onTap: widget.onTap,
              );
  }
}
