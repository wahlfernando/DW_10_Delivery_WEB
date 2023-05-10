import 'package:dio/browser.dart';
import 'package:dio/dio.dart';

import '../env/env.dart';

class CustonDio extends DioForBrowser {
  CustonDio()
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
  }

  CustonDio auth(){
    return this;
  }

  CustonDio unauth(){
    return this;
  }

}
