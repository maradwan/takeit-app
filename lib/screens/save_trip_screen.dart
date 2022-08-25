import 'package:flutter/material.dart';
import 'package:travel_app/widgets/form_section.dart';

class SaveTripScreen extends StatefulWidget {
  static const String routeName = '/save-trip';
  const SaveTripScreen({Key? key}) : super(key: key);

  @override
  _SaveTripScreenState createState() => _SaveTripScreenState();
}

class _SaveTripScreenState extends State<SaveTripScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Save Trip'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Form(
            key: _formKey,
            child: Column(
              children: const [
                FormSection(
                  title: 'Trip Details',
                  children: [],
                ),
              ],
            )),
      ),
    );
  }
}
