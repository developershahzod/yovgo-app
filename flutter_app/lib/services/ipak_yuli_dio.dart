import 'package:dio/dio.dart';

/// Default Dio factory (web) — no SSL bypass possible
Dio createIpakYuliDio() {
  return Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));
}
