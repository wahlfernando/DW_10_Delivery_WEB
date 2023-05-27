import 'package:dio/browser.dart';
import 'package:dio/dio.dart';

import '../env/env.dart';
import '../storage/storage.dart';
import 'interceptors/auth_interceptor.dart';

class CustonDio extends DioForBrowser {
  late AuthInterceptor _authInterceptor;
  CustonDio(Storage storage)
      : super(
          BaseOptions(
            baseUrl: Env.instance.get('backend_base_url'),
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 60),
          ),
        ) {
    interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
    );
    _authInterceptor = AuthInterceptor(storage);
  }

  CustonDio auth() {
    if (!interceptors.contains(_authInterceptor)) {
      interceptors.add(_authInterceptor);
    }

    return this;
  }

  CustonDio unauth() {
    interceptors.remove(_authInterceptor);
    return this;
  }
}
