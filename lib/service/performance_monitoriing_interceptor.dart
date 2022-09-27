import 'package:firebase_performance/firebase_performance.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';

class PerformanceMonitoringInterceptor implements InterceptorContract {
  Map<String, HttpMetric> _metrics = {};

  HttpMethod _mapMethod(Method method) {
    switch (method) {
      case Method.HEAD:
        return HttpMethod.Head;
      case Method.GET:
        return HttpMethod.Get;
      case Method.POST:
        return HttpMethod.Post;
      case Method.PUT:
        return HttpMethod.Put;
      case Method.PATCH:
        return HttpMethod.Patch;
      case Method.DELETE:
        return HttpMethod.Delete;
    }
  }

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    final url = data.url;
    final HttpMetric metric = FirebasePerformance.instance.newHttpMetric(
      url,
      _mapMethod(data.method),
    );
    _metrics[url] = metric;
    await metric.start();
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    final metric = _metrics[data.url];
    if (metric != null) {
      metric
        ..responsePayloadSize = data.contentLength
        ..responseContentType = data.headers?['content-type']
        ..requestPayloadSize = data.contentLength
        ..httpResponseCode = data.statusCode;
      await metric.stop();
    }
    _metrics.remove(data.url);
    return data;
  }
}
