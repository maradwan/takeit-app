import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travel_app/widgets/form_section.dart';
import 'package:travel_app/widgets/input_widget.dart';

class ContactsScreen extends StatefulWidget {
  static const String routeName = '/contacts';
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  ContactsScreenState createState() => ContactsScreenState();
}

class ContactsScreenState extends State<ContactsScreen> {
  var isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        title: const Text('Contact Info'),
        actions: [
          isSaving
              ? Container(
                  width: 60,
                  alignment: Alignment.center,
                  child: const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                )
              : SizedBox(
                  width: 60,
                  child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          child: Form(
              child: Column(
            children: [
              FormSection(
                children: [
                  InputWidget(
                    suffixIcon: FontAwesomeIcons.solidUser,
                    hintText: 'Name',
                    //initialValue: price?.toString(),
                    onchaged: (value) {},
                  ),
                  const SizedBox(height: 10),
                  InputWidget(
                    suffixIcon: FontAwesomeIcons.phone,
                    hintText: 'Phone',
                    keyboardType: TextInputType.phone,
                    //initialValue: price?.toString(),
                    onchaged: (value) {},
                  ),
                  const SizedBox(height: 10),
                  InputWidget(
                    suffixIcon: FontAwesomeIcons.solidEnvelope,
                    hintText: 'E-mail',
                    //initialValue: price?.toString(),
                    onchaged: (value) {},
                  ),
                  const SizedBox(height: 10),
                  InputWidget(
                    suffixIcon: FontAwesomeIcons.facebook,
                    hintText: 'Facebook',
                    //initialValue: price?.toString(),
                    onchaged: (value) {},
                  ),
                  const SizedBox(height: 10),
                  InputWidget(
                    suffixIcon: FontAwesomeIcons.instagramSquare,
                    hintText: 'Instagram',
                    //initialValue: price?.toString(),
                    onchaged: (value) {},
                  ),
                  const SizedBox(height: 10),
                  InputWidget(
                    suffixIcon: FontAwesomeIcons.twitter,
                    hintText: 'Twitter',
                    //initialValue: price?.toString(),
                    onchaged: (value) {},
                  ),
                  const SizedBox(height: 10),
                  InputWidget(
                    suffixIcon: FontAwesomeIcons.linkedin,
                    hintText: 'LinkedIn',
                    //initialValue: price?.toString(),
                    onchaged: (value) {},
                  ),
                  const SizedBox(height: 10),
                  InputWidget(
                    suffixIcon: FontAwesomeIcons.telegram,
                    hintText: 'Telegram',
                    //initialValue: price?.toString(),
                    onchaged: (value) {},
                  ),
                ],
              ),
            ],
          )),
        ),
      ),
    );
  }
}
