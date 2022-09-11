import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:travel_app/model/trip.dart';
import 'package:travel_app/screens/trip_details_screen.dart';

class WeightCard extends StatelessWidget {
  final Trip trip;

  const WeightCard({
    Key? key,
    required this.trip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final kg = trip.allowedItems
        .map((item) => item.kg)
        .reduce((prev, current) => prev + current);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, TripDetailsScreen.routeName,
            arguments: trip);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    trip.fromCity.split('-')[0],
                    style: const TextStyle(fontSize: 22),
                  ),
                  const Icon(
                    FontAwesomeIcons.plane,
                    color: Colors.teal,
                  ),
                  Text(
                    trip.toCity.split('-')[0],
                    style: const TextStyle(fontSize: 22),
                  ),
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.weightHanging,
                        size: 18,
                        color: Colors.teal,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        kg.toStringAsFixed(kg.truncateToDouble() == kg ? 0 : 1),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        FontAwesomeIcons.planeArrival,
                        color: Colors.teal,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        formatter.format(trip.trDate),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, TripDetailsScreen.routeName,
                          arguments: trip);
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.teal[300],
                      elevation: 0,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('View details'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
