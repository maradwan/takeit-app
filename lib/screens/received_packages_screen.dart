import 'package:flutter/material.dart';
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

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final requestProvider =
          Provider.of<TravelerRequestsProvider>(context, listen: false);
      await requestProvider.findRequests(requestStatus);
    });
    super.initState();
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
                  }
                },
              )
            ],
          ),
          Expanded(
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
                        itemBuilder: (ctx, i) =>
                            TravelerRequestCard(request: requests[i]),
                      );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
