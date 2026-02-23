import 'package:dio/dio.dart';

/// Native Dio factory (Android/iOS) — production IpakYuli has valid SSL cert
Dio createIpakYuliDio() {
  return Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));
}
