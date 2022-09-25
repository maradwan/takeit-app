import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:travel_app/model/trip.dart';
import 'package:travel_app/util/app_theme.dart';

class ProfileWeightCard extends StatelessWidget {
  final Trip trip;
  final int index;
  final Function(Map<String, dynamic> args, int index, bool isEdit) onPressed;

  const ProfileWeightCard({
    Key? key,
    required this.trip,
    required this.onPressed,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final kg = trip.allowedItems
        .map((item) => item.kg)
        .reduce((prev, current) => prev + current);
    return GestureDetector(
      onTap: () => onPressed({'trip': trip}, index, true),
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.30,
                      child: Center(
                        child: FittedBox(
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            trip.fromCity.split('-')[0],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      trip.fromCity.split('-')[1],
                      style: AppTheme.subtitle,
                    ),
                  ],
                ),
                const Icon(
                  FontAwesomeIcons.plane,
                  color: Colors.teal,
                  size: 18,
                ),
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.30,
                      child: Center(
                        child: FittedBox(
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            trip.toCity.split('-')[0],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      trip.toCity.split('-')[1],
                      style: AppTheme.subtitle,
                    ),
                  ],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatter.format(trip.acceptFrom),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text('-'),
                    const SizedBox(width: 5),
                    Text(
                      formatter.format(trip.acceptTo),
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
      ),
    );
  }
}
