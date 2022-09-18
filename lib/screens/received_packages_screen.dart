import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/model/request_status.dart';
import 'package:travel_app/providers/traveler_requests_provider.dart';
import 'package:travel_app/screens/main_drawer.dart';
import 'package:travel_app/widgets/traveler_request_card.dart';

class RecievedPackagesScreen extends StatefulWidget {
  const RecievedPackagesScreen({Key? key}) : super(key: key);

  @override
  State<RecievedPackagesScreen> createState() => _RecievedPackagesScreenState();
}

class _RecievedPackagesScreenState extends State<RecievedPackagesScreen> {
  var requestStatus = RequestStatus.pending;
  var isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      _initRequests(true);
    });
    super.initState();
  }

  Future<void> _initRequests(bool showLoadingProgress) async {
    if (showLoadingProgress) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final requestProvider =
          Provider.of<TravelerRequestsProvider>(context, listen: false);
      await requestProvider.findRequests(requestStatus);
    } on HttpException catch (e) {
      debugPrint(e.message);
    }
    if (showLoadingProgress) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        title: const Text('Recieved Requests'),
        automaticallyImplyLeading: true,
      ),
      drawer: const MainDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _initRequests(false),
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 0,
            top: 10,
            left: 10,
            right: 10,
          ),
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilterChip(
                    label: const Text('Pending'),
                    selected: requestStatus == RequestStatus.pending,
                    onSelected: (selected) {
                      if (requestStatus != RequestStatus.pending) {
                        setState(() {
                          requestStatus = RequestStatus.pending;
                        });
                        _initRequests(true);
                      }
                    }),
                const SizedBox(width: 15),
                FilterChip(
                    label: const Text('Accepted'),
                    selected: requestStatus == RequestStatus.accepted,
                    onSelected: (selected) {
                      if (requestStatus != RequestStatus.accepted) {
                        setState(() {
                          requestStatus = RequestStatus.accepted;
                        });
                        _initRequests(true);
                      }
                    }),
                const SizedBox(width: 15),
                FilterChip(
                  label: const Text('Declined'),
                  selected: requestStatus == RequestStatus.declined,
                  onSelected: (selected) {
                    if (requestStatus != RequestStatus.declined) {
                      setState(() {
                        requestStatus = RequestStatus.declined;
                      });
                      _initRequests(true);
                    }
                  },
                )
              ],
            ),
            isLoading
                ? const Expanded(
                    child: SizedBox(
                      height: double.infinity,
                      child: Center(
                        child: SizedBox(
                          width: 60,
                          child: LoadingIndicator(
                            strokeWidth: 1,
                            indicatorType: Indicator.ballPulse,
                          ),
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: Consumer<TravelerRequestsProvider>(
                      builder: (ctx, requestsProvider, _) {
                        final requests = requestsProvider.requests;

                        return requests.isEmpty
                            ? Center(
                                child: Text(
                                  'You didn\'t recieve any requests yet',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              )
                            : ListView.builder(
                                itemCount: requests.length,
                                itemBuilder: (ctx, i) => TravelerRequestCard(
                                  request: requests[i],
                                  requestStatus: requestStatus,
                                ),
                              );
                      },
                    ),
                  ),
          ]),
        ),
      ),
    );
  }
}
