import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/model/trip.dart';
import 'package:travel_app/providers/trip_provider.dart';
import 'package:travel_app/screens/main_drawer.dart';
import 'package:travel_app/screens/save_trip_screen.dart';
import 'package:travel_app/widgets/profile_weight_card.dart';

enum TripsType { active, archived }

class YourTripsScreen extends StatefulWidget {
  const YourTripsScreen({Key? key}) : super(key: key);

  @override
  State<YourTripsScreen> createState() => _YourTripsScreenState();
}

class _YourTripsScreenState extends State<YourTripsScreen> {
  var tripsType = TripsType.active;
  var isLoadingTrips = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      setState(() {
        isLoadingTrips = true;
      });
      await fetchTrips();
      setState(() {
        isLoadingTrips = false;
      });
    });

    super.initState();
  }

  Future<void> fetchTrips() async {
    try {
      final tripProvider = Provider.of<TripProvider>(context, listen: false);
      await tripProvider.fetchTrips();
    } on HttpException catch (e) {
      debugPrint(e.message);
    }
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Your Trips'),
        automaticallyImplyLeading: true,
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
      drawer: const MainDrawer(),
      body: isLoadingTrips
          ? const Center(
              child: SizedBox(
                width: 60,
                child: LoadingIndicator(
                  strokeWidth: 1,
                  indicatorType: Indicator.ballPulse,
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: fetchTrips,
              child: Padding(
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
                            selected: tripsType == TripsType.active,
                            onSelected: (selected) {
                              if (tripsType == TripsType.archived) {
                                setState(() {
                                  tripsType = TripsType.active;
                                });
                              }
                            }),
                        const SizedBox(width: 15),
                        FilterChip(
                            label: const Text('Archived'),
                            selected: tripsType == TripsType.archived,
                            onSelected: (selected) {
                              if (tripsType == TripsType.active) {
                                setState(() {
                                  tripsType = TripsType.archived;
                                });
                              }
                            })
                      ],
                    ),
                    Expanded(
                      child: Consumer<TripProvider>(
                        builder: (ctx, tripProvider, _) {
                          final trips = tripsType == TripsType.active
                              ? tripProvider.activeTrips
                              : tripProvider.archivedTrips;

                          return trips.isEmpty
                              ? Center(
                                  child: Text(
                                    'You don\'t have any ${tripsType == TripsType.active ? 'upcomming' : 'archived'} trips',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                )
                              : ListView.separated(
                                  itemCount: trips.length,
                                  separatorBuilder: (_, i) => const Divider(
                                    thickness: 1,
                                  ),
                                  itemBuilder: (ctx, i) {
                                    final trip = trips[i];
                                    return Slidable(
                                      endActionPane: tripsType ==
                                              TripsType.archived
                                          ? null
                                          : ActionPane(
                                              motion: const ScrollMotion(),
                                              children: [
                                                SlidableAction(
                                                  onPressed: (_) =>
                                                      _navigateToAddTripScreen(
                                                          {'trip': trip},
                                                          i,
                                                          true),
                                                  backgroundColor: Colors.blue,
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.edit,
                                                  label: 'Edit',
                                                ),
                                                SlidableAction(
                                                  onPressed: (_) => _deleteTrip(
                                                      trip.created!, i),
                                                  backgroundColor:
                                                      const Color(0xFFFE4A49),
                                                  foregroundColor: Colors.white,
                                                  icon: Icons.delete,
                                                  label: 'Delete',
                                                ),
                                              ],
                                            ),
                                      child: ProfileWeightCard(
                                        onPressed:
                                            tripsType == TripsType.archived
                                                ? (Map<String, dynamic> args,
                                                    int index, bool isEdit) {}
                                                : _navigateToAddTripScreen,
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
            ),
    );
  }
}
