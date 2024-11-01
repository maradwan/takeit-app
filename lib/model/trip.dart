import 'package:intl/intl.dart';
import 'package:travel_app/model/item.dart';

class Trip {
  final String? created;
  final String? username;
  final DateTime acceptFrom;
  final DateTime acceptTo;
  final DateTime trDate;
  final String fromCity;
  final String toCity;
  final String currency;
  final List<Item> allowedItems;
  final DateTime? updated;

  Trip(
    this.created,
    this.username,
    this.acceptFrom,
    this.acceptTo,
    this.trDate,
    this.fromCity,
    this.toCity,
    this.currency,
    this.allowedItems,
    this.updated,
  );

  Map<String, dynamic> toJson() {
    Map<String, Map<String, dynamic>> itemsMap = {};

    for (var item in allowedItems) {
      itemsMap.putIfAbsent(item.name, () => item.toJson());
    }
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    return {
      'acceptfrom': formatter.format(acceptFrom),
      'acceptto': formatter.format(acceptTo),
      'allowed': itemsMap,
      'fromcity': fromCity,
      'tocity': toCity,
      'trdate': formatter.format(trDate),
      'currency': currency,
    };
  }
}
