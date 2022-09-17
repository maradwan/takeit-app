import 'package:flutter/material.dart';
import 'package:travel_app/model/traveler_share_request.dart';
import 'package:travel_app/model/trip.dart';
import 'package:travel_app/service/trip_service.dart';
import 'package:travel_app/widgets/weight_card.dart';

class TravelerRequestCard extends StatefulWidget {
  final TravelerShareRquest request;

  const TravelerRequestCard({Key? key, required this.request})
      : super(key: key);

  @override
  TravelerRequestCardState createState() => TravelerRequestCardState();
}

class TravelerRequestCardState extends State<TravelerRequestCard> {
  Trip? trip;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final requestTrip = await TripService()
          .findTrip(widget.request.tripId, widget.request.username);
      setState(() {
        trip = requestTrip;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return trip == null
        ? Container()
        : WeightCard(
            trip: trip!,
            onTap: () {},
          );
  }
}
