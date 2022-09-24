import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/model/request_status.dart';
import 'package:travel_app/providers/requester_requests_provider.dart';
import 'package:travel_app/screens/main_drawer.dart';
import 'package:travel_app/service/share_request_service.dart';
import 'package:travel_app/widgets/requester_request_card.dart';

class SentPackagesScreen extends StatefulWidget {
  const SentPackagesScreen({Key? key}) : super(key: key);

  @override
  State<SentPackagesScreen> createState() => _SentPackagesScreenState();
}

class _SentPackagesScreenState extends State<SentPackagesScreen> {
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
          Provider.of<RequesterRequestsProvider>(context, listen: false);
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

  void _showSnackbar(String message, String type) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: type == 'error' ? Colors.red[700] : Colors.teal[700],
    ));
  }

  Future<void> _deleteRequest(String created, int index) async {
    print(created);
    final requestProvider =
        Provider.of<RequesterRequestsProvider>(context, listen: false);
    try {
      await ShareRequestService().deleteRequesterRequest(created);
      await requestProvider.removeRequest(index);
      _showSnackbar('Trip deleted successfully', 'success');
    } on HttpException catch (error) {
      _showSnackbar(error.message, 'error');
    } catch (error) {
      _showSnackbar('Something went wrong, try again later', 'error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        title: const Text('Sent Requests'),
        automaticallyImplyLeading: true,
      ),
      drawer: const MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 0,
          top: 10,
          left: 10,
          right: 10,
        ),
        child: Column(children: [
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
                  child: Consumer<RequesterRequestsProvider>(
                    builder: (ctx, requestsProvider, _) {
                      final requests = requestsProvider.requests;

                      return requests.isEmpty
                          ? Center(
                              child: Text(
                                'You didn\'t send any requests yet',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            )
                          : ListView.builder(
                              itemCount: requests.length,
                              itemBuilder: (ctx, i) => Slidable(
                                endActionPane: ActionPane(
                                  extentRatio: 0.2,
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (_) => _deleteRequest(
                                          requests[i].created, i),
                                      borderRadius: BorderRadius.circular(5),
                                      backgroundColor: const Color(0xFFFE4A49),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                                child: RequesterRequestCard(
                                  request: requests[i],
                                  requestStatus: requestStatus,
                                ),
                              ),
                            );
                    },
                  ),
                ),
        ]),
      ),
    );
  }
}
