import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileWeightCard extends StatelessWidget {
  final String from;
  final String to;
  final String arrival;
  final String weight;
  final String acceptFrom;
  final String acceptTo;

  const ProfileWeightCard({
    Key? key,
    required this.from,
    required this.to,
    required this.arrival,
    required this.weight,
    required this.acceptFrom,
    required this.acceptTo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                from.split(',')[0],
                style: const TextStyle(fontSize: 20),
              ),
              const Icon(
                FontAwesomeIcons.plane,
                color: Colors.teal,
              ),
              Text(
                to.split(',')[0],
                style: const TextStyle(fontSize: 20),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    acceptFrom,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text('-'),
                  const SizedBox(width: 5),
                  Text(
                    acceptTo,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
