import 'package:dio/dio.dart';
import 'package:get/utils.dart';
import 'package:template/common/index.dart';

class UserApi {

  // get - 用戶資訊
  static Future<UserProfileModel> profile() async {
    var res = await WPHttpService.to.get(
      '/oauth/information',
    );
    return UserProfileModel.fromJson(res.data);
  }

  static Future<UserTokenModel> login(UserLoginReq req) async {

    try{

      Dio     dio;
      String? authorizeEndpoint;
      String? callbackCookie;
      String? authorizeCookie;
      String? cbEndpoint;

      // 初始 dio
      var options = BaseOptions(
        baseUrl: Constants.wpApiBaseUrl,
        followRedirects: false,
        maxRedirects: 0
      );
      dio = Dio(options);

      // 第一步：取得
      //     1) Authrization Endpoint
      //     2) Callback Cookie (Callback Endpoint 要用到的 cookie)
      try {
        await dio.get("/api/login/xiao_hong_mao");
      } on DioException catch (e) {
        if(e.response?.statusCode != 302) {
          throw Exception();
        }
        authorizeEndpoint = e.response?.headers['location']?.first;
        callbackCookie = e.response?.headers['set-cookie']?.first.split(';').first;
      }
      if (authorizeEndpoint == null) {
        throw Exception();
      }

      // 第二步：取得
      //     1) Authorize Cookie(Authization Endpoint 要用到的 cookie)
      try {
        await dio.get(authorizeEndpoint);
      } on DioException catch (e) {
        if(e.response?.statusCode != 302) {
          throw Exception();
        }

        authorizeCookie = e.response?.headers['set-cookie']?.first.split(';').first;
      }
      if (authorizeCookie == null) {
        throw Exception();
      }

      // 第三步：登入
      await dio.post(
        "/oauth/login?redirectUri=$authorizeEndpoint",
        options: Options(
          headers: {'cookie': authorizeCookie}
        ), 
        data: req.toJson()
      );

      // 第四步：取得 Code (打 authorization endpoint)
      try {
        await dio.get(authorizeEndpoint);
      } on DioException catch (e) {
        if(e.response?.statusCode != 302) {
          throw Exception();
        }

        cbEndpoint = e.response?.headers['location']?.first;
      }
      if (cbEndpoint == null) {
        throw Exception();
      }

      // 第四步：取得 Token (打 callback endpoint)
      final tokenResponse = await dio.get(
        cbEndpoint,
        options: Options(
          headers: {'cookie': callbackCookie}
        )
      );

      return UserTokenModel.fromJson(tokenResponse.data);

    } catch(e) {
      Loading.error(LocaleKeys.loginFailure.tr);
      rethrow;
    }

  }


  // 從 callback endpoint 中得到 token
  static Future<UserTokenModel> loginFromCB(
    String cbEndpoint,
    String cookie
  ) async {
    var response = await WPHttpService.to.get(
      cbEndpoint,
      options: Options(
        headers: {'cookie': cookie}
      )
    );
    return UserTokenModel.fromJson(response.data);
  }

}