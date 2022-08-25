import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_app/screens/trip_details_screen.dart';

class WeightCard extends StatelessWidget {
  final String from;
  final String to;
  final String arrival;
  final String weight;

  const WeightCard({
    Key? key,
    required this.from,
    required this.to,
    required this.arrival,
    required this.weight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  from,
                  style: const TextStyle(fontSize: 22),
                ),
                const Icon(
                  FontAwesomeIcons.plane,
                  color: Colors.teal,
                ),
                Text(
                  to,
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
                      weight,
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
                      arrival,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, TripDetailsScreen.routeName);
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.teal[300],
                    elevation: 0,
                    primary: Colors.white,
                  ),
                  child: const Text('View details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
