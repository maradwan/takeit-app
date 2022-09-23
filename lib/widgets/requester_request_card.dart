import 'dart:io';

import 'package:flutter/material.dart';
import 'package:travel_app/model/request_status.dart';
import 'package:travel_app/model/requester_share_request.dart';
import 'package:travel_app/model/trip.dart';
import 'package:travel_app/screens/requester_request_contact_info_screen.dart';
import 'package:travel_app/service/trip_service.dart';
import 'package:travel_app/widgets/info_label.dart';
import 'package:travel_app/widgets/skeleton.dart';
import 'package:travel_app/widgets/weight_card.dart';

class RequesterRequestCard extends StatefulWidget {
  final RequesterShareRquest request;
  final RequestStatus requestStatus;

  const RequesterRequestCard({
    Key? key,
    required this.request,
    required this.requestStatus,
  }) : super(key: key);

  @override
  RequesterRequestCardState createState() => RequesterRequestCardState();
}

class RequesterRequestCardState extends State<RequesterRequestCard> {
  Trip? trip;
  var isLoading = true;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      try {
        final created = widget.request.created.split('_');
        if (created.length > 1) {
          final travelerUsername = created[2];
          final requestTrip = await TripService()
              .findTrip(widget.request.tripId, travelerUsername);
          setState(() {
            trip = requestTrip;
          });
        }
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
            ? Container()
            : WeightCard(
                showDetailsButton:
                    widget.requestStatus == RequestStatus.accepted,
                detailsButtonText: 'View contact info',
                info: trip!.updated != null &&
                        trip!.updated!.isAfter(widget.request.dtime)
                    ? const InfoLabel(label: 'Traveler updated trip details')
                    : null,
                trip: trip!,
                onTap: () async {
                  if (widget.requestStatus != RequestStatus.accepted) {
                    return;
                  }

                  await Navigator.pushNamed(
                    context,
                    RequesterRequestContactInfoScreen.routeName,
                    arguments: {
                      'request': widget.request,
                      'trip': trip,
                    },
                  );
                },
              );
  }
}
