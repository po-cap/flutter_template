import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;

import '../index.dart';

class WPHttpService extends GetxService {
  static WPHttpService get to => Get.find();

  late final Dio _dio;
  // final CancelToken _cancelToken = CancelToken(); // 默认去掉

  @override
  void onInit() {
    super.onInit();

    // 初始 dio
    var options = BaseOptions(
      baseUrl: Constants.wpApiBaseUrl,
      connectTimeout: const Duration(seconds: 10), // 10000, // 10秒
      receiveTimeout: const Duration(seconds: 5), // 5000, // 5秒
      headers: {},
      contentType: 'application/json; charset=utf-8',
      responseType: ResponseType.json,
    );
    _dio = Dio(options);

    // 日誌
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      responseHeader: true, 
    ));

    // 拦截器
    _dio.interceptors.add(RequestInterceptors());
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Options requestOptions = options ?? Options();
    Response response = await _dio.get(
      url,
      queryParameters: params,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  Future<Response> post(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var requestOptions = options ?? Options();
    Response response = await _dio.post(
      url,
      data: data ?? {},
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  Future<Response> put(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var requestOptions = options ?? Options();
    Response response = await _dio.put(
      url,
      data: data ?? {},
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  Future<Response> delete(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    var requestOptions = options ?? Options();
    Response response = await _dio.delete(
      url,
      data: data ?? {},
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

}


/// 拦截
class RequestInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // super.onRequest(options, handler);

    // http header 头加入 Authorization
    if (UserService.to.hasToken) {
      options.headers['Authorization'] = 'Bearer ${UserService.to.accessToken}';
    }

    return handler.next(options);
    // 如果你想完成请求并返回一些自定义数据，你可以resolve一个Response对象 `handler.resolve(response)`。
    // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义response.
    //
    // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象,如`handler.reject(error)`，
    // 这样请求将被中止并触发异常，上层catchError会被调用。
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 200 请求成功, 201 添加成功
    if (response.statusCode != 200 && response.statusCode != 201) {
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ),
        true,
      );
    } else {
      handler.next(response);
    }
  }

  @override
  Future<void> onError(
    DioException err, 
    ErrorInterceptorHandler handler
  ) async {
      
      final exception = HttpException(err.message ?? "error message");

      switch (err.type) {
        case DioExceptionType.badResponse:
          {
            final response = err.response;
            final errorMessage = ErrorMessageModel.fromJson(response?.data);
            switch (errorMessage.status) {
              // 401 未登录
              case 401:
                // 注销 并跳转到登录页面
                _errorNoAuth();
                break;
              case 404:
                break;
              case 500:
                break;
              case 502:
                break;
              default:
                break;
            }
            Loading.error(errorMessage.title);
          }
          break;
        case DioExceptionType.unknown:
          break;
        case DioExceptionType.cancel:
          break;
        case DioExceptionType.connectionTimeout:
          break;
        default:
          break;
      }
      
      DioException errNext = err.copyWith(
        error: exception,
      );
    
      handler.next(errNext);
  }

  // 退出并重新登录
  Future<void> _errorNoAuth() async {
    
    try {
      // 刷新 token
      final token = await UserApi.refreshToken();
      // 儲存 token
      await UserService.to.setToken(token);
      // 取得使用者資料
      await UserService.to.getProfile();
    } catch (e) {
      // 登出
      await UserService.to.logout();
      // 跳转到登录
      Get.toNamed(RouteNames.systemLogin);
    }
  }
}

