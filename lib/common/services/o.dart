import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class O extends GetxService {
  
  static O get to => Get.find();

  late final Dio _dio;

  @override
  void onInit() {
    super.onInit();

    var options = BaseOptions(
      baseUrl: "https://t8.supojen.com",
      followRedirects: false,
      maxRedirects: 0,
    );

    _dio = Dio(options);

    _dio.interceptors.add(CookieManager(CookieJar()));

    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      responseHeader: true, 
    ));

    //_dio.interceptors.add(InterceptorsWrapper(
    //  onResponse: (response, handler) async {
    //    if(response.statusCode == 302) {
    //
    //      final location = response.headers['location']?.first;
    //      if(location != null) {
    //        return handler.resolve(await _dio.get(location));
    //      }
    //    }
    //    handler.next(response);
    //  }
    //));
    
  }


  Future login() async {
    
      //var result = await FlutterWebAuth2.authenticate(
      //  url: "https://t8.supojen.com/api/login/line", 
      //  callbackUrlScheme: "xiao_hong_mao"
      //);

      try {
        await _dio.get('/api/login/line');

      } on DioException catch (e)  {
        
        if(e.response?.statusCode == 302) {
          
          final lineLoginUri = e.response?.headers['location']?.first;    
        
          if(lineLoginUri!= null) {
            try{
              await _dio.get(lineLoginUri);
            } on DioException catch (e) {

              if(e.response?.statusCode == 302) {
                final rawCookie = e.response?.headers['set-cookie']?.first.split(';').first;
                final authorizeUri = e.response?.headers['location']?.first;
                if(authorizeUri != null) {


                  try {
                    _dio.options.headers['cookie'] = rawCookie;
                    final k = await _dio.get(authorizeUri);
                  } on DioException catch (e) {
                    final location = e.response?.headers['location']?.first;
                  }
                }
              }
            }

          }
        }
      }
  }
  
}
