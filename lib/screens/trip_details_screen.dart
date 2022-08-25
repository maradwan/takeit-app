import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TripDetailsScreen extends StatelessWidget {
  static const String routeName = '/trip-details';

  const TripDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Row(
          children: const [
            Text('Berlin'),
            SizedBox(width: 20),
            Icon(FontAwesomeIcons.plane),
            SizedBox(width: 20),
            Text('Cairo'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const DetailsRow(
                  icon: FontAwesomeIcons.syringe,
                  text: 'Medicine',
                  price: 0,
                ),
                const Seperator(),
                const DetailsRow(
                  icon: FontAwesomeIcons.file,
                  text: 'Paper',
                  price: 0,
                ),
                const Seperator(),
                const DetailsRow(
                  icon: FontAwesomeIcons.shirt,
                  text: 'Clothes',
                  price: 10,
                ),
                const Seperator(),
                const DetailsRow(
                  icon: FontAwesomeIcons.box,
                  text: 'Others',
                  price: 12,
                ),
                const SizedBox(height: 20),
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
    );
  }
}

class DetailsRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final double price;
  const DetailsRow({
    Key? key,
    required this.icon,
    required this.text,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colors.teal,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
        Text(
          price == 0 ? 'Free' : '€$price',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class Seperator extends StatelessWidget {
  const Seperator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 10),
        Divider(color: Colors.black38),
        SizedBox(width: 10),
      ],
    );
  }
}
