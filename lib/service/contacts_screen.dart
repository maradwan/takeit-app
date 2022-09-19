import 'package:flutter/material.dart';

class ContactsScreen extends StatefulWidget {
  static const String routeName = '/contacts';
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  ContactsScreenState createState() => ContactsScreenState();
}

class ContactsScreenState extends State<ContactsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('This is contact screen'),
      ),
    );
  }
}
