import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/model/request_status.dart';
import 'package:travel_app/providers/requester_requests_provider.dart';
import 'package:travel_app/screens/main_drawer.dart';
import 'package:travel_app/widgets/requester_request_card.dart';

class SentPackagesScreen extends StatefulWidget {
  const SentPackagesScreen({Key? key}) : super(key: key);

  @override
  State<SentPackagesScreen> createState() => _SentPackagesScreenState();
}

class _SentPackagesScreenState extends State<SentPackagesScreen> {
  var requestStatus = RequestStatus.pending;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final requestProvider =
          Provider.of<RequesterRequestsProvider>(context, listen: false);
      await requestProvider.findRequests(requestStatus);
    });
    super.initState();
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
            child: Consumer<RequesterRequestsProvider>(
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
                            RequesterRequestCard(request: requests[i]),
                      );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
