import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:travel_app/model/contacts.dart';
import 'package:travel_app/providers/global_provider.dart';
import 'package:travel_app/service/contacts_service.dart';
import 'package:travel_app/widgets/form_section.dart';
import 'package:travel_app/widgets/input_widget.dart';

class ContactsScreen extends StatefulWidget {
  static const String routeName = '/contacts';
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  ContactsScreenState createState() => ContactsScreenState();
}

class ContactsScreenState extends State<ContactsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var isSaving = false;
  bool isInit = true;
  bool isLoading = true;

  final Map<String, dynamic> _formData = {
    'name': null,
    'phone': null,
    'email': null,
    'facebook': null,
    'instagram': null,
    'twitter': null,
    'linkedin': null,
    'telegram': null,
  };
  late Contacts? contacts;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      try {
        final existingContacts =
            await ContactsService().findLoggedInUserContacts();

        if (!mounted) {
          return;
        }

        final globalProvider =
            Provider.of<GlobalProvider>(context, listen: false);
        setState(() {
          _formData['name'] = existingContacts?.name ?? globalProvider.name;
          _formData['phone'] = existingContacts?.mobile;
          _formData['email'] = existingContacts?.email;
          _formData['facebook'] = existingContacts?.facebook;
          _formData['instagram'] = existingContacts?.instagram;
          _formData['twitter'] = existingContacts?.twitter;
          _formData['linkedin'] = existingContacts?.linkedIn;
          _formData['telegram'] = existingContacts?.telegram;
          contacts = existingContacts;
        });
      } on HttpException catch (e) {
        debugPrint(e.message);
      }
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  void _showSnackbar(String message, String type) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: type == 'error' ? Colors.red[700] : Colors.teal[700],
    ));
  }

  Future<void> _saveContacts() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_formData['name'] == null || (_formData['name'] as String).isEmpty) {
      _showSnackbar('You must enter a name', 'error');
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      isSaving = true;
    });

    try {
      final contacts = Contacts(
        null,
        _formData['name'],
        _formData['phone'],
        _formData['email'],
        _formData['facebook'],
        _formData['instagram'],
        _formData['twitter'],
        _formData['linkedin'],
        _formData['telegram'],
      );
      await ContactsService().save(contacts);
      await Amplify.Auth.updateUserAttribute(
        userAttributeKey: CognitoUserAttributeKey.name,
        value: _formData['name'],
      );
      if (mounted) {
        await Provider.of<GlobalProvider>(context, listen: false)
            .loadUserdata();
      }
      _showSnackbar('Contacts saved successfully', 'success');
    } on HttpException catch (e) {
      debugPrint(e.message);
      _showSnackbar('Something went wrong, try again', 'error');
    }

    setState(() {
      isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final globalProvider = Provider.of<GlobalProvider>(context, listen: false);
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
                    onPressed: _saveContacts,
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
        ],
      ),
      body: isLoading
          ? const Center(
              child: SizedBox(
                width: 60,
                child: LoadingIndicator(
                  strokeWidth: 1,
                  indicatorType: Indicator.ballPulse,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        FormSection(
                          children: [
                            InputWidget(
                              suffixIcon: FontAwesomeIcons.solidUser,
                              hintText: 'Name',
                              initialValue:
                                  contacts?.name ?? globalProvider.name,
                              onchaged: (value) => _formData['name'] = value,
                            ),
                            const SizedBox(height: 10),
                            InputWidget(
                              suffixIcon: FontAwesomeIcons.phone,
                              hintText: 'Phone',
                              keyboardType: TextInputType.phone,
                              initialValue: contacts?.mobile,
                              onchaged: (value) => _formData['phone'] = value,
                            ),
                            const SizedBox(height: 10),
                            InputWidget(
                              suffixIcon: FontAwesomeIcons.solidEnvelope,
                              hintText: 'E-mail',
                              initialValue: contacts?.email,
                              onchaged: (value) => _formData['email'] = value,
                            ),
                            const SizedBox(height: 10),
                            InputWidget(
                              suffixIcon: FontAwesomeIcons.facebook,
                              hintText: 'Facebook',
                              initialValue: contacts?.facebook,
                              onchaged: (value) =>
                                  _formData['facebook'] = value,
                            ),
                            const SizedBox(height: 10),
                            InputWidget(
                              suffixIcon: FontAwesomeIcons.instagramSquare,
                              hintText: 'Instagram',
                              initialValue: contacts?.instagram,
                              onchaged: (value) =>
                                  _formData['instagram'] = value,
                            ),
                            const SizedBox(height: 10),
                            InputWidget(
                              suffixIcon: FontAwesomeIcons.twitter,
                              hintText: 'Twitter',
                              initialValue: contacts?.twitter,
                              onchaged: (value) => _formData['twitter'] = value,
                            ),
                            const SizedBox(height: 10),
                            InputWidget(
                              suffixIcon: FontAwesomeIcons.linkedin,
                              hintText: 'LinkedIn',
                              initialValue: contacts?.linkedIn,
                              onchaged: (value) =>
                                  _formData['linkedin'] = value,
                            ),
                            const SizedBox(height: 10),
                            InputWidget(
                              suffixIcon: FontAwesomeIcons.telegram,
                              hintText: 'Telegram',
                              initialValue: contacts?.telegram,
                              onchaged: (value) =>
                                  _formData['telegram'] = value,
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
