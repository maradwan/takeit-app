import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:travel_app/service/performance_monitoriing_interceptor.dart';

Client httpClient = InterceptedClient.build(
  interceptors: [
    PerformanceMonitoringInterceptor(),
  ],
);
