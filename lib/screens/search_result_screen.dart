import 'package:flutter/material.dart';
import 'package:travel_app/widgets/weight_card.dart';

class SearchResultScreen extends StatelessWidget {
  static const String routeName = '/search-result';

  const SearchResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        title: const Text('Avaliable Trips'),
        titleTextStyle: const TextStyle(fontSize: 18),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sorted By',
                  style: TextStyle(color: Colors.grey[800]),
                ),
                Row(
                  children: [
                    Text(
                      'Arrival Ascending',
                      style: TextStyle(color: Colors.teal[700]),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.teal[700],
                    ),
                  ],
                ),
              ],
            ),
            const WeightCard(
              from: 'Berlin',
              to: 'Cairo',
              arrival: '23 Oct 2022',
              weight: '14',
            ),
            const WeightCard(
              from: 'Berlin',
              to: 'Alexandria',
              arrival: '02 Nov 2022',
              weight: '8',
            ),
            const WeightCard(
              from: 'Berlin',
              to: 'Hamburg',
              arrival: '12 Oct 2022',
              weight: '2',
            ),
            const WeightCard(
              from: 'Berlin',
              to: 'Cairo',
              arrival: '23 Oct 2022',
              weight: '14',
            ),
            const WeightCard(
              from: 'Berlin',
              to: 'Cairo',
              arrival: '23 Oct 2022',
              weight: '14',
            ),
          ],
        ),
      ),
    );
  }
}
