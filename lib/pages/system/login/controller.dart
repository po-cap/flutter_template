import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:template/common/index.dart';


class LoginController extends GetxController {
  LoginController();

  /// 表单 key
  GlobalKey formKey = GlobalKey<FormState>();

  /// 郵箱
  TextEditingController emailController = TextEditingController();
  
  /// 密碼
  TextEditingController passwordController = TextEditingController();

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
    Get.toNamed(RouteNames.systemLoginWithLine);
  }

  /// 释放
  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    passwordController.dispose();
  }
}
