import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:travel_app/service/t_c_service.dart';

class TAndC extends StatefulWidget {
  static const String routeName = '/t-and-c';

  const TAndC({Key? key}) : super(key: key);

  @override
  State<TAndC> createState() => _TAndCState();
}

class _TAndCState extends State<TAndC> {
  bool isLoading = true;
  String htmlData = '';

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      try {
        final html = await TAndCService().scrapTC();
        setState(() {
          htmlData = html;
        });
      } catch (e) {
        debugPrint(e.toString());
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
          title: const Text('Terms And Conditions'),
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
                    padding: const EdgeInsets.all(10),
                    child: Html(
                      data: htmlData,
                      style: {
                        "body": Style(fontSize: FontSize(18)),
                        "span": Style(fontSize: FontSize(16)),
                      },
                    ),
                  ),
                ),
              ));
  }
}
