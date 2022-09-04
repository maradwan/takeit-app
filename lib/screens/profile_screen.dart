import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/model/trip.dart';
import 'package:travel_app/providers/trip_provider.dart';
import 'package:travel_app/screens/save_trip_screen.dart';
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
      final tripProvider = Provider.of<TripProvider>(context, listen: false);
      await tripProvider.fetchTrips();
    });

    super.initState();
  }

  void _showSnackbar(String message, String type) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: type == 'error' ? Colors.red[700] : Colors.teal[700],
    ));
  }

  Future<void> _deleteTrip(String created, int index) async {
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    try {
      await tripProvider.deleteTrip(created, index);
      _showSnackbar('Trip deleted successfully', 'success');
    } on HttpException catch (error) {
      _showSnackbar(error.message, 'error');
    } catch (error) {
      _showSnackbar('Something went wrong, try again later', 'error');
    }
  }

  Future<void> _navigateToAddTripScreen(
      Map<String, dynamic> args, int index, bool isEdit) async {
    final savedTrip = await Navigator.pushNamed(
      context,
      SaveTripScreen.routeName,
      arguments: args,
    );
    if (savedTrip != null) {
      if (!mounted) return;
      final tripProvider = Provider.of<TripProvider>(context, listen: false);
      if (isEdit) {
        await tripProvider.updateTrip(savedTrip as Trip, index);
      } else {
        await tripProvider.insertTrip(savedTrip as Trip);
      }
    }
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
            onPressed: () => _navigateToAddTripScreen({}, -1, false),
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
                  return ListView.separated(
                    itemCount: tripProvider.trips.length,
                    separatorBuilder: (_, i) => const Divider(
                      thickness: 1,
                    ),
                    itemBuilder: (ctx, i) {
                      final trip = tripProvider.trips[i];
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (_) => _navigateToAddTripScreen(
                                  {'trip': trip}, i, true),
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                            SlidableAction(
                              onPressed: (_) => _deleteTrip(trip.created!, i),
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: ProfileWeightCard(
                          onPressed: _navigateToAddTripScreen,
                          trip: trip,
                          index: i,
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
