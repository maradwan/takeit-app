import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_app/model/trip.dart';
import 'package:travel_app/util/app_theme.dart';
import 'package:travel_app/util/item_util.dart';

class TripDetailsScreen extends StatefulWidget {
  static const String routeName = '/trip-details';

  const TripDetailsScreen({Key? key}) : super(key: key);

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final trip = ModalRoute.of(context)!.settings.arguments as Trip;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Row(
          children: [
            Text(trip.fromCity.split('-')[0]),
            const SizedBox(width: 20),
            const Icon(FontAwesomeIcons.plane, size: 14),
            const SizedBox(width: 20),
            Text(trip.toCity.split('-')[0]),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...trip.allowedItems.map((item) {
                    return ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            ItemUtil.itemToIcon[item.name],
                            size: 32,
                          ),
                        ],
                      ),
                      title: Text(
                        trip.allowedItems.length == 1 && item.name == 'Others'
                            ? 'Anything'
                            : item.name,
                        style: AppTheme.title,
                      ),
                      subtitle: Text(item.name == 'Paper'
                          ? ''
                          : 'Avaliable  ${item.kg.toStringAsFixed(item.kg.truncateToDouble() == item.kg ? 0 : 1)} KG'),
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.price == 0
                                ? 'Free'
                                : '${item.price.toStringAsFixed(item.price.truncateToDouble() == item.price ? 0 : 1)} ${trip.currency}',
                            style: AppTheme.title,
                          ),
                          const Text('Per KG'),
                        ],
                      ),
                    );
                  }),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Send Request'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
