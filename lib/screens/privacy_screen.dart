import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:travel_app/service/t_c_service.dart';

class PrivacyScreen extends StatefulWidget {
  static const String routeName = '/privacy';

  const PrivacyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool isLoading = true;
  String htmlData = '';

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      try {
        final html = await TAndCService().scrapPrivacy();
        setState(() {
          htmlData = html;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Privacy Policy'),
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
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0).copyWith(top: 0),
                    child: Html(
                      data: htmlData,
                      style: {
                        "body": Style(fontSize: const FontSize(18)),
                        "span": Style(fontSize: const FontSize(16)),
                      },
                    ),
                  ),
                ),
              ));
  }
}
