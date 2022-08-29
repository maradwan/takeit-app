import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/model/item.dart';
import 'package:travel_app/model/trip.dart';
import 'package:travel_app/providers/trip_provider.dart';
import 'package:travel_app/screens/save_trip_screen.dart';
import 'package:travel_app/service/trip_service.dart';
import 'package:travel_app/widgets/profile_weight_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final result = await Amplify.Auth.fetchUserAttributes();
      for (final element in result) {
        if (element.userAttributeKey == CognitoUserAttributeKey.name) {
          setState(() {
            name = element.value;
          });
          break;
        }
      }
    });

    Future.delayed(Duration.zero, () async {
      if (!mounted) return;
      final tripProvider = Provider.of<TripProvider>(context, listen: false);
      await tripProvider.fetchTrips();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(name),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SaveTripScreen.routeName);
            },
            icon: const Icon(FontAwesomeIcons.plus),
          ),
          IconButton(
            onPressed: () async {
              await Amplify.Auth.signOut();
              if (!mounted) return;

              Navigator.pushReplacementNamed(context, '/');
            },
            icon: const Icon(FontAwesomeIcons.gear),
          ),
          // IconButton(
          //   onPressed: () async {
          //     final session = await Amplify.Auth.fetchAuthSession(
          //       options: CognitoSessionOptions(getAWSCredentials: true),
          //     ) as CognitoAuthSession;
          //     final idToken = session.userPoolTokens!.idToken;

          //     final items = [
          //       Item('Paper', 0, 0),
          //       Item('Medicine', 0, 0),
          //       Item('Clothes', 10, 5),
          //     ];
          //     final trip = Trip(
          //       DateTime.now(),
          //       DateTime.now().add(const Duration(days: 4)),
          //       DateTime.now().add(const Duration(days: 6)),
          //       'berlin',
          //       'cairo',
          //       'euro',
          //       items,
          //     );

          //     TripService().save(trip, idToken);
          //   },
          //   icon: const Icon(FontAwesomeIcons.bicycle),
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 0,
          top: 10,
          left: 10,
          right: 10,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilterChip(
                    label: const Text('Active'),
                    selected: true,
                    onSelected: (selected) {}),
                const SizedBox(width: 15),
                FilterChip(
                    label: const Text('Archived'), onSelected: (selected) {})
              ],
            ),
            Expanded(
              child: Consumer<TripProvider>(
                builder: (ctx, tripProvider, _) {
                  final DateFormat formatter = DateFormat('dd.MM.yyyy');
                  return ListView.separated(
                    itemCount: tripProvider.trips.length,
                    separatorBuilder: (_, i) => const Divider(
                      thickness: 1,
                    ),
                    itemBuilder: (ctx, i) {
                      final trip = tripProvider.trips[i];
                      final kg = trip.allowedItems
                          .map((item) => item.kg)
                          .reduce((prev, current) => prev + current);
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (_) {},
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                            SlidableAction(
                              onPressed: (_) {},
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: ProfileWeightCard(
                          from: trip.fromCity,
                          to: trip.toCity,
                          arrival: formatter.format(trip.trDate),
                          weight: kg.toStringAsFixed(
                              kg.truncateToDouble() == kg ? 0 : 1),
                          acceptFrom: formatter.format(trip.acceptFrom),
                          acceptTo: formatter.format(trip.acceptTo),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
