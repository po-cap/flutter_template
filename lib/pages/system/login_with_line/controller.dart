import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginWithLineController extends GetxController {
  LoginWithLineController();

  WebViewController? webViewController;

  @override
  void onInit() async {
    super.onInit();

    try {

      Loading.show();

      // 初始 dio (用來取得 login 的 cookie)
      var options = BaseOptions(
        baseUrl: Constants.wpApiBaseUrl,
        followRedirects: false,
        maxRedirects: 0
      );
      final dio = Dio(options);
    
      
      // 取得 login 的 cookie
      late String? lineLoginUri;
      late String? cookie;
      try {
        await dio.get('/api/login/line');
      } on DioException catch (e) {
        if(e.response?.statusCode != 302) {
          debugPrint('statusCode is $e.response?.statusCode');
          throw Exception("statusCode is not 302");
        }
        lineLoginUri = e.response?.headers['location']?.first;
        cookie = e.response?.headers['set-cookie']?.first.split(';').first;
      }

      // 取得 login 的 Web Page
      webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) async {
            if(request.url.startsWith('https://t8.supojen.com/api/line/auth-cb')) {
              Loading.show();
      
              // 取得 token
              final token = await UserApi.loginFromCB(request.url,cookie ?? '');
      
              // 儲存 token
              await UserService.to.setToken(token);
      
              // 取得使用者資料
              await UserService.to.getProfile();
      
              Loading.success();
              Get.offNamed(RouteNames.systemMain);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        )
      )
      ..loadRequest(Uri.parse(lineLoginUri ?? ''));
    
      update(["login_with_line"]);
    } finally {
      Loading.dismiss();
    }
  }

  @override
  void onClose() {
    super.onClose();
    webViewController?.clearCache(); 
  }
}
