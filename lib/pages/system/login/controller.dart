import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';
import 'package:webview_flutter/webview_flutter.dart';


class LoginController extends GetxController {
  LoginController();

  /// 表单 key
  GlobalKey formKey = GlobalKey<FormState>();

  /// 郵箱
  TextEditingController emailController = TextEditingController();
  
  /// 密碼
  TextEditingController passwordController = TextEditingController();

  WebViewController? webViewController;


  _initData() {
    update(["login"]);
  }

  /// Sign In 登入
  Future<void> onSignIn() async {
    if ((formKey.currentState as FormState).validate()) {
      try {
        Loading.show();
    
        // api 請求
        final token = await UserApi.login(UserLoginReq(
          email: emailController.text,
          password: passwordController.text
        ));

        // 儲存 token
        await UserService.to.setToken(token);

        // 取得使用者資料
        await UserService.to.getProfile();

        Loading.success();
        Get.back(result: true);
      } finally {
        Loading.dismiss();
      }
    }
  }

  Future<void> onSignInWithLine() async {

    Loading.show();

    var options = BaseOptions(
      baseUrl: Constants.wpApiBaseUrl,
      followRedirects: false,
      maxRedirects: 0
    );
    final dio = Dio(options);
    

    late String? lineLoginUri;
    late String? cookie;
    try {
      await dio.get('/api/login/line');
    } on DioException catch (e) {
      if(e.response?.statusCode != 302) {
        throw Exception("statusCode is not 302");
      }
      lineLoginUri = e.response?.headers['location']?.first;
      cookie = e.response?.headers['set-cookie']?.first.split(';').first;
    }


    debugPrint("onSignInWithLine");

    try {
      
      webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) async {
            if(request.url.startsWith('https://t8.supojen.com/api/line/auth-cb')) {
              Loading.show();
      
              // 取得 token
              final token = await UserApi.callback(request.url,cookie ?? '');
      
              // 儲存 token
              await UserService.to.setToken(token);
      
              // 取得使用者資料
              await UserService.to.getProfile();
      
              Loading.success();
              Get.back(result: true);
              return NavigationDecision.prevent;
            }
            debugPrint('Navigation to: ${request.url}');
            return NavigationDecision.navigate;
          },
        )
      )
      ..loadRequest(Uri.parse(lineLoginUri ?? ''));
    
      update(["login"]);
    } finally {
      Loading.dismiss();
    }
  }


   @override
   void onInit() {
     super.onInit();
     _initData();
   }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  /// 释放
  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    passwordController.dispose();
  }
}
