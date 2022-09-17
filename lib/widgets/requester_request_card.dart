import 'package:flutter/material.dart';
import 'package:travel_app/model/requester_share_request.dart';
import 'package:travel_app/model/trip.dart';
import 'package:travel_app/service/trip_service.dart';
import 'package:travel_app/widgets/weight_card.dart';

class RequesterRequestCard extends StatefulWidget {
  final RequesterShareRquest request;

  const RequesterRequestCard({Key? key, required this.request})
      : super(key: key);

  @override
  RequesterRequestCardState createState() => RequesterRequestCardState();
}

class RequesterRequestCardState extends State<RequesterRequestCard> {
  Trip? trip;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final created = widget.request.created.split('_');

      if (created.length > 1) {
        final travelerUsername = created[2];
        final requestTrip = await TripService()
            .findTrip(widget.request.tripId, travelerUsername);
        setState(() {
          trip = requestTrip;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return trip == null
        ? Container()
        : WeightCard(
            showDetailsButton: false,
            trip: trip!,
            onTap: () {},
          );
  }
}
