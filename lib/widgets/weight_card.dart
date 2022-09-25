import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:travel_app/model/trip.dart';
import 'package:travel_app/util/app_theme.dart';

class WeightCard extends StatelessWidget {
  final Trip trip;
  final Function() onTap;
  final bool showDetailsButton;
  final String detailsButtonText;
  final Widget? info;
  final String? name;

  const WeightCard({
    Key? key,
    required this.trip,
    required this.onTap,
    this.showDetailsButton = true,
    this.detailsButtonText = 'View Details',
    this.info,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final kg = trip.allowedItems
        .map((item) => item.kg)
        .reduce((prev, current) => prev + current);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (name != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name!,
                            style:
                                AppTheme.title.copyWith(color: Colors.black54)),
                        const Divider(
                          color: Colors.black26,
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  if (info != null) info!,
                  if (info != null) const SizedBox(height: 10),
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
                            kg.toStringAsFixed(
                                kg.truncateToDouble() == kg ? 0 : 1),
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
                      if (showDetailsButton)
                        OutlinedButton(
                          onPressed: onTap,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.teal[300],
                            elevation: 0,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(detailsButtonText),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
