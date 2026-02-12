import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

/// Native Dio factory (Android/iOS) — skips SSL verification for staging
Dio createIpakYuliDio() {
  final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));
  dio.httpClientAdapter = IOHttpClientAdapter(
    createHttpClient: () {
      final client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    },
  );
  return dio;
}
